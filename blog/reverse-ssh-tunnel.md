---
title: Expose local services using Reverse SSH Tunnels
summary: A guide on how to expose services running on localhost to the public internet using a reverse SSH tunnel
date: 2023-10-10
link: reverse-ssh-tunnel
---

---

If you ever need to temporarily expose a service running on localhost (your new fancy website for example) and you have a server of sorts (let's say a VPS) that's publicly accessible from the internet already (since you just love to self host everything), you can use a reverse SSH tunnel to forward your localhost traffic to your server.

Here's the command:

```bash
ssh -R 5125:localhost:5000 user@host.com
```

The first port number (5125 in this case) is the port on the remote machine where the traffic will be exposed to. You can then serve traffic from this port in whatever way you like. And the second port is your localhost port on which a service is running on.

This will tunnel the connection between your local machine and the remote server through the SSH connection. And once you kill that session, the tunnel stops.

I of course don't recommend serving anything like this for long periods of time, at that point you might as well properly host the app on the server directly. One good use case for this is receiving third party API calls. This is a good alternative to using services like [ngrok](https://ngrok.com/).

On my server I am running nginx and simply proxy passing port 5125 on some subdomain like so:

```nginx
server {
    server_name sub.domain.com;

    location / {
        proxy_pass http://127.0.0.1:5125;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /robots.txt {
        return 200 "User-agent: *\nDisallow: /";
    }
}
```

Nothing fancy, passing some headers so my apps work properly, and disallowing search engines to index it.

And that's it! Now the entire internet can access your absolute masterpiece of a web application!

