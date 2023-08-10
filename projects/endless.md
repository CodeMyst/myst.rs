# Post Mortem of Endless, Nameless

Submitted for Ludum Dare 40.

*This was written back in 2017, right after I submitted the game to the jam.*

> * Overall: 653rd (3.375 average from 30 ratings)
> * Fun: 415th (3.482 average from 30 ratings)
> * Innovation: 185th (3.679 average from 30 ratings)
> * Theme: 146th (4.018 average from 30 ratings)
> * Graphics: 947th (2.714 average from 30 ratings)
> * Audio: 630th (2.667 average from 29 ratings)
> * Humor: 571st (2.907 average from 29 ratings)
> * Mood: 797th (2.981 average from 28 ratings)

Endless, Nameless is a simple 2D platformer. You play over and over one level due to a time tear in the void. When you finish a level you get thrown back in time, but it’s not that simple. The level changes and one terrible (that’s right) is added.

The more levels you finish the more terribles are added.

Every fifth level you can choose which terribles to disable with the coins you collected.

You have to collect 15 coins to be able to buy a time bandage which fixes the time tear.

You can play the game here: [itch.io](https://codemyst.itch.io/endless-nameless).

![game screenshot](/static/images/endless/game.png)

## Before we begin

Since the last Ludum Dare (my first one) I haven’t been working on games as I have shifted my focus on other things. And also I am pretty bad at game design, or really anything creative, so I didn’t want to work on games by myself as they would turn out terribly in the end, if I wouldn’t abandon the project first.

I haven’t been much excited for this one and that may be the cause it started so terribly and without energy. Ludum Dare 40 wasn’t on a vacation, we had school, but at least it was the weekend so I was able to work most of the time.

## Day 1

I woke up at 9 am and the first thing I did was open the Ludum Dare website to check the time. After seeing what the theme was I immediately thought “crap”. The theme was “the more you have, the worse it gets”. It was my least favourite theme and I lost all confidence I had. No idea came to my mind, I was scared.

I let it go for now. I should first wake up properly, wash my face, get something to eat and then get into the proper mindset.

After a nice breakfast I sat down in front of my computer hoping I would come up with some sort of idea, at least something that it is good enough for a game. I came up with two ideas in a span of an hour. They were boring and not something I wanted to make. The next thing I did was what I always do, open Discord and complain to others. To my rescue came Snowy. He didn’t participate in LD because he had a lot of studying to do, but he gave me an excellent idea for a game. The moment I read the idea I got excited. Finally something that made me happy about this jam.

The idea was that it was a simple platformer where you replay a level over and over again. Every time you finish the level you get a “terrible” added. I didn’t have time to make a lot of them but these are the ones that got in the game: slower speed, inverted gravity, black and white screen, spikes, patrolling enemy, falling lava lamps, zoomed in camera, smaller jump (but you get a double jump), broken controls, a wall that blocks one way to the exit.

I got started working on placeholder assets and first time got to use Unity’s new tile system. I expected more from it but it’s still quite new and I haven’t checked all of its features yet.

The game’s idea kind of reminded me of an awesome game for Android “That Level Again” so I got the inspiration for level design from it. The level wasn’t (and still isn’t) polished enough, but it was enough for now.

I knew I was going for a pixel art style from the beginning since that’s what I can do the best. Didn’t even want to think about making a game in 3D. I spent a lot of time on the graphics, and it was tedious to make different sprites for different tile variations. And that’s where I wasted a lot of my time as later I switched to a “vectorized” style and I had to draw all the variations again.

![pixel art style](/static/images/endless/pixel.png)

First started with pixel art

![vector art style](/static/images/endless/grass.png)

Ended with this

So far I had decent graphics, but that was all I had. So I started working on a character controller. I needed to make something more customizable as I needed to adjust controller’s parameters easily for the terribles. I didn’t write it from the scratch, I used a Unity tutorial for reference, since I don’t really know how to make one by myself and for it to feel nice.

Next, I added the first terrible called “FTH Gamer”, it switched the controls to F, T and H buttons. It was the easiest to implement and it was mostly just to see how I would go about implementing other terribles.

I always have a tendency to shift my focus from things. I was working on writing an elegant way to handle terribles, which turned out terribly (get it? 😉), and I suddenly got an urge to work on the main menu. My first plan was not to have a lot of words in the game, and I also wanted to make the cat (player) speak in forms of speech bubbles, but it would only meow. I settled on a simple menu with the game’s title, the main character and a button saying “MEOW” which was the start button.

![title screen](/static/images/endless/titlescreen.png)

And that wraps up the first day.

## Day 2

I went back to working on the “terrible system” and I got it working pretty fast. It added a random terrible each time you finished a level.

One or two terribles obviously weren’t enough so I started working on the reversed gravity terrible. Even though the character controller was easily adjusted for this to work I had weird issues where the player wouldn’t move when the gravity was reversed. After a lot of time tinkering with it I found the solution. Of course it was something obvious, the player wasn’t considered grounded with the reverse gravity. It was an easy fix and it worked like a charm.

The whole day I spent on adding terribles, a way to notify the user which terrible he got, some basic music which was there just for the sake of having it, a shop where you could disable terribles for coins and a small ending, to reward the player in some way. I was rushing because it felt like I didn’t have enough time to finish for the compo. I thought I will most likely need to submit for the jam instead. I finished off everything I could and submitted in the last minutes (at least last minutes for me). I felt happy and relieved. It was wonderful.

Someone on a Discord server ([Brackeys Discord Server](https://discord.gg/brackeys)) said he played it and everything was broken. I was devastated, seemed like time froze, I was scared. There were all kinds of problems: player getting stuck, collisions weren’t working, crashes, freezes, terribles not working. I had to fix the game next day and submit for the jam.

## Day 3

Third day, a day I hadn’t anticipated I’ll be working on. It was a school day so I didn’t have much time to work on it, but all I could think of in school was my game and its broken state.

Immediately when I came home I powered my computer on and got to work. Most of the problems were easily fixable and I was able to fix all bugs quickly.

I was submitting for the jam so I added some more content in the “extra” time I got.

I published the game, playtested it and gave it to a couple of people. They were having fun playing it and it was all worth it in the end. All the struggle and the stress.

## Conclusion

All in all this Ludum Dare was pretty fun. I had fun making the game and people liked it.

We liked the idea for the game so we are now working on it outside of LD.

However, there are things I want to do differently next time:

* Use git
* Get the main mechanics of the game working before doing anything else
* Carefully plan out so I don’t end up wasting time
* Actually playtest
* Don’t make game changing changes last minute
* Get up earlier so I have more time
* Don’t make stuff I’m not sure I can implement
* Don’t start polishing if I don’t have a working game 😂
