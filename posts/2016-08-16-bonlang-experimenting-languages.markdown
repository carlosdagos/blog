---
title: Experimenting with my own programming language: Bonlang
description: An experiment turned into a learning experience
tags: zurihac, languages
---

_tl;dr: This post talks about various languages, though mostly Haskell.
I started playing with [Parsec](https://hackage.haskell.org/package/parsec)
and [Stack](https://docs.haskellstack.org/en/stable/README/), that led to
writing my own language. Some lessons learned._

## Intro

As a Haskell rookie I read and followed the free online book
[Write Yourself a Scheme in 48 Hours](https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours),
which helped me understand a lot of features of Haskell. However when you have
a book to follow I find that it's hard to ask yourself some questions, and far
too easy to just follow along[^atleastforme].

After having finished reading and following _Write Yourself a Scheme_, along
with thinking that all this time I've been complacently using Cabal for my
builds, I thought a cool project would be to make my own language. This would
allow me to attempt Parsec on my own and also start getting used to the Stack
build tool, which is the preferred way of working in professional
Haskell environments[^simontalk].

## Bonlang

For the aforementioned purpose I decided to implement my own programming
language, which would feature some of my favorite aspects found in other
languages.

### Choosing a name

It's just a name, to be honest. Though the actual story is that when I was
thinking about a name, I was also about to have dinner and my roommate said
"bonap!", which is short for _bonappetit_. So... ¯\\\_(ツ)\_/¯

### Choosing a style

In regards to the style, I decided to go with a mix of my favorite languages:
Lisp(s), Scala, and of course Haskell.

#### Variadic functions... or lack thereof

In regards to Lisp, I first wanted to have variadic functions, that is,
functions that have indefinite arity (number of arguments). For example,
in Clojure (a Lisp for the JVM), and in most Lisp flavors you can do:

<script src="https://gist.github.com/charlydagos/fc805032f833009166a62eb310ca5d38.js"></script>

However I had to desist on that idea because it's hard to have that play along
with another feature I really like, which comes from Haskell, and it's called
_automatic currying_.

#### Automatic Currying? Is it delicious?[^pun]

[Currying](https://en.wikipedia.org/wiki/Currying) _is_ delicious, but does not
come from curry the spices, rather it comes from
[Haskell Curry](https://en.wikipedia.org/wiki/Haskell_Curry), a great
mathematician and logician. Though in those links you can find yourself great
information and follow from there to your heart's content, currying is quite
simple in usage, and in my opinion tremendously powerful.

A simple demo of currying is below:

<script src="https://gist.github.com/charlydagos/29b3281fe0949841aff9b64893c4af48.js"></script>

Seeing this behavior it's perhaps easier to understand currying with its
alternate name: _partial function application_. As you can see,
`addtwoIntsAnd10` is nothing more than `addThreeInts` with the first
parameter applied and the other two are "pending", in a matter of speaking.

Some languages provide a way to curry, but in my experience it's rarely as
straightforward as it is with Haskell, which is why I call it _automatic_.
Bonlang behaves like Haskell in this regard (superficially, not internally).

You can however see how it's hard to combine variadic functions with automatic
currying; in other words: _how do you manage automatic partial function
application when you have an indefinite amount of arguments?_ That's not to say
there's no solutions, but I decided to not implement variadic functions[^stillworking].

In Haskell, in fact, _all functions take a single parameter_, and simply keep
returning functions until an actual value is ready to be returned. That is, a
value that doesn't require any further arguments, which leads me to the next
feature desired in languages I normally use.

#### Functions as first-class citizens

Another feature that I love to program with is using functions as first-class
citizens. This makes for really elegant and a lot of times simpler-to-understand
code.

Programming with functions as first-class citizens means that I can mention an
identifier in my code referring to a function, and that carries no special
syntax. For example, PHP _does not_ treat functions as first class citizens
because you have to point to them with a string or use a closure.

<script src="https://gist.github.com/charlydagos/618b4bdc717b891cc546e666d0c08ca3.js"></script>

Treating functions as first-class citizens can even vary across different Lisp
flavors, for example here's a mapping over an array in Clojure:

<script src="https://gist.github.com/charlydagos/ffebbac899dad8c3a367203ceb0ee008.js"></script>

And in Common Lisp:

<script src="https://gist.github.com/charlydagos/a07fcc34a91245e181c9c0ea1e6f8612.js"></script>

So you can see that they're different. My favorite approach however is to simply
treat functions like any other identifier. After all, they're the same as
numbers, strings, ..., in other words: they're no different from any other
"citizen".

#### On that note: lambdas

So from the previous point we gather that we want to refer to functions by
their identifiers. But giving a name to every function is sometimes annoying
when we need functions in specific scopes and are ready to throw them away
once we're done with a specific procedure.

That's the purpose of lambdas, unnamed functions that can be assigned to a local
identifier, or simply used as a parameter of other higher order functions
(i.e.: functions that take other functions as arguments); like
[_map_](https://clojuredocs.org/clojure.core/map).

In Bonlang, of course, I decided to add support for lambdas. In fact, there's
no such thing as a function, but internally it binds closures to identifiers
in a somewhat-generalised scope (more on that on later posts).

As a demo of a lambda, here's one of my favorite code snippets. It calculates
the factorial for any number `n` in linear time. It's in Clojure and ripped
directly from [_Structure And Interpretation of Computer Programs_](https://mitpress.mit.edu/sicp/full-text/book/book-Z-H-11.html#%25_sec_1.2.1).

<script src="https://gist.github.com/charlydagos/8d9ca7f32aa1a1ff10594eefacbb5dea.js"></script>

But of course, if you ask me, the **best** language for lambdas is, to date,
Haskell:

<script src="https://gist.github.com/charlydagos/7ba1e4384527880af498e0fd0567e7e9.js"></script>

If you can't see it, it's as easy as `\param1 param2 -> ...` where `...` is an
equation where you manipulate the function arguments to your liking.

Achieving that level of elegance is quite hard from a parser point of view, so
in Bonlang it's not so nice, I'm afraid.

#### Last but not least: Pattern Matching

Another tremendously powerful feature found in languages like Scala and Haskell,
but not many Lisps, is Pattern Matching. Below is a quick (trivial) example of
how that works:

<script src="https://gist.github.com/charlydagos/b1353b6d7198c08c361814c514b04f4f.js"></script>

Where the `_` (underscore) symbol means "whatever" (otherwise known as a
_wildcard pattern_). So the method `isCarlos` will only return true for a value
that matches the "pattern" specified in the first binding.

There is one Lisp flavor that has pattern matching, though it's not as complex
as Haskell's. It's [Shen](http://www.shenlanguage.org/)[^shen], and below is an
example of how you'd reverse a list in Haskell and in Shen[^notoptimal], using
pattern matching:

_In Haskell:_

<script src="https://gist.github.com/charlydagos/8f3d0c6da834ecb9827c09fe5c1d7bb9.js"></script>

_In Shen:_

<script src="https://gist.github.com/charlydagos/65705dcf094cafb82dc2b1def7ad28f4.js"></script>

While I'm still adding pattern matching and it's not in any of the examples
below, I think that I'll attempt first to pattern match closer to Shen than to
Haskell, especially since in Bonlang I still don't have custom data types.

More on Shen pattern matching [here](http://www.shenlanguage.org/learn-shen/functions/functions_pattern_matching.html).

### Some code examples

While that's not the complete list of elements found in Bonlang, I believe
I'm close to boring the hell out of you so it's better to jump into some code
samples.

Automatic currying, as mentioned, is quite straightforward:

<script src="https://gist.github.com/charlydagos/c64b3e238c6ba48a539e89b483ae7338.js"></script>

Support for lambdas:

<script src="https://gist.github.com/charlydagos/8b5d883180dadf04edd5f3b837c02b4c.js"></script>

There's a higher-order function: `map`. I'll add more with time.

<script src="https://gist.github.com/charlydagos/5b1610f025c6c9cf70df42dba8273a97.js"></script>

Combining currying with higher order functions, `addFive` is a partial
application of adding (`+`), with the number 5.

<script src="https://gist.github.com/charlydagos/e674d68f2713dcf572ced1f2312cc8d6.js"></script>

Here's that SICP factorial calculation, it performs actually quite well.

<script src="https://gist.github.com/charlydagos/90b87549d2665c6a11ec8c85a5359e83.js"></script>

And here's a sample of a classic recursive Fibonacci, which has a terrible
performance, but that's kind of the point of this algorithm:

<script src="https://gist.github.com/charlydagos/73df8722f0e1e7cf652331c947205653.js"></script>

If you're familiar with the languages which I have been mentioning, you'll see
how where a lot of the inspiration comes from.

Lastly, this is an example that I really like, and if you're a SICP person
you'll recognize it. You can check the reference material
[here](https://mitpress.mit.edu/sicp/full-text/sicp/book/node30.html).

The purpose of the example is to show that data can take the form of procedures.
Effectively, with support for lambdas we can create _pairs_.

<script src="https://gist.github.com/charlydagos/88800cbe7f8ba8b546a4c7cdb763cc34.js"></script>

This is one of my favorite examples and it is, as the book says, mind-boggling.

Mainly, I think, is the fact that function application is done with the `$`
symbol, and using [Polish/prefix notation](https://en.wikipedia.org/wiki/Polish_notation)
like in Lisp. I did it like this because it's really easy to implement a parser
that does this. While I do want infix operators in the future, that's still a
work in progress.

### Check it out

Always read the `README`!

<blockquote class="embedly-card" data-card-key="cf9dee0ccfe8485e9df6cf6f4c5065f4" data-card-type="article"><h4><a href="https://github.com/charlydagos/bonlang">charlydagos/bonlang</a></h4><p>bonlang - Minimalist language created at ZuriHac 2016 in Zurich, CH</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

If you learned/liked anything from this post, make sure to star it so I get a
little bit of an ego boost :D

As you can see from the description, this all started with ZuriHac! I was a
mentor along with some cool and clever people. Great event!

### Quick words on internals

I haven't spoken much about the internals, as this is just an introduction post,
but since it's all a work in progress, in the future I'll discuss some of the
more fun parts of the language.

## Conclusions

Definitely a lot, but the most mentionable are:

- I had an idea of how [Abstract Syntax Trees](https://en.wikipedia.org/wiki/Abstract_syntax_tree)
worked, but had never decided to get my hands dirty with them. This experience
has definitely taught me a lot about that. Parsec makes it dead easy to make
your AST, by the way.
- There's a lot of very subtle decision making that comes when designing your
own language, but it has a huge repercussion later.

Perhaps the best summary of how I feel about it is expressed in this tweet
by Josh Stella

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Syntax is easy. Semantics are where it gets interesting.</p>&mdash; Josha Stella (@joshstella) <a href="https://twitter.com/joshstella/status/729365335481126914">May 8, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

There's a huge difference between what you _parse_, that is what the program
_"says"_, and what the program _means_. And that's where runtime errors come
in, which add another level of difficulty to the implementation themselves.

I'm not even through realizing how hard error messages are, and in that context
one of the biggest lessons from all of this is to not take for granted the
excellent work done in most major programming languages.

### Further work

- Better parser error messages.
- Better runtime error messages.
- More primitive functions.
- Importing other modules.
- Compile with LLVM, this one should be interesting.
- [Syntax support for Atom](https://github.com/charlydagos/language-bonlang),
is dead easy to get working.

<a href="/images/posts_2016-08-16-atom_syntax.png">
<img src="/images/posts_2016-08-16-atom_syntax.png" alt="Atom syntax is easy" />
</a>

## Listening to

Saw them recently in a small pub in Karlsruhe!

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A7IQY2gnoY5e4TVe5rWR7M2" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

## Amendments

As is usual, any and all amendments to this post can be found [here](https://github.com/charlydagos/blog/commits/master/posts/2016-08-16-bonlang-experimenting-languages.markdown).

## Footnotes

[^atleastforme]: At least for me, anyway. Normally I will read things all the
way through before I start to ask questions, or start to wonder about further
material/functionality/etc.
[^simontalk]: On that note, I recommend you watch [Simon Meier's talk on
commercial Haskell programming](https://www.youtube.com/watch?v=ywOvfjpbYR4).
I find that his tips, the code shared, and the [style guide](https://github.com/meiersi/HaskellerZ/blob/master/meetups/20160128-A_primer_to_commercial_Haskell_programming/code-by-elevence/docs/hs-style-guide.md),
are quite comprehensive and have helped a lot these past few months.
[^pun]: I had to make the pun, sorry.
[^stillworking]: ~~Though in the code examples there's still some legacy examples
with some variadic functions, I'm removing those; and it only works for
primitives.~~ **UPDATE:** I've removed all variadic functions.
[^notoptimal]: Keep in mind these implementations are not optimal. In the Haskell
example, we're appending a single-element list to the reversed tail of the
current list, in Haskell this is an `O(n)` operation where `n` is the length of
the first argument and we're doing this for all elements of the list!
[^shen]: I've barely mentioned Shen here and that's because I'm still quite new
to it, but it's very functional and seemingly has a lot of great features.
