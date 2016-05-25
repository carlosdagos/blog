---
title: Happy Haskell and Scala development in nvim
description: I'm glad I've moved to nvim
tags: vim, nvim, development, haskell
---

Up until very recently I've been using a
[very standard Vim installation](https://github.com/charlydagos/setup-my-mac/blob/master/dotfiles/vimrc)
on my Mac to develop my shabby software in any language really. But I'm
centering most of my energies as of late in Scala and Haskell... Haskell and
Scala... whichever order you'd prefer.

Point is, if you see my [`~/.vimrc`](https://github.com/charlydagos/setup-my-mac/blob/master/dotfiles/vimrc)
file, you'll see that amongst other things I'm
using [`syntastic`](https://github.com/scrooloose/syntastic) which is actually
quite great. However it's a common complaint that for Scala it's a bit slow.

You can try this yourself, and see that when saving files you have to wait
quite a bit for that to work[^scalac]. This makes my computer and development
environment jumpy, and therefore it absolutely breaks
[my flow](https://psygrammer.com/2011/02/10/the-flow-programming-in-ecstasy/).

## Trying something new... and failing

So my first attempt was moving to Emacs. As of writing I haven't _completely_
given up on it. But I'm in the middle of learning new things and learning to
type in a new editor is just an additional layer that is stopping me from many
developments that I consider have more priority. I haven't fully stopped or
given up on Emacs just yet, so I could write about that in the future.

It's great however that Emacs has [`evil-mode`](https://www.emacswiki.org/emacs/Evil),
which is a vim emulator and goes great lengths to make you familiar with the
environment even if it's just an initial step there. Another great resource
would be [Aaron Bieber's video](https://www.youtube.com/watch?v=JWD1Fpdd4Pc).

In his video, Aaron doesn't really go into detail of how he sets everything up,
however you can do like me and rip off
[his dotfiles](https://github.com/aaronbieber/dotfiles/)[^thereforthat].

## Trying something new-_ish_... and succeeding

So Emacs was ok-_ish_ for me coming from Vim. There's a learning curve there
and I simply don't have the time to take it all in this month.

In comes [`neovim`](https://neovim.io/). I had tested it about a year ago with
some unfortunate results. The main one being that most of my plugins weren't
working out of the box. That doesn't seem to be a problem thus far, however.

### Easy installation

Installation was a breeze...

<div class="success">
brew install neovim
</div>

I suppose that if you're not using `brew` then your most readily-available
package manager will have it.
[You should always look at the wiki](https://github.com/neovim/neovim/wiki/Installing-Neovim).

### Easy migration

My `~/.nvimrc` file is below, for your copypasta pleasure.

<script src="https://gist.github.com/charlydagos/ba9b5db4c55cf999f3c0d02088ccb94e.js"></script>

It's not so different from my original `~/.vimrc` file. It has
some significant changes however, and they make quite the difference.

#### Vundle ⇒ vim-plug

Firstly, I moved away from [Vundle](https://github.com/VundleVim/Vundle.vim),
and have started using [vim-plug](https://github.com/junegunn/vim-plug). The
main difference being that the latter is async in neovim and downloading
all of my plugins takes less than 5 seconds. Compared to Vundle's 30-40
seconds, that's a great improvement.

#### Syntastic ⇒ Neomake

Secondly I've scratched `syntastic` and have started using
[`Neomake`](https://github.com/neomake/neomake), which, if you look at the
footnotes, you'll see that it implements a proposal for syntastic with async
dispatch. In other words, it not only checks your files but it also does this
in the background, keeping your flow intact.

#### Getting fancy

Additionally I installed a patched version of my favorite font with some fancy
[devicons](https://github.com/ryanoasis/vim-devicons).

Now I'm also using [deoplete](https://github.com/Shougo/deoplete.nvim), for
auto completion, and it also uses neovim's async features. For that I had
to run

<div class="success">
pip3 install neovim
</div>

Which will allow neovim to interact with python. It's important that you have
python3 installed, which is why I'm running `pip3` up there.

## Final result

Not too shabby.

<a href="../images/posts_2016-05-26-scala.png">
<img src="../images/posts_2016-05-26-scala.png" alt="Scala Dev" />
</a>

And I get autocompletion for Haskell[^scalanotyet]

<a href="../images/posts_2016-05-26-haskell.png">
<img src="../images/posts_2016-05-26-haskell.png" alt="Haskell Dev" />
</a>

In the case of Haskell, I had to hack my way through it actually to get it
to work with deoplete. It uses [`ghc-mod`](https://github.com/DanielG/ghc-mod),
which was breaking when installed globally with cabal. So I downloaded it
from github and compiled it from source in a cabal sandbox. Then I just moved
the executable file to my `~/Librar/Haskell/bin/` path. Problem solved, but
there's a voice in my head telling me I'll pay in the near future for such
insolence.

## Conclusion

The change was fast and painless. It feels like I'm in the same familiar
environment as before but the small features make all the difference. I feel
like when I moved from an IDE to vim, only with less hassle and less of a
learning curve. Kudos to the neovim team for making it happen.

## Further reading

Nothing much, really. I suppose that in this case you should just download
the software and test the plugins to your liking.

As a little side note: I don't like IDEs. I think that they're great, but I
avoid them like the plague. Whenever I pick up a new IDE it feels like I have
to, in addition to whatever framework or language I'm learning, learn how the
IDE works. IDEs can be complex, and on top of that they can, and will, make
my poor laptop very slow. I don't have infinite RAM so running an IDE _and_
Chrome on the same laptop? Not for me.

I now have `https`! I used [Let's encrypt](https://letsencrypt.org/). It was
also a breeze. I know this has very little to do with the rest of the post,
but I just feel like I need to mention it but don't feel like it deserves its
own post.

## Listening to

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A1xKZBWQrVc2cG2We4DDbbW" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

_If anybody wants to give me a gift, a vinyl of this record would be awesome_ 😅

## Amendments

Any and all amendments to this post can be found [here](https://github.com/charlydagos/blog/commits/master/posts/2016-05-26-happy-haskell-scala-development-in-nvim.markdown).

## Footnotes

[^scalac]: Syntastic calls `scalac` to check the file. The reason why this is
slow is because a standard Vim installation can't run processes in the
background. This is actually another common complaint. I've seen solutions
and/or proposals like [using it with `vim-dispatch`](https://github.com/scrooloose/syntastic/issues/699),
but that's a bit too much of a setup for me at the moment. I'm looking for the
best "out of the box" solution right now.
[^thereforthat]: That's what they're there for, right?
[^scalanotyet]: Scala's not quite there yet for autocompletion but working on
it.
