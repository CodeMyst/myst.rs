---
title: Self hosted password manager using Git and GPG
summary: Get complete control over your passwords using the unix pass utility and git
date: 2024-03-16
link: password-manager
---

---

I have been a long time proponent against using password managers, and the reason for that being I do not want to trust some third party company in storing my passwords properly and securely. And yes, I know that those companies have been in the business for a long while, and that even if their DB does get breached (which happens), the passwords would still be secure (probably). But I would like complete control over that (while also not paying anyone anything).

So instead of using password managers, for a long time I had a system for having *almost* unique passwords for all the services, while not writing them down anywhere! Essentially, all passwords follow the same template, and then using site information (like the site name for example) to fill that template in. I was quite satisfied with this solution, but it was definitely not perfect. The main reason was that the passwords didn't differ that much from each other, and another reason was websites with stupid password requirements which would force me to deviate from my password template, and then having to remember that deviation. And of course, being required to change passwords for some things on some set interval (for various security reasons), which was very difficult with this system.

I know about open source password managers that you can self host, like [bitwarden](https://bitwarden.com/). And honestly, you should probably just use that.

But I stumbled upon something a bit more interesting, and a lot more "simple" (simple as in the actual system is simple, but you will spend more time setting this up than using a service). It is the [pass](https://www.passwordstore.org/) unix utility. It is super simple, it stores generated passwords in a plain directory, and each password is a gpg encrypted file. And has quite a few options for how the passwords are generated. And that's it, nothing more.

Since it is a simple directory of files, you can use it as a git repository, and track password changes with it. And it does that for you, so you don't have to manually commit the changes. And since it's a git repostory, now you have unlimited options when it comes to hosting your password store. In my case, I use [github](https://github.com/), [gitlab](https://gitlab.com/) and my own self hosted [gitea](https://gitea.com/) instance as the remotes for the git repo. The repos are private, but even if somehow someone breached those services and got the repo data, it would still be a challenge to decrypt those files.

I'm not going to explain how to set it up, it's quite simple. There are executables for Windows, macOS and Linux, as well as apps for Android and iOS (which might be a bit more tricky to set up). And of course, there are also browser extensions ([browserpass](https://github.com/browserpass/browserpass-extension)), a Windows program ([pass-winmenu](https://github.com/geluk/pass-winmenu)), a macOS menu bar app ([Pass-for-macOS](https://github.com/adur1990/Pass-for-macOS)) and a cross-platform GUI app ([QtPass](https://github.com/geluk/pass-winmenu)) to make using those passwords easier (so you don't have to open your terminal every time you want to log in somewhere).

I have been using *pass* for quite some time now (around 2 years), and I am quite happy with it, because it just works, and I am in complete control over the entire process, so if my passwords do get leaked *somehow*, it will be my own fault.

Now would I recommend using *pass*? If you're a normal person, just pay for a password manager, or use the free tier of bitwarden. If you're a little bit less normal, self host your own bitwarden instance. But if you're more daring, and like to do things yourself, I would fully recommend pass.

You no longer have an excuse for having bad and insecure passwords, with so many options and approaches to password management, you're welcome.
