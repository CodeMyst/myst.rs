---
title: Adventures In Highlighting Code In The Browser
summary: A comparison of different ways to do syntax highlighting in the web browser
date: 2021-11-05
link: highlighting-adventures
---

## Preface

Highlighting code is easy, but as soon as you need to be able to edit the code, and support a lot of languages (like I don't know... how about 300+ languages?), and also have **good** highlighting, it gets really hard and confusing.

This post is about my findings on the topic of highlighting code in the browser, my ideas, my attempts and the final solution I decided to go with. There's most likely a lot of flaws in my approaches, you can leave a comment here if you have thoughts on anything.

## Motive

Let's start with the motive behind this, why am I looking into a ton of different ways to do code highlighting?

Maybe you know this already, maybe you don't, but I'm a creator of [pastemyst](https://paste.myst.rs/), a website for sharing code. In the current version (v2) I'm using the [CodeMirror](https://codemirror.net) editor, and it's pretty great, it's fast, easy to use and supports a bunch of languages. I'm using it both for editing the code and showing the paste to the users.

If CodeMirror is so great, why am I looking at other ways then? Because of basically just one reason, but it's a big reason. CodeMirror uses pretty simple rules for highlighting, so that's why it's fast, but the results aren't the best.

![difference between pastemyst and vscode highlighting](/static/images/blog/highlighting/csharp-pastemyst-vscode.png)

Here you can see the difference between pastemyst (CodeMirror) on the left and VSCode on the right. There's only slight difference, but I couldn't be bothered finding a better example.

Having good syntax highlighting on a website based around showing code is pretty important. So I tried finding other ways for syntax highlighting.

## TextMate grammars

I first found about [TextMate language grammars](https://macromates.com/manual/en/language_grammars), used by editors like VSCode, Atom, and GitHub as well. The TextMate grammar files are really long, and hard to write, but they tokenize the code much better, and there's grammar files for a ton of languages already made.

> NOTE: Atom and parts of GitHub have switched to using [tree-sitter](https://tree-sitter.github.io/tree-sitter/), it works in a different way, and the grammar files are written in JavaScript / CSON. Supposedly you get better highlighting with it, and it's not as monstrous as TextMate grammars.

Of course I tried looking for libraries that highlight code based on these grammar files, and found [shiki](https://shiki.matsu.io). It's an awesome library! It allows you to run the highlighter on a server (node) or in the browser (although you have to do a workaround for loading some wasm file).

But shiki is just a syntax highlighter, and not an editor. And here is where a lot of my problems actually begin. If you just want to show code, and don't need editing and/or realtime highlighting, just use shiki, but if you do need an editor, then you're going to have to sacrifice some stuff.

## First approach - Separate editor

There are a few ways I thought of on how to deal with this.

The first is the most simple one, continue using CodeMirror for editing the page, and when the users view the paste render it using shiki. This is the easiest to implement, but you will end up having different highlighting in two different places. And yes, you can mitigate this somewhat by using the exact same theme in both places. But there is a bigger issue, CodeMirror just doesn't support as many languages as I can support with TextMate grammars, the GitHub linguist repository, which has a list of all grammars they use, lists like 370+ languages and CodeMirror lists around 140 languages "built in". So on a lot of languages you won't even have any syntax highlighting in the editor, but will get rendered just fine once you make a paste.

And I know you could probably find language definitions for CodeMirror that are missing, but you won't find a lot of them, and they probably aren't getting updated anyway. I have a partial solution to this, when you are editing in CodeMirror, add a preview button which when pressed will render using shiki and show the actual result.

Here's a quick video of this in action, and I know the themes don't match up, it was a quick demo.

![highlighting preview](/static/images/blog/highlighting/pastemyst-editor-preview.gif)

## Second approach - Custom editor

The second approach requires a lot more effort. The idea is to use another editor library, one that supports using your own custom highlighter, or make my own editor that does this.

I don't really want to write my own editor, that kind of stuff is just pain. So I found out about [CodeJar](https://medv.io/codejar/), it's a small editor that requires you to use your own syntax highlighter.

I wrote a quick demo where I used CodeJar for editing code, there's actually two editors. One editor highlights code by running shiki in the browser, and the other editor connects to a node server through a websocket, and the server does the rendering.

Let's look at this image now:

![codejar editor with one line of code](/static/images/blog/highlighting/codejar-oneliner.png)

The last update time shows the time in milliseconds that it took CodeJar to update, basically says how long it took to highlight code. And just from this we can see that running shiki in the browser is much faster for some reason.

This is the code that's running in a node server for this test:

<iframe src='https://paste.myst.rs/6l043c2o/embed' scrolling='no' style='border:none;'></iframe><script src='https://paste.myst.rs/static/scripts/libs/iframeResizer.js'></script><script>iFrameResize();</script>

And how about a... I don't know... 10k lines of code?

![codejar editor 10k loc](/static/images/blog/highlighting/codejar-10k.png)

Yup, that's like 3.5 seconds on the browser test, and when I pasted that in both editors, it took a lot more than 3-4 seconds for it to highlight, it's **very slow**. And for comparison pasting that into CodeMirror is instant, so yeah... This approach really doesn't pan out.

Another issue with this approach is loading language files and themes, you don't really wanna load 370+ json files when you open the website. But I guess a simple solution would be to just load the language once selected, and set a long TTL for caching.

## Final words

In the end I have decided to go with the first approach, using CodeMirror for editing, and for now use shiki on a server to render code when a paste is viewed. I will also look into trying out tree-sitter and switch between these two depending on the language.

This way I can also cache every grammar file and theme on startup, and maybe even figure out a way to render the paste just once and store the result somewhere (the tricky part is supporting themes).

Now there are other syntax highlighters, like [vscode-textmate](https://github.com/microsoft/vscode-textmate), which is what VSCode uses, but I haven't tested the performance of that.

There is also another editor which runs in the browser, which actually powers VSCode, [monaco](https://microsoft.github.io/monaco-editor/), but it's really heavy and doesn't support mobile. And I don't think you can easily get more languages supported, but I'm not that sure on that.

And if VSCode can use TextMate grammars for editing, and VSCode is essentially a website bundled into an electron app, there's probably some way to do fast highlighting for editors. But it requires you to write your own editor, using a lot of tricks probably, and that project alone could take a lot of time, and I simply don't want to pour a ton of time into something like this, so I'm sticking with the not so elegant approach, but in the end it's not so bad anyway.

If you have made it this far, thank you for reading! You are of course welcome to leave any thoughts you have here, you can also contact me through mail on my [home page](https://myst.rs/). Until next time.
