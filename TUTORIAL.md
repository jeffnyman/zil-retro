# Tutorial

By this point you should have a working ZILF implementation set up on your machine in whatever way you want. As long as you can execute the `zilf.exe` and `zapf.exe` files, you should be fine.

1. [Running ZILF Interpreter](#zilf-repl)
2. [Compiling ZIL Source](#zilf-compile)
3. [Basic Game Start](#basic-game)

This guide will be a work in progress. I will largely be taking you through how to create some of the files that are distributed with ZILF as part of its `sample` directory. Note that you'll probably want to set up whatever convenience mechanism you prefer for compiling files. In my [`projects`](https://github.com/jeffnyman/zil-retro/tree/master/projects) directory, you'll see I have a [Makefile](https://github.com/jeffnyman/zil-retro/blob/master/projects/Makefile).

I designed this Makefile so that I could type something like this:

```
make build testing
```

And that would compile a file called *testing.zil* (using *zilf.exe testing.zil*) and assemble a file called *testing.zap* (using *zapf.exe testing.zap*). Then I can do this:

```
make play testing
```

That would open a file called *testing.z3* in whatever Z-Machine interpreter I currently have installed and associated with such files. This Makefile clearly wouldn't work on a Windows operating system. Eventually I'll include a batch file that would do something similar.

<a name="zilf-repl"></a>
## Running ZILF Interpreter

This is a bit of a side path to creating games but you can use ZILF as a real-time interpreter. This can help you try out constructs that you learn in ZIL to see how they work. How this works is that you can start ZILF with no parameters to enter an interactive mode. In this mode, ZILF can interpret top-level ZIL constructs without compiling. MDL could similarly be run in an interactive mode. If you are familiar with languages like Ruby, Python, or JavaScript you'll likely recognize this is like a REPL (Read-Eval-Print Loop), where you enter an MDL or ZIL expression, and ZILF evaluates it and immediately prints a response.

By the way, if you're wondering what "ZIL" and "MDL" are all about, check out my [ZIL context](https://github.com/jeffnyman/zil-retro/blob/master/CONTEXT.md).

To get started, just run `zilf.exe` to get into the REPL. At the REPL prompt, which is just a greater than sign, enter this:

```
<+ 1 2>
```

This adds the integers 1 and 2. Thus you should see a response of 3 in the REPL itself. Now try this:

```
<SET A 10>
```

This sets the local variable, called `A`, to the integer 10. Let's try another one:

```
<G=? <+ 4 1> 10>
```

This returns TRUE if the sum of 4 and 1 is greater-than or equal to 10 and returns FALSE otherwise. Now let's try something a bit more ambitious:

```
<SETG COUNTER 10>
<SETG COUNT <* ,COUNTER <RANDOM 4>>>
```

First we set a global variable of `COUNTER` to 10. Then we set another global variable (`COUNT`) to the product of the value of the global variable `COUNTER` and some random number from 1 to 4 using something called `RANDOM`.

This will likely get you an error: *[error MDL0200] &lt;stdin>:1: calling unassigned atom: RANDOM*.

I did this to introduce a few things, which is that you will get errors and it helps to see what they look like. Also this notion of an "atom" might be require some explanation since the terminology comes up here and there. I'll come back to that later. Also note that you have to be mindful of your operations. Setting a *local* variable required the use of `SET` whereas setting a *global* variable required the use of `SETG`.

Something else to note is that if you have never worked with a Lisp-like language before, the code constructs above might be a bit odd to you. What I showed you there were "forms" (I'll come back to that term later too) and the first element of a form indicates the operation to be performed (i.e., SET, SETG, etc). All other elements are the arguments to that operation.

The so-called "prefix notation" can be confusing if you haven't been exposed to this before. So just know that `4 + 7`, which is called "infix notation" in most languages, would be rendered as `<+ 4 7>` in ZIL or MDL (or Lisp). What gets more interesting is when you consider something like this:

```
9 + (4 * 6 - 6 / 3)
```

In ZIL/MDL/Lisp that would be:

```
<+ 9 <- <* 4 6> </ 6 3>>>
```

What all of this also implicitly shows is that you must balance the angle brackets appropriately, just as you would balance the curly brackets in languages that had them, like C, C++, C#, and Java.

Finally, you can type the following:

```
<QUIT>
```

That will exit the ZILF interactive mode.

<a name="zilf-compile"></a>
## Compiling ZIL Source

Create a file called **testing.zil**. Let's start with this:

```zil
"Testing ZIL"
```

A ZIL program consists of a series of expressions. The above is an example of a "string expression." It's literally just a piece of text in quotes. A string that, like this one, isn't inside any other expression can be used as a comment. You'll see more strings soon that are not comments.

On that topic, there *is* the concept of an actual comment. You can use a semicolon in front of any line:

```zil
; "This is a comment."
```

Any lines that start with `;` are ignored by the compiler. More specifically, anything after the semicolon can be a complete expression. In this case, that expression is a string. But any expression can have a comment placed before it and thus this can be used to comment out any ZIL code.

If you were to compile this file -- and you should try to do so! -- you would get an error: "missing 'GO' routine".

A routine is the most common item that makes up ZIL code. More specifically, every program must have a particular routine called `GO`. This routine must be present in order for the ZIL to be compiled to z-code. The reason for this is that `GO` is the first routine executed by the interpreter. This is sort of like `main()` in languages such as C, C++, and Java. Let's add this routine in:

```zil
"Testing ZIL"

<ROUTINE GO ()>
```

Okay, let's talk about this.

In ZIL, there is the concept of a `FORM`. A "form" is a collection of other objects surrounded by balanced angle brackets. A form in ZIL is used to perform any of the various possible ZIL operations. Here `ROUTINE` is a form. There is also the concept of an `ATOM`. An "atom" is basically any word that identifies an operation, variable, object, verb, and so forth. This is sort of like the concept of an "identifier" in many other languages. Here `GO` is an atom.

What this is saying is that this ZIL program has a routine form whose atom is "GO".

Incidentally, the basic parts of a routine look like this:

```
<ROUTINE ROUTINE-NAME (argument-list)
	<internals of the routine>>
```

With all that being said, let's try and compile.

You'll get an error: *"ROUTINE requires 3 or more args"*. As it turns out, this error message is not correct, at least so far as I can tell. If you look at the schematic of a routine provided above, this error would imply I need at least three arguments in the argument list provided with GO. As it turns out, however, you don't actually need to put three arguments in place. But you *do* need to have something to execute in the routine.

(As a note: the above is incorrect on my part and the error is correct. I will revisit this in the [Cloak of Darkness](https://github.com/jeffnyman/zil-retro/blob/master/CLOAK.md). I leave it here as an example of how it's easy to to get some details wrong when you are working in the context of a Lisp-like language and are unfamiliar with the constructs.)

Let's modify our example:

```zil
"Testing ZIL"

<ROUTINE GO ()
  <PRINTI "Testing ZILF">>
```

Here `PRINTI` -- which is a "form" -- means to print an "immediate string."

Incidentally, you might be tempted to do something like this:

```zil
"Testing ZIL"

<ROUTINE GO ()
  <PRINTI "Testing ZILF">
>
```

Here I just moved the last angle bracket down to the empty line, sort of using it like I might a curly brace in other languages. This will not work. Or, rather, it will likely compile but lead to output that is inaccurate. (Try it if you want. Experiment!)

If you compile this new source code, it will work. And, as you can see, I haven't put in place three arguments, which would go in the parentheses. I have no idea why ZILF gives the error message that it gave us.

When I say our new source code "works", that means you should see the text "Testing ZILF" in your interpreter.

Let's add another expression:

```zil
"Testing ZIL"

<ROUTINE GO ()
  <PRINTI "Testing ZILF">
  <CRLF>>
```

Here `CRLF` prints an end-of-line sequence, which is a carriage return (CR) or line feed (LF) in ASCII.

So let's take stock of what we have. We have a routine and, within that routine, we have two statements that are expressions. One prints a message and another prints a carriage return. When this program is compiled to z-code and run in an interpreter, it will print the message "Testing ZILF" followed by a line break, and then quit.

One thing I should note is that, according to its own documentation, ZILF is *case-insensitive* by default. This means forms and atoms can be entered with any capitalization. Apparently if you wanted to run ZILF in a case-sensitive mode, you would have to apply the "-s" switch when calling it. However, I have found this to be inaccurate. The case does matter. Try, for example, changing the case of "ROUTINE" to "routine" or "GO" to "go" and you will find that you can't compile.

Now let's add some directives.

Directives control the compilation process and should be placed at what's called the "top level" of your source. This means they should not be inside of a routine or any other expression. Here's what you can do:

```zil
"Testing ZIL"

<VERSION ZIP>

<ROUTINE GO ()
  <PRINTI "Testing ZILF">
  <CRLF>>
```

I'm using the VERSION form to set the version of the Z-Machine that will be targeted in terms of what my game is compiled for. ZILF defaults to Z-Machine version 3, meaning that ZILF generates ZAPF assembly code for a version 3 game. This is why even without this line in place, my file was compiling to *testing.z3*.

Here "VERSION ZIP" is equivalent to "VERSION 3". You can also use "VERSION EZIP" ("VERSION 4"), "VERSION XZIP" ("VERSION 5"), or "YZIP" ("VERSION 6"). The terms "ZIP", "EZIP", "XZIP" and "YZIP" were terms that Infocom used to differentiate the generations of their Z-Machine. You can also compile to version 8 with the use of "VERSION 8". Note that this version is a non-Infocom variant and thus has no "zip" name associated with it.

You might wonder why any of this matters. The choice of Z-Machine version does impact what ZIP instructions will be allowed in routines. The choice of version also impacts the maximum size of the game (number of objects, amount of code and text, etc.), and the availability of certain features like the ability to undo moves, the ability to provide custom status lines, the ability to provide graphics and sound, and so on.

Let's add another directive:

```zil
"Testing ZIL"

<VERSION ZIP>
<CONSTANT RELEASEID 1>

<ROUTINE GO ()
  <PRINTI "Testing ZILF">
  <CRLF>>
```

Here I'm using a form called a `CONSTANT` and an atom called `RELEASEID` to provide a release number for my game. While this is clearly optional since we were able to compile without it, this is mandatory for version 5 and above. To see that in action, don't include that directive and change your VERSION directive to "XZIP". You should get an error when assembling takes place.

Incidentally, you can also use `ZORKID` here instead of `RELEASEID`. "ZORKID" is "what Infocom's games used.

That's probably as far as we need to go with this example. The next part of this tutorial will get more into the construction of a game. Or, at least, the basis for how a game would be started.

<a name ="basic-game"></a>
## Basic Game Start

Now let's get into some source that starts us on the path to creating a game.

Let's create an entirely new source file; call it **basic.zil** and start off the source with the following:

```zil
"Basic Game"

<VERSION ZIP>
<CONSTANT RELEASEID 1>
```

You should recognize the various elements there if you went through the previous section.

There's a lot that goes into a game and you don't want to recreate all of the basic mechanics yourself, of course. That's why most game systems come with a library that provides those basic mechanics for you. ZILF is no different. A core part of that library is the parer. Let's have our basic game use that parser. Add the following:

```zil
<INSERT-FILE "parser">
```

INSERT-FILE is another directive that does pretty much what it sounds like. This essentially includes whatever file you specify in the source file. Here "parser" refers to `parser.zil` which is part of your `library` folder. Note that if the file's extension is omitted, as it is in my example, an extension of ".zil" will be assumed.

This directive is how you bring in library files but this is also how you could break up your own game into multiple source files. Generally you'll have one "main" file that will be the starting point for your game. That main file will have `INSERT-FILE` directives to bring in your other source files.

This is, in fact, how `parser.zil` works. It calls in a bunch of the other files that are part of the library. ZILF's library of code is tailored for writing interactive fiction. As such it implements a parser and a world model. Ostensibly this is very similar to what the Infocom implementors had available to them.

If you were just to compile this, you would get the *"missing 'GO' routine"* we've seen before as well as another error *"undefined global constant: GAME-BANNER"*. So let's get the game banner part fixed first:

```zil
"Sample Game"

<VERSION ZIP>
<CONSTANT RELEASEID 1>

<CONSTANT GAME-BANNER
"SAMPLE GAME|
An Interactive ZILF Example">

<INSERT-FILE "parser">
```

I should note that you might see older code that shows this:

```zil
<CONSTANT GAME-TITLE "SAMPLE GAME">
<CONSTANT GAME-DESCRIPTION "An Interactive ZILF Example">
```

That appears to be a previous way of doing things.

We're going to need a GO routine as before. Here's a start on that:

```zil
"Sample Game"

<VERSION ZIP>
<CONSTANT RELEASEID 1>

<CONSTANT GAME-BANNER
"SAMPLE GAME|
An Interactive ZILF Example">

<ROUTINE GO ()
  <CRLF> <CRLF>>

<INSERT-FILE "parser">
```

At this point, this game will compile but the game itself would not actually start up. Or, rather, what would happen is that if you tried the game in your interpreter of choice, the interpreter will likely just quit. There's basically nothing happening in our game at all.

The *Learning ZIL* guide says this:

> When a player boots the game, the first thing the interpreter does (as far as you're concerned) is to call a routine called GO. This routine should include things like the opening text, the title screen graphic, a call to V-VERSION (to print all the copyright and release number info), and a call to V-LOOK (to describe the opening location).

Okay, so let's start with some of that. Let's modify the `GO` routine accordingly:

```zil
<ROUTINE GO ()
  <CRLF> <CRLF>
  <TELL "Welcome to the Testing ZILF Experience" CR CR>
  <V-VERSION> <CRLF>
  <V-LOOK>>
```

This will compile and the game will start up in the interpreter but it likely won't look right. For example:

```
Welcome to the Testing ZILF Experience

SAMPLE GAME
An Interactive ZILF Example
Release 1 / Serial number 190727 / ZILF 0.8 lib J4

s   cpzsp cg
```

And that's it. The interpreter will stop.

Let's turn to *Learning ZIL* again:

> The last thing that GO should do is call the routine called MAIN-LOOP. MAINLOOP is sort of the king of ZIL routines; other than GO, every routine in the game is called by MAIN-LOOP, or by a routine that is called by MAIN-LOOP, or by a routine that is called by a routine that is called by MAIN-LOOP, etc. MAIN-LOOP is basically a giant REPEAT which loops once for each turn of the game.

So let's add that:

```zil
<ROUTINE GO ()
  <CRLF> <CRLF>
  <TELL "Welcome to the Testing ZILF Experience" CR CR>
  <V-VERSION> <CRLF>
  <V-LOOK>
  <MAIN-LOOP>>
```

With that you have a command parser in your game in that you can actually type things in to it. But you still have those odd letters showing up.

The problem is that there's nowhere for the player to be! That text is being generated by `V-LOOK`. So let's create a generic room. This will be done after the insertion of the parser:

```zil
...
<INSERT-FILE "parser">

"Objects"

<OBJECT STARTROOM>
```

Objects are data structures that are usually used to represent physical objects in the simulated world of the game.

However, just because we've defined this object, that doesn't mean much. The player actually isn't in this location. We have to do a few things in our `GO` routine:

```zil
<ROUTINE GO ()
  <CRLF> <CRLF>
  <TELL "Welcome to the Testing ZILF Experience" CR CR>
  <V-VERSION> <CRLF>
  <SETG HERE ,STARTROOM>
  <MOVE ,PLAYER ,HERE>
  <V-LOOK>
  <MAIN-LOOP>>
```

`HERE` is a global variable that is always set to the current location of the player. So what we do is use the `SETG` (for setting a global variable) to change the value of `HERE` to that of our `STARTROOM` object. Each object has a location (`LOC`). You can change the `LOC` of an object using the `MOVE` form. Here we move the built-in object `PLAYER` to `HERE` which we established was the `STARTROOM`.

Notice those commas. When writing ZIL code, all global variables, room names and object names must be preceded by a comma. As you'll learn later, this is distinct from local variables which must be preceded by a period.

So that's good, we're not getting any weird letters any more. But we're also not really getting much of anything.

Each object has a printable name. Right now we haven't given our `STARTROOM` object such a printable name. Let's change that:

```zil
<OBJECT STARTROOM
  (DESC "TESTING LAB")>
```

So now the player can actually see what location they are in. However, this is actually a dark room. Trying out some commands shows you that right away:

```
> i
It's too dark to see what you're carrying.

> look
It is pitch black. You can't see a thing.
```

Let's change that situation:

```zil
<OBJECT STARTROOM
  (DESC "TESTING LAB")
  (FLAGS LIGHTBIT)>
```

Objects have flags that can be set on them. In this case, I'm using `LIGHTBIT` which means that the object is "lit" or is "providing light."

Now you'll find that you can actually see in the location. Granted, we haven't put in much to see but at least the concept is working correctly.

This brings up something else, however. You generally want to specify an object's location, which is given as the name of a parent object. But what does that mean for `STARTROOM`? Let's add one more thing to our object:

```zil
<OBJECT STARTROOM
  (IN ROOMS)
  (DESC "TESTING LAB")
  (FLAGS LIGHTBIT)>
```

The `IN` form defines the object's location. `LOC` can be used instead of `IN` if you prefer, the former being what Infocom used.

This is now basically a working game, albeit with nothing at all to do. But what you see here is a generic structure that would provide you the starting point for your own games.
