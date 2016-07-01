---
title: Random: Nowhere near the mouse lately
description: Increasing my productivity by being lazy
tags: random
---

So this is just a little off topic, but lately I've been breaking some old
habits and I'm enjoying it so much that I've decided to write about it[^myblog].

Not too long ago, I was writing in IDEs,
[I've written about that previously](/posts/2016-05-26-happy-haskell-scala-development-in-nvim.html),
but to make a long story short: they're a bit too bloated for my tastes. I find
them useful if they're exclusively the best choice for the job, like with Java,
but aside from that I prefer Vim.

One of the things I like about VIM the most is that I find that, through a
little tweaking and fancy plugins, you can start to get a pretty natural feel
for the control of the editor. Through some practising and trial-and-error,
you start to overcome the learning curve and gradually become faster and more
productive as you write more and more[^bookrecommend].

Through the use of Vim I found I was reaching for the mouse less and less
whenever I'm writing, which in turn made me lazier, but more productive. It
really does seem very insignificant, but reaching for the mouse is not about
the time that the action itself takes, but rather for me it's about breaking
some sort of continuous activity. I think about it almost as the concept of the
[flow](https://psygrammer.com/2011/02/10/the-flow-programming-in-ecstasy/),
but almost in a strictly physical aspect.

## Killing the mouse

So as I used Vim more and more, I started to be "annoyed" when I had to reach
for the mouse for other tasks. Like...

### Shell usage ⇒ Tmux

I use [a borderless version of iTerm2](https://github.com/jaredculp/iterm2-borderless-padding),
and being iTerm it has its own pane management, which works really nicely and
I used it for a couple of years. I then started to use tmux because I found
it easier to configure, and it adapted itself quite easily to vim shortcuts.

I did have a slight learning curve for it, but thanks to the program lending
itself to [plugins](https://github.com/charlydagos/setup-my-mac/blob/master/dotfiles/tmux/tmux.conf#L40-L51),
I had a bit of an easier time adjusting.

At this point I was using `vi-style` keystrokes to move the cursor around
not only in my editor but also throughout my panes and general shell usability.

Still not enough, though, because I don't spend all my time in a shell[^hope].

### Browser ⇒ Vimium

One day, by chance, I heard about [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en),
which allows you to use your browser as though you were using Vim. And in fact
the relation I've established with it is that it's like using Vim with the
[easymotion plugin](https://github.com/easymotion/vim-easymotion).

Vimium makes for a totally different browsing experience, and now I was hardly
reaching for the mouse. But still there were some other apps I often use which
either don't lend themselves to easy keyboard-only navigation, or I simply
just never got accustomed to how the implement them; like Sype, for example.

#### Gmail shortcuts

As a little side note, Vimium by default doesn't work in Gmail. However
Gmail by itself implements some shortcuts and it works very natural with how
you'd move around in Vim. [You need to enable those first.](https://support.google.com/inbox/answer/6080523?hl=en)

### OS X ⇒ Shortcat

So I was nearly there, except I was using the mouse for all tasks that weren't
related to the shell or my browser. Which got me thinking that maybe there was
a chance to use the OS in general in the same way. Through some good ol'
googling I found [Shortcat](https://shortcatapp.com/).

This, again, works almost in the same way as finding an element in the
currently-focused window and going to it, though it does this through an
emulation of the mouse movement and clicking.

The keystrokes themselves in this case are not `vi-style` however it's still
quite natural.

The app itself is still in Beta, so sometimes it can crash. All in due time,
however, and I think the app has great potential.

The results are already obvious, enough to motivate me to write about it all.

### Mandatory screenshots

## Conclusion

Upon further reflection, though I'm having a lot of fun, I can't help but
think that there's been so much work on getting mouse-aware applications and
X window systems, and now there's so many programs working on top of that to
"get rid" of the mouse. Ha! Still fun, though.

Anyway, since last post I also wrote about my work/play machine, I believe
I've had enough of writing about it. So next posts should be back to
programming! With ZuriHac coming up, maybe there'll be some notes on that
with some pictures.

## Further reading

I don't just use these apps for productivity, there's plenty more that can
be used, like Alfred, which is quite popular.

In other \*nix systems there's plenty of other cool, free, tools to be used,
so if you're not on OS X then look around and
[send me a tweet](https://twitter.com/charlydagos) or something!

## Listening to

This is a rather good surprise album:

<iframe src="https://embed.spotify.com/?uri=spotify%3Aartist%3A5PbpKlxQE0Ktl5lcNABoFf" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

And actually, I've also heard these guys quite a lot and have been enjoying
it thoroughly, so double-album post:

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A1Rjv02PZba3x9CtKR6DdKA" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

_Waiting anxiously for that [The Head and The Heart Album](http://www.npr.org/event/music/483901072/watch-the-head-and-the-heart-perform-live-in-the-studio),
after some disappointments this year, I'm really hoping that they will deliver
some quality music, as they have done so effecitively and wonderfully thus far._

## Footnotes

[^myblog]: Because, you know, it's *my* blog :D
[^bookrecommend]: On that note, I'd really recommend you pick up the book
[Vim - precision editing at the speed of thought](https://vimeo.com/53144573),
this is the type of book you don't read from start to finish but rather just
look up stuff whenever you need it, or when you think something could be faster,
and lo-and-behold: it's there. Not always, but still it's a great resource.
[^hope]: Though, sometimes, I wish I did.
