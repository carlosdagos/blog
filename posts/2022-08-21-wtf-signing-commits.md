---
title: "WTF: Weird error tying to sign commits"
description: "The internet is full of bs"
tags: git, commits, sign
---

# WTF: Weird error when setting up GnuPG to sign commits

_Short post because now I can blog again. And I haven't in a while,_
_so I am a little rusty._

## I want to sign my commits

So you have a job (nice) and they say

<div class="quote">
Hey, it's company policy that you have to sign your commits.
</div>

OK. I can do that.

So I go and I start furiously typing into my console. I accept all the defaults
(of course) and then we get to the part that says:

<script src="https://gist.github.com/carlosdagos/e5b719abb3d02739c90904653a51c2b8.js"></script>

So far, so good. This key is only for the purposes of signing my commits for
work purposes, so I don't really want to upload it to any key servers. The only
place that needs to know about this key really is my organisation's GitHub
server (at least, at this stage).

In the line above, we can see importantly the **USER-ID** says

> **`Carlos The Programmer (My Work GPG Key) <carlos@some-company.example>`**

Then I configure my `git` so that this key is used to sign my commits:

<script src="https://gist.github.com/carlosdagos/04331a1532d965aae23da0acf94b1d37.js"></script>

All looks good so far?

## But I get this error

<script src="https://gist.github.com/carlosdagos/03f7054c52acad9467eba3f1e5ac4455.js"></script>

OK. This is weird?

But a Google Search (TM) says that this is a rather common error? I may have
missed some steps, so let me go back and retrace my steps.

## The Internet recommends!

Typical stuff from Stack Overflow and other sites.

Some of them suggest that I did not configure `git` to use the `gpg.program`:

<div class="link">
<https://stackoverflow.com/questions/61849061/no-secret-key-error-when-signing-git-commit-on-windows>
</div>

_I am not on Windows but whatevever?_

Other results seem to suggest that the key expired, or that I did not set the
correct signing key (I may have confused some other value?)

<div class="link">
<https://gist.github.com/paolocarrasco/18ca8fe6e63490ae1be23e84a7039374>
</div>

Others just straight up recommend that I **export the key I just created and
reimport it?**

This sounds weird to me so I don't even attempt it.

## The internet is wrong, wtf

Ok so maybe they are not entirely wrong. I'm sure that for their intended
audience things worked fine with their suggestion. However they did not work
out for me.

### Debug git

So there is a pretty cool `GIT_TRACE` environment variable that can let me
read what `git` is trying to do:

<script src="https://gist.github.com/carlosdagos/3d34611be8321c39d8ad2d1f5cc91837.js"></script>

So there seems to be something in the `gpp2` command that simply doesn't like
something in the command:

<script src="https://gist.github.com/carlosdagos/fb992ca2e492aaecc802bd127fc54ce9.js"></script>

### A misconfigured name

As it turns out, when I created my GPG key I said that my name was

> **Carlos The Programmer**

But `git` is saying that my name is

> **Carlos D**

See the problem here?

It's weird to me because I would have thought that my email would have been
enough, however it seems that it was not.

So went to `gpg` and I told it to please recognise not only my name but also
my name without my very long last name:

<script src="https://gist.github.com/carlosdagos/193c60ea3bced59e90e8ad1892f67493.js"></script>

**Now I can sign my commits. Yay, I am compliant with my company's security
policies!** _I assume this is worth celebrating_.

## Conclusion

So it turns out that not everything on the Internet is correct. Who would
have thought?

Perhaps I need to read debug logs more 😄

## Listening to

This album is like 30 years old, and yet it's better than most of the stuff out
there today.

<iframe style="border-radius:12px" src="https://open.spotify.com/embed/album/4Io5vWtmV1rFj4yirKb4y4?utm_source=generator" width="100%" height="380" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"></iframe>

_Ok maybe not this one specifically because this one is the 20th Anniversary_
_Special Edition but you get what I mean._