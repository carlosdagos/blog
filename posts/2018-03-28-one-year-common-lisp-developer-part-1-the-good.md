---
title: "Lessons learned after working one year as a Common Lisp Developer - The Good"
description: "The good side of my overall experience working as a CL dev"
tags: common lisp
---

_I intented this to be a small post with some lessons learned after working
one year as a CL dev, however it turned out quite long (two parts!).
As always: All opinions are my own. This post is not endorsed by anybody._

_This post includes some Lisp code that works for AllegroCL, so all the
"lessons" noted here are after a year of writing CL using Franz's
AllegroCL compiler, which is a very much batteries-included Common Lisp
implementation. So my experience will differ from someone who has professional
experience with, say, SBCL or LispWorks._


## Intro

If it wasn't clear already, my favorite language is Haskell. If I could, I'd
work professionally as a Haskell dev always, but that's not possible,
as Haskell jobs are hard to come by, because honestly there aren't that many
places where Haskell fits.

## Landing a CL job

As I've mentioned previously, I took up a job writing CL full time. I was
fortunate enough to be of interest to [the company](https://www.ravenpack.com),
even having CL experience limited to just tinkering at home with it and various
other Lisps. I didn't even know Emacs, which of course wasn't required, but if
you're writing CL professionally in anything other than Emacs, please send me
a message because I'm interested in your setup -- I couldn't make anything work
smoothly aside from Emacs+Slime/Sly/Whathaveyou.

### Book recommendation

Once I had accepted a job offer, I had to prepare and learn CL **really fast**.
I was told I shouldn't hurry, but I felt like I had to anyway. I didn't want
to be the guy asking ridiculous stuff on my first day[^butiwas]. Of course,
a lot of things just come with experience, but I found a book that allowed me
to hit the ground running.

The book is called **Practical Common Lisp, by Peter Seibel**, and it can be
found in its online version here:

<div class="link">
<b>"Practical Common Lisp" by Peter Seibel</b><br/>
[http://gigamonkeys.com/book/](http://gigamonkeys.com/book/)
</div>

I have bookmarked many links from it, and I also have the hardcover version.
It is a timeless book. You don't have to get the hard cover version, of course,
as it's freely online and it's an amazing reference to bookmark for when
you're writing some `format` expression and you forgot how the hell to print
floats with 3 decimal spaces.

## Lessons

So many things that I consider to be "good" of Lisp can spill into the "bad"
very easily, and viceversa. I think that might be a characteristic of almost
everything: Doing too much of something Good can (and most likely will)
be Bad.

### The Good: CL is fancy and _fast_

Some people (even - now former - coworkers) would constantly mention the fact
that parentheses were "ugly". In my opinion, that's absolutely false.

Parentheses are one of the very few syntax tokens of the language. In
a language like Haskell you have some reserved "tokens" of the language,
which you cannot modify, and you cannot have any identifier name clash with a
reserved token.

So for example, in Haskell I can't call an identifier `let` or `module` because
it's expecting those to be reserved words of the language[^iknowiknow]. Much in
the same way that in Java you can't call a variable `class`, so everyone just
writes `klass` when they're doing some obviously misguided things with
Reflection.

Lisp can also be _fast_. Like crazy fast. I'll write about that below.

##### One structure for everything

As a lot of people know, **LISP** stands for **LIS**t **P**rocessing. The
languate itself **is a darn list**, and indeed, in the beginning,
_everything_ was a List. However, that's no longer true: there's arrays,
structs, classes (and a pretty well-developed class hierarchy), a sensible
condition system, etc.

Regarding the condition system in CL, it's not _just_ sensible, it's unmatched.
Feel free to convince yourself here:

<div class="link">
<b>"Condition Handling in the Lisp Language Family" by Kent M. Pitman</b><br/>
[http://www.nhplace.com/kent/Papers/Condition-Handling-2001.html](http://www.nhplace.com/kent/Papers/Condition-Handling-2001.html)
</div>

##### Almost everything is a macro

You know what was a fun experience? Seeing just how many things in Lisp are
a macro.

You'd think [`defun`](http://clhs.lisp.se/Body/m\_defun.htm)
(to define a function) would be some sort of built-in language feature that adds
some AST to some internal function mapping mechanism, right? Well, yes it *does
do that*, but it's not built-in!

<script src="https://gist.github.com/carlosdagos/ff9bca552369d56cbc9e2fb81b294fad.js"></script>

I really don't know what that macroexpansion is _really_ doing, but I know the
end result of it, which is that it adds a function.

How about [`case`](http://clhs.lisp.se/Body/m\_case\_.htm)? Surely, `case` is
a built-in mechanism, right? Not so fast:

<script src="https://gist.github.com/carlosdagos/b92fd39bcc311fde799d7f530a22b56f.js"></script>

So `case` is built on top of [`cond`](http://clhs.lisp.se/Body/m\_cond.htm)! So
then, `cond` **must** be a built-in... right? You can see where this is going:

<script src="https://gist.github.com/carlosdagos/39da016e13a365b29db444601acb7f4f.js"></script>

So `cond` is not only a macro, but a recursive macro, built on top of `if` and
itself until some base case.

Now [`if` **is** a special operator](http://clhs.lisp.se/Body/s\_if.htm), but
to me it was eye-opening just how many forms are just macros on top
of macros.

##### You can talk with the compiler lot (i.e. "the programmable programming language")

###### Execute code in different stages of the compiler

There are so many great things you can do in CL.

Do you want to declare a function that will *only* be available at compile time?
Or what about performing some action, like instructing the compiler to
optimize the file being compiled for maximum speed?

Fine: Just use `eval-when`! The [`eval-when` *special operator*](http://clhs.lisp.se/Body/s\_eval\_w.htm)
will allow you to load and execute pieces of code during the different stages
of the compiler, and this can be immensely powerful.

Can this get tricky? Of course it can, just ask [Fare](https://twitter.com/fare):

<div class="link">
<b>"EVAL-WHEN considered harmful to your mental health" by François-René Rideau</b>
[https://fare.livejournal.com/146698.html](https://fare.livejournal.com/146698.html)
</div>

###### Only compile expressions when certain "features" are available

Despite the hardship, `eval-when` is **extensively** used to push keywords
into a variable called [`*features*`](http://www.lispworks.com/documentation/lw50/CLHS/Body/v\_featur.htm),
which will allow you to, at a later stage of the compiling process, decide
what you want to compile and what not to.

For example, you can load your lisp and try to start up `swank` but only if the
library is loaded. You could make use of this to start an alternative
server if not. In that situation, you could do:

<script src="https://gist.github.com/carlosdagos/9a5b3f711397e8281642f13e579c8c43.js"></script>

Is this the best thing ever? Certainly not. Can it be dangerous? Certainly, yes.
Is it awesome nonetheless? Yes (IMO).

###### Create your own reader macros

- Are you writing some long multiline strings in your code, and are annoyed by
delimiters like double quotes that you have to keep escaping?
- Would you prefer to write timestamps in ANSI format?
- Would you prefer to type JSON structures in shorthand format, but just get
them in a CL structure?

**Say no more:**

Consider the following snippet, where we declare some utility functions, and
create a [**readtable**](https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node192.html)
with specific dispatch characters.

<script src="https://gist.github.com/carlosdagos/4d39fc13ba7cc31c37f77d2b27260bc4.js"></script>

We start out by setting the [`*readtable*` variable](http://clhs.lisp.se/Body/v\_rdtabl.htm)
to our newly created readtable in our REPL and just type away:

<script src="https://gist.github.com/carlosdagos/9f07ec06d90dfc85216196f6a64a4770.js"></script>

This, to me, is an incredible feature to have. And, when you combine it
with the power of macros and Metaobject Programming, really highlights why CL
is truly a programmable programming language.

Still not convinced? In his `xooglers` recount, [Ron Garret](http://www.flownet.com/ron/)
talks about how we would adapt one particular product to support multiple
languages. His example is basically replacing the default string reader
with one that will replace all strings with their responding translation if
one exists. The example below is for AllegroCL, but it's totally adapted
from his CCL example[^thisisonlyanexample]:

<script src="https://gist.github.com/carlosdagos/b9e4e9170a6119d63b82fdee17842050.js"></script>

I suggest reading his `xooglers` stuff[^rongarretiscool]:

<div class="link">
<b>"Xooglers Rises From the Ashes" by Ron Garret</b><br/>
[http://blog.rongarret.info/2009/12/xooglers-rises-from-ashes.html](http://blog.rongarret.info/2009/12/xooglers-rises-from-ashes.html)
</div>

###### Tell the compiler that certain functions or files are fine to optimize

And it will optimize the sh\*t out of them.

As Lisp is a dynamic language, it does what you would expect a dynamic language
to do, like checking that you compare a string against a string, or that
you add two numbers, and many other things that it does without any
type information. If it finds a runtime error, it will spit out an easy-to-read
**stack trace** where you can debug what went wrong. This is what most languages
do[^breakingcondition], so it's no surprise.

But, what if you have a function that you _really_ need to be fast, because
it's running in a tight loop, and you _Really Know What You Are Doing (tm)_, so
you don't want the compiler getting in the way. You just wanna go **fast**.
Well, check this one out:

<script src="https://gist.github.com/carlosdagos/40949c53ff85d0027e127fadf5fb3869.js"></script>

So in our REPL we typed up and compiled two functions: `search-tree`
and `search-tree*`, and the only difference between them is that one has
an [`optimize`](http://www.lispworks.com/documentation/lw50/CLHS/Body/d\_optimi.htm)
in the middle there.

Reading the `optimize` declaration, we can see that the second function
`search-tree*` will compile for _speed_ and no debug. The rest is the same: a
depth-first search on a tree (a nested list).

So we can see the results below:

<script src="https://gist.github.com/carlosdagos/81b3b64469a518463fe4335fb9a70610.js"></script>

In total, `search-tree*` is nearly **twice** as fast, with hardly any
code changes. I haven't seen any other programming language where this is
possible, and it's extremely helpful.

See, what we did here with the `optimize` declaration is tell the compiler
**not to keep a stack trace**[^alsomuchmore], which is something it does by
default to help when debugging. This makes the execution much, much faster,
because now the function is tail-recursive, whereas before it was keeping a
stack, which is something that can hinder performance greatly.

Want to do the same, but for an entire file? Just type this at the
top of your Lisp file:

```
(eval-when (:compile-toplevel)
   (declaim (optimize (speed 3)
                      (space 0)
                      (debug 0))))
```

But, **beware**.

##### Parentheses are a solved problem

If you're writing CL and you're not using `parinfer`, then seriously:
**what in the hell are you doing?**

Parentheses are a solved problem. There's no need to manually align them,
and no need to manually check that they're balanced.

Do yourself a favor and install [**Parinfer**](https://shaunlebron.github.io/parinfer/).
You don't even have to use Emacs, and it supports all Lisps. So there's no
excuse. Install it. [Do it.](/images/didyoudoit.jpg)

###### Interactive development is wonderful

As I'm typing in Emacs with a fully loaded Lisp and gigabytes of data loaded
in RAM, about 90% of the time I can simply hover over a function and type
`C-c C-c`, and after a minor flash and a message in the minibuffer saying
that the "compilation [is] complete", I can run my tests again and suddenly
they're passing! I fixed the problem in my editor, which convenienty hosted
a REPL where I could issue the test command.

Interactive development is not a side-effect of CL, but a feature and
important to its condition system (which includes the notion "restarts"), and
any lisper worth their salt will write code that adapts to live reloading.

Having accesss to a REPL is so important to the CL community and its background,
that one of the most quoted stories related to that is mentioned in the book I
linked to above, but here's a Google Talk regarding that:

<iframe width="100%" height="315" src="https://www.youtube.com/embed/_gZK0tW8EhQ" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

Mr Garret in this talk is very biased and spills lots of his own opinions, but
what you can keep from the video is that they debugged a satellite from
very far away using Lisp (at min 42:00). Nice stuff.

###### There's more!

There's so much more to say, but I better stop here for "the good". I could
continue, but I would also recommend that you read more on things like the
type system and the fantastic `disassemble` function from here:

<div class="link">
<b>"Performance and Types in Lisp" by Bob Krzaczek</b><br/>
[http://blog.30dor.com/2014/03/21/performance-and-types-in-lisp/](http://blog.30dor.com/2014/03/21/performance-and-types-in-lisp/)
</div>

## Listening to

<iframe src="https://open.spotify.com/embed/album/6z2Iou0zZDnOeV1uYyNena" width="100%" height="380" frameborder="0" allowtransparency="true"></iframe>

_One of the best albums of 2017 **easy**. My favorite story is about
the cyborg Han-Tyumi, whose only wish is to vomit and die._

## Amendments

Amendments to this page can be found [here]().

## Footnotes

[^butiwas]: But I was.
[^iknowiknow]: Yes, yes. You can just append `'` to everything and then it's a
valid identifier. Still, it's not "the same".
[^breakingcondition]: Well, with the exception that in the Lisp condition
system, the runtime will actually set a _break_ in the execution, and in
a lot of situations allow you to amend the problem and continue executing.
[^rongarretiscool]: I've enjoyed reading (and listening to) Ron Garret. For some
reason, a lot of what he says makes a lot of sense to me. Maybe it's an age
thing, I'm getting old after all.
[^thisisonlyanexample]: In truth, this piece of code is only to show an example.
But, I've also thought that you could instead just set the macro character
to be a single quote instead. Then you have single quotes that act as
strings that the programmer controls, and double quotes act as everyday strings.
Now that could make for some interesting experiments.
[^alsomuchmore]: Actually depending on the Lisp implementation we could have
told the compiler to do a bit more than that. Always read the docs!
