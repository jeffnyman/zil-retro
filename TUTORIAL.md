# Tutorial

By this point you should have a working ZILF implementation set up on your machine in whatever way you want. As long as you can execute the `zilf.exe` and `zapf.exe` files, you should be fine.

1. [Running ZILF Interpreter](#zilf-repl)
2. [Compiling ZIL Source](#zilf-compile)

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
<SETG COUNT <>* ,COUNTER <RANDOM 4>>>
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
