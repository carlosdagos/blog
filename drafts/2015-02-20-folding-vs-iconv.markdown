---
title: Folding characters vs iconv
description: iconv is not the solution to all your problems
tags: unicode, iconv
---

Had a bit of a problem recently and it fit perfectly with my previous post about character encodings. Whereas in my previous post I talked a lot about php, in this one I use JavaScript/NodeJS, though not so intensely.

## The problem

The application we're working on pulls mission-critical information from an API. This information is then stored in the a database and used for Customer Support, shipping, after-sale services, so on and so forth. Basically, it's really important information.

Now, as it usually happens, some of the systems that make the entire operation are a bit.. _outdated_. Nothing wrong with that[^hipsters]. But when doing our integration tests, we noticed that what in the API looked like[^fakedata]...

<div class="success">
Gyönyörű Bögre
</div>

On the database was then showing up as...

<div class="error">
Gy&#xFFFD;ny&#xFFFD;r"u B&#xFFFD;gre
</div>

### So what's going on here?

If you first read [my first blog post](/posts/2015-02-15-on-reversing-strings.html)[^omg], you'll have some intuition of what's happening. But since you're lazy, and so am I, then let's break it down.

- The original data comes from an API source. The text looks OK.
- That data is retrieved and then stored in a database for the client. The text is garbled or otherwise unreadable.
- The client is not happy.

As I normally do, I went to look at the guts of the monster. What I found was mostly what I was expecting.

First I checked the [Content Type](https://www.w3.org/Protocols/rfc1341/4_Content-Type.html) of the API[^fakedataagain].

<script src="https://gist.github.com/charlydagos/0e680d66c3e82fbccf39.js"></script>

The line `Content-Type: application/json; charset=utf-8` is pretty explicit telling us that our contents are in `UTF-8`.

I suspected that already but it never hurts to check.

So our source data is coming in `UTF- 8`. Upon checking the [database charset](http://www.postgresql.org/docs/9.2/static/multibyte.html), it showed up as [`ISO 8859-1`](https://en.wikipedia.org/wiki/ISO/IEC_8859-1), also known (perhaps incorrectly) as `Latin 1`. It's a character set from the late 80's intended to group most of the European characters, and since [I live](/contact.html) right in the middle of Europe, this makes sense.

However, it's unfortunate, because I'm storing bytes in the database that are meant to be read as `UTF-8`, and the database (and the database clients) will spit them back at me thinking it's `ISO-8859-1`. Hence, unrecognizable characters: &#xFFFD;. 

If you still don't know what's going on, let's look at the `hexdump` of that particular string.

[<img src="/images/posts_2015-02-20-hexdump_1.png" alt="hedxump" />](/images/posts_2015-02-20-hexdump_1.png)

The first column of the `hexdump` output is the byte offset. We're interested in the other values for now.

If you look closely, hexdump is even nice enough to tell us which glyphs are multibyte[^utf8variable], denoted by `..`. You can read then the matching glyphs to their `UTF-8` representation. So `G = 0x47`, `y = 0x79`, [`ö = 0xC3 0xB6`](http://www.utf8-chartable.de/unicode-utf8-table.pl?start=128&number=128&names=-&utf8=0x&unicodeinhtml=hex), .., [`ű = 0xC5 0xB1`](http://www.utf8-chartable.de/unicode-utf8-table.pl?start=256&names=-&utf8=0x), .., and yeah, you get it.

### The "solution"

### Not so fast

## The real solution

### Folding characters

### [iconv](http://linux.die.net/man/1/iconv)

#### The `//TANSLIT` and `//IGNORE` flags

## Lessons

## Considerations

I don't know if I'll be writing more on character sets, because I think that two blog posts about this has exhausted the subject a little bit.

## Resources and more reading

- [`UTF-8` chartable](http://www.utf8-chartable.de/)

## Listening to...

Actually on vinyl, but here's the Spotify link :)

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A2fGCAYUMssLKiUAoNdxGLx" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

_Thanks for the gift &#x2665;&#xFE0F;_

### Amendments

### Footnotes

[^hipsters]: In fact, it's a bit annoying how "working in a totally new and up-to-date environment" can even be considered a benefit (I'm looking at you, Stack Overflow Careers...). Before moving to Basel, I worked for a company with a brilliant colleague who introduced me to the theme of the [Programming hipsters](http://www.urbandictionary.com/define.php?term=programming+hipster). Mostly because I behaved like one as well. I've come to find out that in real life you're gonna find old-as-shit systems and you're gonna have to deal with it. It's not all Unicode, not every language will treat your functions as first class citizens, you won't always have a readily-available MongoDB cluster to put into production. In my last job, our customers were using feature phones. You know what a feature phone is? It's what came before smart phones. They're dumb phones. You couldn't reliably determine who had Javascript available and who didn't. Even if you could, it would be version 1.7, or 1.5, and you'd have to plan for all of that.
[^fakedata]: I'm obviously not going to use real data. This is fake data. In Hungarian it means "Beautiful cup". I like cups. I have a few that are really nice.
[^omg]: omg I'm actually referring to myself already. [I feel like a total author right now, guys](https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif)!
[^fakedataagain]: Again, I'm using fake data for this post. I'll probably be using fake data on all posts.
[^utf8variable]: But you know that `UTF-8` is a variable-length encoding already, because you read that [first post](/posts/2015-02-15-on-reversing-strings.html). [Right?](/images/didyoudoit.jpg)
