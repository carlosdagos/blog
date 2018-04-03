---
title: "Lessons learned after working one year as a Common Lisp Developer - The Bad"
description: "The good side of my overall experience working as a CL dev"
tags: common lisp
---

_As mentioned in my previous post, all the Lisp I wrote was using the Franz
AllegroCL compiler, so other people might have different experiences._

_Also as mentioned in my previous post, all opinions are my own, nobody pays
me to write in my blog, etc._

## Intro

In [Part 1 of these posts](/posts/2018-03-28-one-year-common-lisp-developer-part-1-the-good.html)
I talked about all the things I really liked about Lisp, but I did mention
in passing that some of the Good things can sometimes be Bad. There's that,
but of course there's things that are simply bad.

## Lessons

### The Bad: CL is a double edged sword that will also shoot you in the foot

What I had heard this in the past from other _lispers_, was that "CL
is the lowest-level high-level language." It took a bit to let that sink
in, but at the end of the day there's implications to that.

Things in CL, even the nicer ones, can come back to bite you big time. And
if you get cocky, expect a lot of pain.

##### Beware of using lists everywhere

The nice thing about lists is that they can be used to represent
almost any other data structure.

Combine that with all the list accessors: `CAR, CDR, CAAR, CADR, CDAR, CDDR,
CAAAR, CAADR, CADAR, CADDR, CDAAR, CDADR, CDDAR, CDDDR, CAAAAR, CAAADR, CAADAR,
CAADDR, CADAAR, CADADR, CADDAR, CADDDR, CDAAAR, CDAADR, CDADAR, CDADDR, CDDAAR,
CDDADR, CDDDAR, CDDDDR`

And by the end of it you want to pull your hairs out knowing exactly which
data is being accessed at each point in time.

Please don't use lists where a [struct](http://www.lispworks.com/documentation/HyperSpec/Body/m\_defstr.htm)
makes more sense, and please **use classes** more often.

<div class="link">
<b>"Common Lisp Type Hierarchy" by Greg Pfeil</b><br/>
[http://sellout.github.io/2012/03/03/common-lisp-type-hierarchy/](http://sellout.github.io/2012/03/03/common-lisp-type-hierarchy/)
</div>

##### Beware of `declaim`

This is one of the things I mentioned previously that I like, but when used
wrongly, it can be a real pain in the butt.

So it turns out that not all code can or should be optimized, because
we as developers sometimes take certain liberties that we perhaps shouldn't,
like using macros excessively.

Long story short, we had a case where a pervasive use of `declaim` **without**
the use of `(eval-when (:compile-toplevel) ...)` was producing a segfault.
Yes, you read that right. A segfault.

The thing is, when you have a project that is over 10K lines of code, you
eventually start to run into issues and Stuff That Shouldn't Happen (tm).

Most CL compilers come with default optimization settings that are _safe_,
and if you abuse those, be ready for the pain.

##### Beware of thinking you _really_ know what you're doing

Well, given the above, that's mostly what this point is about. You can
have the most optimized and safe code available, and then you include
a new dependency into your project that perhaps does some fancy optimization
and then suddenly your app catches fire like no other.

In short, it's _very_ hard to know **exactly** all that is going on with your
app and how it will interact with existing Lisp code, and if you get
too cocky, you'll pay the price. And honestly, this could be true
for a lot of other programming languages, but I never saw it see it as often
as in CL.

##### Beware of macros (...or the "_macrology_")

As stated previously, macros are awesome, they allow you to abstract
over patterns, create your own forms, and overall make your code
more adaptable.

You know what's not nice? The increased compilation time you get from
abusing them. Again, I'm talking about apps that are over 10K LOC.

Also, as I mentioned above, one of CL's major points is that code should
be **reloadable** so you don't have to shut down the Lisp image. Guess
what the excessive use of macros will do? Get rid of that almost entirely.

You see, macros expand at compile time, so if you have a bug in your
macro, and you fix it, simply reloading the macro definition won't do anything
and your code will still be buggy. This means recompiling the whole thing, or
have very localized the places where it needs to be reloaded. It really
throws interactive development out of the whole experience - and, truthfully, it
makes for some huge headaches.

##### Beware the "dirty" lisp image

Interactive development again:

For all the nice things it has, it has a major pitfall that it doesn't guarantee
that things will work just as dandy as they do in your REPL when the Lisp
is restarted.

In CL, load order matters, so the thing about interactive development is that
accidentally adding cyclic dependencies between files in your project is
stupidly easy.

Nothing sucks more than fixing a bug in your REPL, running the tests, all
passing, and then integrations fail because the Lisp doesn't compile due
to a load-ordering issue you didn't catch when being immersed in interactive
development.

Not a good look.

##### Lots of other things are still problems

Mainly, the fact that the community is very small makes it such that whenever
you need an integration for some provider, like AWS, you seldom find
any resources online. Then you end up rolling out your own, which is normally
not as complete as if it were to be developed by a healthy Open Source
community.

This is a recurring pattern in the CL world, where there's not really
a "community" and it's mostly just a bunch of "lone wolves". Hardly
any cohesiveness or any standarisation (aside from the excellent spec
of course).

I saw as PHP got its shit together with [PHP-FIG](https://www.php-fig.org/),
and I think that unless something as radical happens, CL will just
keep having many "lone wolves" around[^wait].

##### DON'T use `cl-json`. JUST DON'T.

I'm not even gonna link to it.

I get it, it was probably written years ago. I really don't know the whole
story behind it. What I do know, is that there's really no good reason
to use this library over [`jsown`](https://github.com/madnificent/jsown).

And maybe even better, if you're working in SBCL or CCL, use
[`Jonathan`](http://rudolph-miller.github.io/jonathan/overview.html).

##### Hurts to say, but it might just be a dying language

I think that in the year 2018, I think that Lisp holds up very well
when compared to modern languages, even doing better than a vast
majority of them (in my knowledge).

However, it may be a dying language not because it lacks any features, but
because people are simply forgetting about it. I mean, of course, you
have elisp, which might keep "lisp" alive, but CL didn't even show
up in the 2018 StackOverflow Survey[^SOgoingdown]:

<div class="link">
<b>Stack Overflow Developer Survey 2018</b><br/>
[https://insights.stackoverflow.com/survey/2018/](https://insights.stackoverflow.com/survey/2018/)
</div>

I know only secondhand how hard it is to find CL developers, or even
capable developers willing to learn CL.

In my perspective, CL won't die because it's lacking any features or power
(because as I hope to have shown, it has plenty of both), but because
people just flock to different languages. It might be due to background,
like for example when I went to college, most people went either for
Ruby or Python, and I started getting acquainted with Haskell because I took
an optional class about formal verification[^butmaybeimhipster].

Whatever the reason, the future seems rather dark for CL. But then again,
it also feels like people have been saying this for about 15 years and here
we are. I might very well be wrong, and I hope so!

## Goodbye, CL

If you could sit through all my ramblings, then first of all THANKS for reading
my blog! Secondly, if it's not already obvious, I have lots of things
that I love about Lisp, and lots of things that maybe I don't love as much.

Like everything, it has its good and bad things. The thing about CL is that
the good is so good, but the bad is so bad, that it makes it a language where
most people either absolutely love it or absolutely hate it. Well, those
that know about it, anyway.

I'm so glad I got the chance to write client-facing and mission-critical code
in a language that has so much history, and in which many languages take their
root. But for now I have to say goodbye to CL and [my friends](https://twitter.com/RavenPackers),
at least for the foreseeable future, as I've decided to prolong my stay in
Australia, with a local job included. Luckily for me, I'll be writing Haskell
again so I might write posts loving it or ranting about it instead.

## Listening to

_Of course I'm still listening to King Gizzard:_

<iframe src="https://open.spotify.com/embed/album/0BJrif4AO6vWEtLRYYC3T2" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

## Amendments

All amendments to this post can be found [here]().

## Footnotes

<div class="link">
<b>European Lisp Symposium in San Pedro, Marbella, Spain</b><br/>
[https://www.european-lisp-symposium.org/2018/index.html](https://www.european-lisp-symposium.org/2018/index.html)
</div>

[^wait]: Of course, Lispers get together, too! You can check out the
European Lisp Symposium, happening in Southern Spain!

[^SOgoingdown]: Though honestly SO might be dying as well, so who knows.

[^butmaybeimhipster]: But then again, I find myself questioning _why_ I like
CL and Haskell. In truth, any technology that dares to do things differently
is enough to get my attention. I think that diversity is important, and
when a certain technology dares to change things from a fundamental perspective,
I think it adds positively to the mix. I would never come into an office
and demand that all Python code be replaced with Haskell, or that all
deployments should be done in Nix instead of CentOS, but I **do** believe
that we can take ideas from all places and apply them in practice. If you
always do things "the way they've always been," then you run the risk
of being outdated sooner or later.
