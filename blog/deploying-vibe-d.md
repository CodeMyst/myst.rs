---
title: Deploying vibe.d apps with GitHub Actions
summary: Guide on how to deploy vibe.d web applications to your server using GitHub Actions
date: 2021-03-16
link: deploying-vibed
---

## Backstory

> If you don't care for the backstory you can totally skip this chapter. And if you just want the complete script you can scroll to the end.

Let's begin with some backstory first. If you do not know who I am, I created [pastemyst](https://paste.myst.rs/), a pastebin clone of sorts (that is actually better than pastebin!). It is hosted on a cheap $5/m Vultr instance (very good VPS host, can recommend, use my referral link if you plan on getting an instance: [Vultr ref](https://www.vultr.com/?ref=8377973-6G)), and ever since the huge 2.0 update of pastemyst building the program on that instance with just 1 CPU and 1gb of RAM was impossible because of the scale of the application. The biggest memory usage are the view templates because they get generated at compile time.

There were a couple of solutions to this. First was using swap memory which was a failure, even with the additional 2gb of swap dmd kept crashing with the out of memory error. Next I tried compiling it on my machine and uploading it to the server with scp, but alas, my genius didn't last for long. I run Arch Linux on my machine (I use arch btw) which of course has every lib that ever existed updated to the most recent version there is, while my server running Ubuntu 18.04 (ancient I know) does not. Curse me and my obsession with being the cool kid who uses Arch (I am cool... right??). The library in issue was glibc, I tried updating it on the server (which can't build it from source because it's not very powerful as we established) and installing the same old version on my machine, but couldn't figure it out. So to the next obvious solution we go.

VMs are a wonderful thing, you can run any OS of any version inside your other **better** OS. I installed the same version of Ubuntu in a VM using qemu, built pastemyst on that and uploaded to the server. And finally it worked! It was a long and painful process but I got pastemyst v2 running on the server and every user was amazed by the new version and my hard work paid off (I still don't make any money from it though). With this approach it took a while to boot up the VM, and build pastemyst (which still wasn't blazing fast because it's a VM) and my upload speed is super slow, so in the end it effectively took around 30 minutes to get a build onto the server, but with no other way in mind I settled with it, I don't release a new version too frequently anyway. But ha! I found a better way, I bet you couldn't guess this was going to happen, my genius didn't reach its limit just yet!

## Using GitHub Actions

So while being bored one day I realized that hey, I can use the fancy GitHub Actions (which I used so far for building and testing every commit) to also build pastemyst and upload to the server. It took a bit of tinkering but I got it to work and the result is pretty simple.

Let's go step by step on how I got to the final result. First you will need to create a new workflow script (which is actually just a YAML file... why GitHub, why... [relevant article](https://blog.atomist.com/in-defense-of-yaml/)). The workflow files are located in `.github/workflows/`.

So do you want to deploy your program on every commit to the main branch? No you don't, but GitHub has a solution for that! You can set the workflow to execute `on: workflow_dispatch` and so you will have a nice big button to press every time you want to deploy. You could make this execute on every new tag / release if you Googled hard enough.

```yml
name: Deploy to server

on: workflow_dispatch

jobs:
  deploy:
    name: Deploy to server
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
```

Let's add another step to install D, in this example I'm also downloading the libscrypt dependency and checking out all the submodules (which for some reason requires a third party plugin... why).

```yml
- name: install D
  uses: dlang-community/setup-dlang@v1
  with:
    compiler: dmd-latest
- name: Install libscrypt
  run: |
    sudo apt-get install libscrypt0
    sudo apt-get install libscrypt-dev
- name: Checkout submodules
  uses: srt32/git-actions@v0.0.3
  with:
    args: git submodule update --init --recursive
```

Time to now build the project in release mode.

```yml
- name: build
  run: dub build -b release
```

Now the interesting part. There's two more steps, copy the resulting binary to the server, and then ssh into the server and move the binary to the right place and then run git pull to get all necessary assets like css and stuff.

You should generate an SSH key on your local machine like so:

```sh
ssh-keygen -t rsa -b 4096 -C "your@mail"
```

When you execute the command it will ask you for the path, as you will use this SSH key just for the GitHub action make sure not to leave it as a default or it might overwrite your existing SSH key (you can delete the key from your local machine after you have this setup).

This is now a very important part, when it asks you for a passphrase leave it empty, I learned this the hard way after many times asking myself why isn't this working???? (I think you can set a passphrase and then provide a passphrase key to the action but I haven't tested this).

Go copy the public key and add it to your `~/.ssh/authorized_keys` files on your server, this allows anyone with the private key that matches the provided public key to ssh into the server, and in this case GitHub.

Now you should go into your GitHub repo, go to settings and open the Secrets section. You should add a new secret for the SSH username, host, port and private key. The SSH_SECRET should contain the private key you got from generating the SSH key.

![github secrets](/static/images/blog/github-secrets.png)

We can now add the SCP step to the workflow.

```yml
- name: upload to server
  uses: appleboy/scp-action@master
  with:
    host: ${{ secrets.SSH_HOST }}
    username: ${{ secrets.SSH_USER }}
    key: ${{ secrets.SSH_SECRET }}
    port: ${{ secrets.SSH_PORT }}
    source: "bin/pastemyst"
    target: "builds"
```

The source and target fields are weird, with the way I set them up from the example the binary ends up in `builds/bin/pastemyst` for some reason, but oh well, we are going to SSH into the server and move it anyway.

And for the final step.

```yml
- name: move binary and pull repo
  uses: appleboy/ssh-action@master
  with:
    host: ${{ secrets.SSH_HOST }}
    username: ${{ secrets.SSH_USER }}
    key: ${{ secrets.SSH_SECRET }}
    port: ${{ secrets.SSH_PORT }}
    script: |
      rm pastemyst/pastemyst
      mv builds/bin/pastemyst pastemyst/pastemyst
      cd pastemyst
      git pull origin main
```

The script first deletes the current binary file, then it moves the new one to the right place and finally pulls the repo.

You should now have a "Run workflow" button when you go to Actions -> Deploy to server -> Run  workflow

<img src="/static/images/blog/run-workflow.png" style="width: 350px;" />

If you did everything correctly your new program will now deploy super fast and you shouldn't need to do anything else (except maybe do `systemctl restart service`, but that can also be added to the script). But of course it won't work first try and you will end up with 10 commits saying "updated deploy script" and 10 failed workflow runs, but CI/CD do be like that.

![failed runs](/static/images/blog/failed-runs.png)

Also big thanks to GitHub for allowing us to run bad code on their servers for free.

## Full workflow

Here's the full workflow script for all your lazy people (or people who just want to get stuff done fast). And it's displayed using a pastemyst embed just to flex this amazing feature you should definitely use (if the script doesn't actually load let's just say this was the comedic part of the post).

<iframe src='https://paste.myst.rs/mjoufaht/embed' scrolling='no' style='border:none;'></iframe><script src='https://paste.myst.rs/static/scripts/libs/iframeResizer.js'></script><script>iFrameResize();</script>
