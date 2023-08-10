# Post Mortem of Run N' Cook

Submitted for Ludum Dare 41.

*This was written back in 2018, right after I submitted the game to the jam.*

> * Overall: 500th (3.146 average from 26 ratings)
> * Fun: 450th (3.104 average from 26 ratings)
> * Innovation: 479th (3.104 average from 26 ratings)
> * Theme: 404th (3.479 average from 26 ratings)
> * Graphics: 353rd (3.229 average from 26 ratings)
> * Audio: 322nd (2.891 average from 25 ratings)
> * Humor: 98th (3.5 average from 26 ratings)
> * Mood: 386th (2.957 average from 25 ratings)

Run N’ Cook is a run n’ gun plus cooking game mash-up. A famous person has come to the city and you, the master chef, have been task with cooking his favourite meal. But he’s demanding, asking you to get all the ingredients by your hand (he doesn’t trust supermarkets).

You use a potato gun to defeat food monsters so you can collect all necessary ingredients to make spaghetti (but only on Mondays).

You can play the game here: [itch.io](https://codemyst.itch.io/run-n-cook).

![game screenshot](/static/images/runncook/game.png)

## Day 1

I woke up to see that the theme “Combine 2 Incompatible Genres” had been chosen. And of course, as tradition, this theme sucks! Can you combine any two themes that may seem out of the ordinary? What counts as 2 incompatible genres? Does that mean that every game will be bad (game play wise) because they’re incompatible genres? But I just started brainstorming to get an idea fast and start working on the actual game. So I Googled for a game genre generator and the first result I got was: Run N' Gun + Cooking and I started working on that.

This was my first time using Unity on Linux so it was a challenge if I could get by using software I’m not used to (Gimp, Krita, struggling with Bosca Ceoil). And Unity worked really great (*clap clap*).

So I started working on the chef and character controller. The chef is of course a stereotypical fat guy wearing a chef’s hat (I really love how he turned out). But I’m not an artist, so the animations look really funky (his legs are basically broken). And I never used Krita so learning how to animate took a really long time. Note for myself in the future: don’t use new software for game jams.

After that I started working on the potato gun. Which was really easy to do. I decided to make the potatoes projectile-like and persistent (meaning they won’t despawn). Also, they physically interact with other objects (such as enemy drops) which I really like, except that if you spam the potato gun you can push all the drops to the edge of the map).

I started working on some enemies, enemy drops and inventory / recipe system. The inventory UI is pretty confusing. You have two tabs. One for the objectives and one for the inventory. But it doesn’t really look like a tabbed UI and many people didn’t even know there was an inventory.

## Day 2

Not much progress has been made the second day. I mostly just finished off stuff I started the day before and improved. Ah yes, I also made some music! I was struggling with setting up Bosca Ceoil on Linux but I got it to work. Only after making a bit of music I encountered project breaking bugs, so I moved to Windows to make music. Note to myself in the future: don’t use untested software in a game jam.

## Conclusion

In the end, the game turned out pretty bad. This was my worst LD entry. The game is boring, has very little running, has very little cooking, but a lot of sitting around and spamming the left mouse button. But I was so stressed at the end that I just didn’t want to work on it anymore so I just rushed it and uploaded. Note for myself in the future: focus on game design and game play more!

Well that’s pretty much all I had to say. This game jam has left me feeling pretty sour, mostly because the theme sucked, yet again, but I guess that a bad theme is a part of Ludum Dare now. I’m not quite sure if I will be doing it the next time, we’ll see!

Thanks for reading and good luck on your jam entries!
