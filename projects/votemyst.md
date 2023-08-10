# About VoteMyst

A simple website for voting on user submitted content.

> * Language: C#
> * Web Framework: ASP.NET Core
> * DB: MySQL
> * Frontend: HTML, CSS, JS

Check out the [website](https://vote.myst.rs) and [source](https://github.com/codemyst/votemyst).

![votemyst - screenshot](/static/images/votemyst/votemyst.png)

Our team of staff in the [Brackeys Discord server](https://discord.gg/brackeys) started hosting occasional events, ranging from artwork to programming for the community. At first we used simple Discord channels in which users posted their submissions and everyone voted on the submissions with emote reactions.

![discord event](/static/images/votemyst/discord-event-1.png)

This worked pretty well in the beginning, when we didn't have a lot of participants, but as the server grew we ran into issues running events like this. So we added a feature to our bot which kept track of points, and automatically picked the winners, the problem with this approach was it was a bit buggy and still had a ton of issues like archiving past events and neutralizing the advantage of post order (later posts would get more votes because they're the first thing you see when you open the channel).

We tried solving the archiving problem by adding another feature to our bot which read every message and downloaded every image and kept track of votes, and the zipped it all up and uploaded it to the WeTransfer service ([WeTransfer.NET wrapper](https://github.com/CodeMyst/WeTransfer.NET)). This was not really optimal because someone had to keep the archive on their computer, and we couldn't reliably download all the images and make sure the bot handles images, videos and gifs and even text users posted along their submissions.

So we came up with an idea to build a simple website for these kind of events. By the time of writing we had one successfully hosted event on VoteMyst and things worked out pretty great. It still needs a lot of work but the main concept is there. And we are thinking of allowing anyone to make events at some point, current limiting factor is paying for hosting, which after even a couple of art events won't be cheap.
