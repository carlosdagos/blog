---
title: Folding characters vs iconv
description: iconv is not the solution to all your problems
tags: unicode, iconv
---

Had a bit of a problem recently and it fit perfectly with my previous post about character encodings. Whereas in my previous post I talked a lot about php, in this one I use JavaScript/NodeJS and Bash/ZSH, though not so intensely.

## The problem

The application we're working on pulls mission-critical information from an API. This information is then stored in the a database and used for Customer Support, shipping, after-sale services, so on and so forth. Basically, it's really important information.

Now, as it usually happens, some of the systems that make the entire operation are a bit.. _outdated_. Nothing wrong with that[^hipsters]. But when doing our integration tests, we noticed that what in the API looked like[^fakedata]...

<div class="success">
Gyönyörű Bögre
</div>

On the database was then showing up as...

<div class="error">
Gy&#xFFFD;ny&#xFFFD;r? B&#xFFFD;gre
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

So our source data is coming in `UTF-8`. Upon checking the [database charset](http://www.postgresql.org/docs/9.2/static/multibyte.html), it showed up as [`ISO 8859-1`](https://en.wikipedia.org/wiki/ISO/IEC_8859-1), also known (perhaps incorrectly) as `Latin 1`. It's a character set from the late 80's intended to group most of the European characters, and since [I live](/contact.html) right in the middle of Europe, this makes sense.

However, it's unfortunate, because I'm storing bytes in the database that are meant to be read as `UTF-8`, and the database (and the database clients) will spit them back at me thinking it's `ISO-8859-1`. Hence, unrecognizable characters: &#xFFFD;. 

If you still don't know what's going on, let's look at the `hexdump` of that particular string.

[<img src="/images/posts_2016-02-20-hexdump_1.png" alt="hedxump" />](/images/posts_2015-02-20-hexdump_1.png)

The first column of the `hexdump` output is the byte offset. We're interested in the other values for now.

If you look closely, hexdump is even nice enough to tell us which glyphs are multibyte[^utfeightvariable], denoted by `..` (this means two bytes, try more glyphs on your own :D). You can read then the matching glyphs to their `UTF-8` representation. So `G = 0x47`, `y = 0x79`, [`ö = 0xC3 0xB6`](http://www.utf8-chartable.de/unicode-utf8-table.pl?start=128&number=128&names=-&utf8=0x&unicodeinhtml=hex), .., [`ű = 0xC5 0xB1`](http://www.utf8-chartable.de/unicode-utf8-table.pl?start=256&names=-&utf8=0x), .., and yeah, you get it.

Now these bytes are stored in the database, but the database thinks these are `ISO-8859-1` values. Now the thing is that this encoding is **single-byte** encoding, we're not going to be reading by boundaries like we did in `UTF-8`, but byte by byte. So it reads... `0x47 = G`, `0x79 = y`, `0xC3 = ?`, ..., and it breaks.

### The "solution"

So we presented the problem and one of the devs said: "I can fix it!", and went ahead to add the lines...

<script src="https://gist.github.com/charlydagos/c26c434033d58101366b.js"></script>

Fair enough, right?

### Not so fast

When we got the output, it showed up as something like

<div class="error">
Gyönyör? Bögre
</div>

**What the hell is that `?` _still_ doing there?**

At this point we're all getting a little agitated.

## The real solution

So what gives? [`iconv`](http://linux.die.net/man/1/iconv) _should_ have worked.

Right?

Well, no.

Just to quote the `iconv` manual page...

<div class="quote">
Convert encoding of given files from one encoding to another
</div>

So basically, if the letter `ö` in `UTF-8` looks like `ö = 0xC3 0xB6`, in `ISO-8859-1` it looks like `ö = 0xF6`. It makes sense, in `UTF-8` it's a multi-byte glyph, and in `ISO-8859-1` it's a single byte, just like it was intended. And satisfyingly enough, `iconv` did just that for us. But what about that weird-looking `ű`?

Well the table below is a nice illustration..

<table style="text-align:left;"><!-- I crack myself up XD -->
<thead>
<tr><th>Encoding</th><th>Byte representation</th></tr>
</thead>
<tbody>
<tr><td>utf8(ű)</td><td>0xC5 0xB1</td></tr>
<tr><td>iso8859(ű)</td><td>?</td></tr>
</tbody>
</table>

[The letter `ű`](https://en.wikipedia.org/wiki/Double_acute_accent) doesn't exist in `ISO-8859-1`[^poorhungary], so `iconv` can't map it to anything.

This is what a lot of people get wrong about `iconv`, it's not a magic solution to your character problems. And really, if we had used a more robust `iconv` library like [`node-iconv`](https://github.com/bnoordhuis/node-iconv), then we would've received a proper error message. Nothing wrong with `iconv-lite`, in fact they claim it's faster, and the [source code](https://github.com/ashtuchkin/iconv-lite) is quite easy to follow and make sense of it. However it suppresses this message.

### Folding characters

So the solution that we opted for is a bit less known, albeit useful. 

It's called "folding" although I guess you could call it "mapping", or whatever you want. It relies on mapping a character[^charactersnotgliphs] to whatever is "closest" either in shape or meaning. So we went ahead and implemented a fold for it. I called it `foldToISO()` because I'm simply not creative enough.

When you `foldToISO`, you're ensuring (at least in most cases), that you're going to be mapping to a character that **does** exist in the "receiving" end encoding, in this case `ISO-8859-1`.

This way, we say "map `ű` to `u`", because we know that `u` _is_ in `ISO-8859-1`, and then therefore `iconv` can handle it accordingly. It won't have to think much about it, though, because in both cases it's `u = 0x75`[^anothermapping].

<script src="https://gist.github.com/charlydagos/87439f1f120dd2df8df4.js"></script>

Now, when we executed that and looked at the database, we saw..

<div class="success">
Gyönyöru Bögre
</div>

And since there were no broken characters and the client understood the limitation, everyone was happy :)

#### Practical example

So let's try to think about when folding characters might come in useful 🤔.

I really like [Ólafur Arnalds](https://soundcloud.com/modhat/o-lafur-arnalds-full), and one of my favorite songs from him is ["Þú ert jörðin"](https://open.spotify.com/track/4zo9nVH8uBk5DnUa92ogWn). I listen to a lot of Spotify, and use the search bar a lot. Due to my travelling and living in so many places, I use a Spanish ISO keyboard layout, and I don't have all the characters available to search for my song... "Þú ert jörðin". If I were to search for it, I would type what I can make out of that.. something like "ert jordin", for example[^tryityourself], and this works!

Well, I have no idea how Spotify does search, but let's assume that they use [Elasticsearch](https://www.elastic.co/products/elasticsearch). Now you don't have to know much about it, but it's built on top of [Apache Lucene](https://lucene.apache.org/core/), which is a text search engine.

Now [Lucene stores text in `UTF-8`](https://github.com/apache/lucene-solr/blob/master/lucene/core/src/java/org/apache/lucene/util/BytesRef.java), meaning that it supports all the characters of that song that I desperately wanna listen to. No problem for them there. I only typed "ert jordin", however, so how can they successfully return my song?

Well, I'm no big-city developer, but if it were me, I would fold the shit out of that string into ASCII values, and make a lookup on a reverse index.

And if we try to fold "Þú ert jörðin" to ASCII, we get "THu ert jordin"... how grand!

Yeah... 

<iframe src="https://embed.spotify.com/?uri=spotify%3Atrack%3A4zo9nVH8uBk5DnUa92ogWn" width="300" height="380" frameborder="0" allowtransparency="true"></iframe>

It just so happens that Lucene comes with an [AsciiFoldingFilter](https://github.com/apache/lucene-solr/blob/master/lucene/analysis/common/src/java/org/apache/lucene/analysis/miscellaneous/ASCIIFoldingFilter.java) right out of the box.

So there you go..., problem mildly-solved.. I mean, you still have to think about how to store all that, and how to build it, etc etc etc :)

#### Achtung!

Folding characters does **not** mean that you convert the byte representation from one charset to another, you change the actual glyph within the same charset. This is why in the last gist up there we're still doing `iconv.encode`. Except that now we can safely do this conversion.

#### The result

Well, feast your eyes on this... internally, the results looked like

<img src="/images/posts_2016-02-20-hexdump_2.png" alt="hexdump 2" />

It's also evident that we're now saving a few bytes. If you care about that. I think that if a client has TBs of information, then yes, they probably do :)

### [iconv](http://linux.die.net/man/1/iconv) and the `//TANSLIT` and `//IGNORE` flags

So if you've ever used `iconv` to some extent, you're probably thinking "Yo! What about the `//TRANSLIT` flag? Doesn't that do the folding for you already?".

And you're right, it ["transliterates"](https://en.wikipedia.org/wiki/Transliteration) your text. However, it's not very well documented, not widely supported by most of the `iconv` clients. In my experience, using `//TRANSLIT` has yielded more problems than it has solved.

So what about `//IGNORE`? Well, you're ignoring the problem altogether, so it's simply bad practice :)

## Lessons

- `iconv` is awesome. But it's badly documented. And misunderstood, poor `iconv` :(
- `iconv` is not a magic wand.
- "Folding" has its advantages.
- The world is not Unicode.

## Considerations

- I don't know if I'll be writing more on character sets, because I think that two blog posts about this has exhausted the subject a little bit.
- The `LC_ALL` environment variable can give you issues when running some shell programs. A quick-and-dirty solution is to prefix the variable definition before the execution of a certain program. Like so... `$ LC_ALL=C myprogram --flag=whatever`.
- Have you [learned your encoding?](/images/didyoudoit.jpg)
- Soon enough I'll be posting the code that does the folding :)

## Resources and more reading

- [`UTF-8` chartable](http://www.utf8-chartable.de/)
- [`UTF-8` implementation and resources](http://unicode.org/resources/utf8.html)

## Listening to...

Actually on vinyl, but here's the Spotify link :)

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A2fGCAYUMssLKiUAoNdxGLx" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

_Thanks for the gift :)_

### Amendments

Any and all amendments to this post can be found [here](https://github.com/charlydagos/blog/commits/master/posts/2016-02-20-folding-vs-iconv.markdown).

### Footnotes

[^hipsters]: In fact, it's a bit annoying how "working in a totally new and up-to-date environment" can even be considered a benefit (I'm looking at you, Stack Overflow Careers...). Before moving to Basel, I worked for a company with a brilliant colleague who introduced me to the theme of the [Programming hipsters](http://www.urbandictionary.com/define.php?term=programming+hipster). Mostly because I behaved like one as well. I've come to find out that in real life you're gonna find old-as-shit systems and you're gonna have to deal with it. It's not all Unicode, not every language will treat your functions as first class citizens, you won't always have a readily-available MongoDB cluster to put into production. In my last job, our customers were using feature phones. You know what a feature phone is? It's what came before smart phones. They're dumb phones. You couldn't reliably determine who had JavaScript available and who didn't. Even if you could, it would be version 1.7, or 1.5, and you'd have to plan for all of that.
[^fakedata]: I'm obviously not going to use real data. This is fake data. In Hungarian it means "Beautiful cup". I like cups. I have a few that are really nice.
[^omg]: omg I'm actually referring to myself already. [I feel like a total author right now, guys](https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif)!
[^fakedataagain]: Again, I'm using fake data for this post. I'll probably be using fake data on all posts.
[^utfeightvariable]: But you know that `UTF-8` is a variable-length encoding already, because you read that [first post](/posts/2015-02-15-on-reversing-strings.html). [Right?](/images/didyoudoit.jpg)
[^poorhungary]: [https://en.wikipedia.org/wiki/ISO/IEC_8859-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1), look at the "Missing characters" section for Hungarian.
[^tryityourself]: Try it for yourself, try different combinations, etc :D
[^charactersnotgliphs]: In most "fold" implementations, you'll find people folding per `char`, instead of per `grapheme-cluster`. In most JavaScript implementations, you'll find that a `char` is 16-bit. Now this leaves the door open for `UTF-16` and `UCS-2`. If you're interested in that [Matthias Bynens wrote a great post about it](https://mathiasbynens.be/notes/javascript-encoding), and I would also advise you to [follow him](https://twitter.com/mathias). He's pretty smart!
[^anothermapping]: According to Wikipedia you can also use the letters [`Û`](https://en.wikipedia.org/wiki/%C3%9B) or [`Ü`](https://en.wikipedia.org/wiki/%C3%9C). In these cases, we can see that in `UTF-8` these look like `Û = 0xC3 0x9B` and `Ü = 0xC3 0x9C`, whereas in `ISO-8859-1` they look like `Û = 0xDB` and `Ü = 0xDC`.
