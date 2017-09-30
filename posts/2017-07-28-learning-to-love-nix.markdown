---
title: "Learning to love Nix (even though I previously badmouthed it), feat. Lisp and Python"
description: I previously shat on Nix, but now I quite like it
tags: nix, nixos, hipster, purely, functional, lisp, python
---

_Even though nobody really reads my posts, I want to dedicate this one to my now
former colleague, [Rai](http://puntoblogspot.blogspot.com.es/)._

_This blog post is written as a noob, for noobs. Nix and NixOS are really great,
it's just the docs are a bit lacking. It's getting better, and hey, I did
contribute to the docs, so I'm not all about bitching._

## Intro

If you follow my LinkedIn[^letsnotkidourselves], you'll notice that I
more-or-less recently left my Haskell gig and joined a
["local" company](https://ravenpack.com), to write Common Lisp.

This was a pretty good move, I reckon, as I'm quite happy here. We love our
code, we treat it nicely, the office is a short 50 metres away from the beach,
and folks there are not just smart, but also very professional and quite cool.

So as I sat down on my first day, I was given a CD that said "Ubun..", or
something of the matter, as I didn't bother reading the rest. I had a USB drive
and my laptop, and had to choose what OS I was going to install on my work
machine. I had narrowed it down to Arch Linux and NixOS. I chose NixOS, in a
kind of "let's try it out" mentality.

Now I have previously badmouthed NixOS on Twitter:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I&#39;m living on a 15GB budget here :/</p>&mdash; Carlos D (@carlos_dagos_) <a href="https://twitter.com/carlos_dagos_/status/837015407173242883">March 1, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Yes, that right there is me badmouthing stuff. My humor is uncomprehended, but
basically what I meant to convey was: "I don't have time or hard drive available
space for all this fanciness, and on top of it I have to learn it, so this
sucks".

Well, after using NixOS for about four months, I'm gonna blog about it because
right now I can't imagine a better work machine than the one I have now.

## Using it the wrong way

I followed a [simple tutorial](http://fluffynukeit.com/installing-nixos/),
managing to get to a blank screen with i3 installed, and not much else. I fought
my way through the i3 config and then had two simple tasks at hand:

- Install Emacs
- Install [`alisp`](https://franz.com/products/allegrocl/)

So I went:

<script src="https://gist.github.com/carlosdagos/be97ef4178e772d5fb848a5b226c64d8.js"></script>

So `alisp` isn't in [`nixpkgs`](https://github.com/NixOS/nixpkgs/), naturally,
because it's proprietary software (i.e.: you need a license). The binary I had
to use it was found under one of our private company repositories, naturally,
because the company pays for it.

I downloaded `alisp` from our company repository, and did a little thing like

<script src="https://gist.github.com/carlosdagos/0130863e351e841e37609483d2a7cb20.js"></script>

So I had a binary with me, and couldn't run it, because the interpreter (the
dynamic linker) wasn't found on the system, and this particular binary had been
compiled under the assumption (a pretty good assumption, mind you) that all
Linux-based users would have that linker in that location.

I won't bother you with why NixOS is set up like that, the philosophy of it and
why it's set up in such a way is easily found in Google by plenty of smarter
folks.

It was my first day and I wanted to leave stuff running, at the very least,
so I took the fast road, I googled the error and found myself a nice utility
used **plenty** in the NixOS ecosystem: [patchelf](https://github.com/NixOS/patchelf).

This allows me to effectively _patch_ the _ELF_:

<script src="https://gist.github.com/carlosdagos/7d24b4e4dfb4a5b07be02041a9ab6c45.js"></script>

So, [I managed to get that working](https://www.reddit.com/r/thereifixedit/).

## Using it the better way

So I started hacking and started using NixOS, happily going through some stuff,
but it's not enough to be patching things, and I quickly ran into another issue:
I was to refactor some Lisp code that calls some Python code, and when I went
to run that Python, obviously it didn't work: I didn't have the dependencies
installed.

### Determine your dependencies

So I quickly scanned the project files and saw all the imports. Something along
the lines of `find . -name '*.py' | xargs head -20 | grep import | sort | uniq`
gave me a list of roughly what I wanted, and then took to the trusty
`nix-env -qap` to ad-hoc install all those dependencies.

But then I thought, "Wait..."

##### "I am sick and tired of all this motherf'ing ad-hoc software on my motherf'ing machine"

<img src="/images/sick_and_tired.jpg" alt="Snakes on a Plane sucks but it has its moments" width="420" />

I was using the one distribution made almost specifically to _not_ clutter your
machine with random, ad-hoc, and only-once-necessary software. Maintaing my cluttered
system has always been a pain, and I wasn't using this thing the right way.

I wrote a `default.nix` file that was minimalist in nature:

<script src="https://gist.github.com/carlosdagos/4afff3ef9021d766c0aedf24a09325af.js"></script>

I fired up `nix-shell` and behold! I could run the software.

Specifically the nice thing is the `pythonPackages` part (and it doesn't stop
there, there's plenty of other "packages", like `haskellPackages`,
and `lispPackages`!).

But, then again: [software is garbage](https://twitter.com/levanderhart/status/867429436815224833),
and fragile, and things break when not enough love is put into it. And upon
running the project further, stuff broke down the pipeline.

#### Determine _all_ your dependencies

As it would turn out, the software was doing some nasty things like

<script src="https://gist.github.com/carlosdagos/a23b4df444e0e8da4ae48621c28ed674.js"></script>

Now this isn't a Python dependency, but an executable that _needs_ to be
somewhere in my `$PATH` such that the Python can "see" it and execute it.

_Faces were palmed._

### Embrace `default.nix`

Luckily for me, the change to the above `default.nix` file was pretty much
immediate:

<script src="https://gist.github.com/carlosdagos/72516b546c6ff1246339d5d7e647a659.js"></script>

It's just a matter of adding `gzip` and friends to the `buildInputs`! Now
I just fire up again `nix-shell` and all those system dependencies are available
for me.

<img src="/images/all_your_deps_nix.jpg" alt="All your deps in nix!" />

### `default.nix` all over (for your friends and colleagues)

You know the better part of doing things like this? Now some of the `README`s
at my current job look like this:

<script src="https://gist.github.com/carlosdagos/81e4cf6f297335c601b7dd7081724971.js"></script>

Now a team member who might also have the good sense to use Nix could skip
all the work I had to do and **just run the software, and make his or her
quality of life substantially better**.

### `nix-shell` all over

Again, I'm a lisper. I was using a hacked `alisp` version (which, btw, I've now
properly `default.nix`-ed). However since I did partake in some Python projects,
I did encounter some issues when running Emacs, particularly some complaints
about "Anaconda Mode" (okay, I use Spacemacs). A former colleague recommended
I run emacs under a `nix-shell`. And now I have something that looks like

<script src="https://gist.github.com/carlosdagos/2e9678b59958978349a38e0095b1ae0b.js"></script>

And, as you might imagine, my `/home/carlos/bin/` folder is full of scripts
that simply fire up different `nix-shell`s, all with different types of inputs.

At the end of the day, my "visible" system is still, pretty much:

- i3
- emacs
- urxvt + fish

The rest is `nix-shell`s.

<img src="/images/all_the_bins_nix_shell.jpg" alt="All your deps in nix!" />

## Conclusion

In short, what I want to transmit through my endless rambling is:

- Don't clutter your system, dependency hell is **real**.
- Save your friends and colleagues time by using `default.nix`. Or something
that follows the same ideas or principles, at the very least?
- Read the [`nix-shell` documentation, for further good stuff](https://nixos.org/nix/manual/#sec-nix-shell).
- Read [Oliver Charles' blog post, for futher good stuff](https://ocharles.org.uk/blog/posts/2014-02-04-how-i-develop-with-nixos.html).
- Read [Nix for Python developers](http://datakurre.pandala.org/2015/10/nix-for-python-developers.html).

## Listening to

_I have to be honest, I'm going through a [Stan Smith moment](https://en.wikipedia.org/wiki/My_Morning_Straitjacket).
I always liked My Morning Jacket, but lately it's an obsession. I have the
Okonokos vinyl, and it's amazing, to say the least._

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A1Ke9mDP94GGilHRVfUS1qn" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

## Amendments

As always, any and all changes to this post are [here](https://github.com/carlosdagos/blog/commits/master/posts/2017-07-28-learning-to-love-nix.markdown).

## Footnotes

[^letsnotkidourselves]: You don't.
