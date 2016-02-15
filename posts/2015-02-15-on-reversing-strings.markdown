---
title: On reversing strings 
---

One time, during an interview I was asked:

<div class="tip">
"Write a function that given a string input will output a reversed version of the input"
</div>

"Simple enough", I thought naively. So I very confidently wrote

<script src="https://gist.github.com/charlydagos/858ea56b6c2582ffbf43.js"></script>

I even took it to my shell and tested it...

<script src="https://gist.github.com/charlydagos/5b9f4dd3d7184668ee6b.js"></script>

I rule! 

Right?

## Not so..

So this where maybe the prefix "naive\_" makes sense for the gists up there. You see, the question is NOT "can you iterate over a string and generate a new one?". What they wanted to see if I knew how the language I chose (in this case, php) handles encodings. [Because encodings are very important](http://www.joelonsoftware.com/articles/Unicode.html)[^1].

### Why am I naive?

Let's start by looking at the request in parts.

	"Write a function that given a string input will output a reversed version of the input"
	 ------(1)-------      --------(2)---------      -----------------(3)------------------

	1) I must write 🤔
	2) I have one (1) input, and it's of type "string"
	3) I have one (1) output, and it's of type "string", but it's a reversed 

Seemingly I complied with everything.. Until I go a test the next code...

<script src="https://gist.github.com/charlydagos/5fcd07990e57f412d301.js"></script>

Broken characters. And in the last example we even get a DIFFERENT character? wtf? :(

### What the hell is a "string" anyway?

If you're a Comp Sci Major, you'd probably say "why, an array of `char`, of course 🤔". And yes, you're right. Except no. Not in php, as in php it's a scalar value, and if you don't believe me then test it on your own using [`is_scalar`](http://php.net/is_scalar) function in php. However for this purpose, since we're using `$string{$i}`[^2], then let's say that it is.

I'm not going to get into what a `char` is at this point. But if you're a Comp Sci Major you've probably heard someone say, at some point, "a `char` fits into a byte!". So we work with that.

Let's look at the following string.

	$str = "Hello, my name is Carlos 🤔";

And let's run some `str` functions over it, like [`strlen`](http://php.net/strlen), [`substr`](http://php.net/substr), and [`str_split`](http://php.net/str_split).

Before we get any code, let's thing about what out output should be. 

Let's count `char`s...

	echo strlen($str); // should be 26! count the characters yourself!

Let's get that `substr`

	echo substr($str, 18 /* start at C */, 8); // get 8 characters, so return "Carlos 🤔"	

And let's split that string into an array using `str_split`

	print_r(str_split($str)); // should print something like ['H','e',...,'🤔']

*Except that no.*

Because when we run the code, our actual values are...

<script src="https://gist.github.com/charlydagos/d9a29a39fa08d2ec2a22.js"></script>

### So what the hell is a `char` anyway?

Well, the code is not wrong, bro/sis. Because if it was, then geniuses like [Sara Golemon](https://github.com/sgolemon) would be out of a job. In fact, the code is doing exactly what you're asking it to do. In all cases.

Indeed, in the context of php a `char` is a byte. And php is treating everything it sees inside that string as an array of `char`, and every position is being returned correctly.

But look at that last part of having ran the `str_split`. There's four characters there (25-28) and I have no idea what that is. It _should_ be 🤔. But it's not. So let's take my super haxxor powers and see what's in there in the most haxxor format available: HEXIDECIMAL. I shall then use my ol' trusty [`bin2hex`](http://php.net/bin2hex) function.

<script src="https://gist.github.com/charlydagos/2b000273d39731541984.js"></script>

## Chars, Multibyte strings, and Grapheme clusters

So those last four bytes tell me something about a "f09fa494", since I got no idea what that is, [I google search it](https://www.google.com/search?q=f09fa494). Holy shit! It's my favorite emoji! 🤔!

### Back to `char`

So by now we know that php is not treating my favorite emoji like a `char`. Along this post we've seen that adding it to strings is just giving us headaches. It's not just this emoji, either, but characters contained in another one of my all time favorites: (╯°□°）╯︵ ┻━┻.

#### Let's stop using the wrong words here...

One of my mistakes, and probably yours too, at some point, is when we start confusing notation. Let's start to get some shit straight already. At least, again, in the context of php.

- `char`: A byte, contains a number, interpreted by the machine according to some encoding.
- `string`: An array of bytes.
- `encoding`: A table that the machine uses to map numbers to glyphs.
- `glyphs`: Lines, colors, and other artistic resources stored somewhere in your machine. Your brain sees them and makes an interpretation of it.

### Back to rotating a string

So let's go back to that simple, seemingly innocuous question that started this whole mess...

<div class="tip">
"Write a function that given a string input will output a reversed version of the input"
</div>

Tricky, tricky, tricky question.

So... what _are_ we being asked here? I suppose that a regular interviewer would at the very least expect you to not return broken characters. Right? So let's rephrase the question a little bit, because the way that it's formulated is a bit tricky. Let's be honest: we *did* reverse the string, a per the definition of a `string` as "an array of bytes". If we reversed the array, then we reversed the string. But no, because it's returning broken stuff, so let's say the next thing:

<div class="tip">
"Write a function that given a string input will output a reversed version of glyphs"
</div>

That's more like it! Getting to be a little bit clearer! 

### Multibyte strings

So am I to write, during an interview, a funtion that will somehow determine that I must grab a number of bytes from a string and place them all together at the front of the new string? Has php forsaken me? Does php NOT support emojis? Then how the hell does Facebook allow me to place the [2015 word of the year](http://time.com/4114886/oxford-word-of-the-year-2015-emoji/)? "😂😂😂😂"

Fret not. PHP supports your emojis. In fact, since a `string` is an array of `char`, and therefore an array of bytes, then it supports any string, in any encoding. **All you have to do is know what encoding you're working with**! This is paramount in _any_ application you're working. Know your encoding. [Do it](/images/didyoudoit.jpg).

Most of the time your encoding will be the encoding defined in your system. You can go ahead and try this now in your favourite Linux distro, or OSX[^3], `echo $LC_ALL`. For me, it's `en_US.UTF-8`, which unsurprisingly is what our previous Google search told us about 🤔 and "f09fa494".

In PHP you can also do `echo getenv('LC_ALL');`

So, are we to an easier solution to the problem?

Yeah. 

### Enter [Multibyte functions!](http://php.net/manual/en/mbstring.supported-encodings.php)

I did say that php will support any string in any encoding, but not right away. In that link you will see what encodings [this list of functions](http://php.net/manual/en/ref.mbstring.php) will support.

Using those functions as a reference and with a very impatient mindset, I just do the ballsy thing and type out a new script, with two functions: one that is simple, using your good'ol `str`-based functions, and another one using our new friends the `mb`-based functions. I also make it a php cli script because I can...

<script src="https://gist.github.com/charlydagos/0c9981aa4e879af00ef3.js"></script> 

And after running this on our [favorite shell](https://www.iterm2.com/), we get the output:

<script src="https://gist.github.com/charlydagos/345aec2e12d59a84de83.js"></script>

Eureka!

**Except no**.

<script src="https://gist.github.com/charlydagos/a1b2306c241e0127703a.js"></script> 

If you highlight the last line, you can see that it didn't rotate the Swiss flag glyph and the Argentina flag glyph. It just returned this shit[^4]

	[R][A][H][C]

... frustrating, isn't it? :D

Well, basically what happened is that the guys at [Unicode](http://unicode.org/) didn't want any fire coming the whole subject of ["who has a flag, who doesn't have a flag..."](http://unicode.org/reports/tr51/#Flags). So they came up with a clever way of staying out geopolitical issues. Basically, [there are ways of representing flags according to their regional indicators](http://unicode.org/reports/tr51/#def_emoji_flag_sequence). So CH is Switzerland, AR is Argentina, DE is Germany, and.. yeah, you get it. Country-ISO-2 codes. Clever guys, them guys at Unicode.

But it sucks, because [now there's a whole new range of glyphs I can't reverse using my new `mb`-based functions!](http://stackoverflow.com/questions/35197952/reliably-rotating-any-string)

### Grapheme clusters

Ah yes, Comp Sci to the rescue! :D

So our family of `mb` functions isn't going to cut it if we want to reverse glyphs out of our minds. This is because thinking about 🤔 and 🇨🇭 as being admitted by "multibyte" is wrong. Generally speaking, these form a part of a much larger, more complex group of glyphs represented by the as [Grapheme clusters](http://unicode.org/reports/tr29/). In the reading resources I shall leave below, there's an article that explains that UTF-8 is a "variable-byte encoding". Meaning just that, actually... each glyph in the system is addressed by UTF-8 variably: it can be a single byte, or 3, or 4.

This is why UTF-8 became famous in the first place[^5], it successfully leveraged ASCII fanatics (looking at you, people from the US) with all of us foreigners with our á and ê and ç characters that confuse the living shit out of people who've never left their hometown of Sandy, Utah.

So just because we encountered some "upper-bound" glyph, doesn't mean that we've stopped there. We can try to keep going. If we check `mb_strlen` for "🇨🇭"[^6], you'd see that the result is `2`. This, again, is correct! But not really what we're looking for, since to us, tiny dumb humans, this is a single glyph. If I hit delete, I want to hit it once and not twice. I expect software to work this way, and [not confuse me](https://www.sensible.com/dmmt.html). 

### Finally a solution!

## Lessons

## Considerations

- Performance:
- i18n:

### Resources and more reading

- [PHP Documentation on multibyte strings](http://php.net/manual/en/book.mbstring.php)
- [Extended explanation on encodings](http://kunststube.net/encoding/)
- [Everything Unicode](http://unicode.org/)
- [Grapheme clusters](http://unicode.org/reports/tr29/)

## Footnotes

[^1]: I interviewed for a Joel Spolsky-owned company. I totally bombed it and I knew it right there and then. They didn't ask me this question, fyi :) He is, regardless, one of the most influential people on my reading lists, for both good and bad reasons. Clever guy, that Joel.
[^2]: This means that we can access a `char` of the string directly. This would be exactly like doing [`substr($string, $i, 1)`](http://php.net/substr);
[^3]: Sorry, Windows, I'll not attend to you for now.
[^4]: I had to type these out since they were pretty much invisible.
[^5]: You would know this already, if you [had read](/images/didyoudoit.jpg) that [Joel Spolsky link](www.joelonsoftware.com/articles/Unicode.html) I left above on character encodings.
