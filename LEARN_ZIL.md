**NOTE:** This document is very much a work in progress. It's meant to start from the conceptual beginnings and build up simple ideas leading to more complex ideas. This might subsume some of my other documentation here.

The *ZIL Course* gives us the following context:

* "Z Implementation Language" (ZIL) was used to write games.
* MDL was the host language for ZIL.
* ZIL was thus created as a subsystem of MDL.
* ZIL code was run through a ZIL Compiler (ZILCH).
* This produced "Z Assembly Language".
* This was assembled by a "Z Assembler Program" (ZAP).
* This process created "Z-code."
* The z-code was then interpreted by a "Z-machine emulator" (ZIP).
* All of this was called the "Z System."

The quoted bits are the terms used by the document.

The *ZIL Course* provides some conceptual breakdown of ZIL:

* Objects and classes are called a TYPE.
* Every operation in ZIL expects to receive objects of a specific TYPE as an argument.
* FORMs are used to perform the various operations in the ZIL world.
* FORMs are represented as a collection of other objects (of any type) surrounded by balanced angle brackets.

Thus we get that FORMs will take in TYPEs.

## Running ZILF Interpreter

This is a bit of a side path to creating games but you can use ZILF as a real-time interpreter. This can help you try out constructs that you learn in ZIL to see how they work. How this works is that you can start ZILF with no parameters to enter an interactive mode. In this mode, ZILF can interpret top-level ZIL constructs without compiling. MDL could similarly be run in an interactive mode.

If you're familiar with languages like Ruby (`irb`), Python (`python`), or JavaScript (`node`) you'll likely recognize this is like a REPL (Read-Eval-Print Loop), where you enter an MDL or ZIL expression, and ZILF evaluates it and immediately prints a response.

To get started, just run `zilf` (or `zilf.exe`) to get into the REPL.

## ZIL Instructions

ZIL instructions, also called operation codes (or just opcodes), are the way that you can communicate with the interpreter.

## Basic Operation

At the REPL prompt, which is just a greater than sign, enter this:

```zil
<+ 1 2>
```

This whole construct is a FORM. The first element of a form indicates the operation to be performed and all other elements are the arguments to that operation. Here the operation is `+` and the arguments to that operation are `1` and `2`. Thus you should see a response of 3 in the REPL itself.

The above is one of the arithmetic instructions. This is actually an `ADD` instruction to the interpreter. This operation appears in ZIL code as a `+` but the compiler changes it to `ADD`.

### Prefix Notation

Let's take a moment for a brief aside here.

Given that MDL and ZIL are based on a Lisp-style approach, what you see above is called "prefix notation." This is distinct from what's called "infix notation." The simple idea being that the operator (`+` in this case) comes before the operands rather than between them. The above in most programming languages would look like this:

```
1 + 2
```

To consider another example, here are two calculations in infix stsyle calculation:

* `9 + (4 * 6 - 6 / 3)`
* `(10 + 5) * (26 / 2 - 5)`


In ZIL/MDL/Lisp those would be:

* `<+ 9 <- <* 4 6> </ 6 3>>>`
* `<* <+ 10 5> <- </ 26 2> 5>>`

A key thing to note here is the balancing of the angle brackets that must take place. It can sometimes help to break out ZIL expressions a bit using whitespace. For example, taking the last prefix calculation there, it could be framed like this:

```zil
<*
  <+ 10 5>
  <-
    </ 26 2>
  5>
>
```

As you can tell by looking at it there were even other ways I could have used whitespace to make it clear what was happening. For example, I could do this:

```zil
<*
  <+
    10 5
  >
  <-
    </
      26 2
    >
  5>
>
```

Whether this becomes helpful or more confusing is really up to each person. One thing note is that it will never be as clear as `(10 + 5) * (26 / 2 - 5)` for most people. And I bring this up here with this relatively simple example of numbers because your code constructs can get quite a bit more complicated than this and you need to prepare yourself for how you're going to make that code readable and understandable.

## Back to Our Operation!

Our `<+ 1 2>` operation requires two arguments, both of which must be of type FIX.

Objects of a TYPE called FIX represent integers in the range of -32767 to 32767. These numbers are always represented in decimal.

## Other Operations

You've already seen this when I discussed the prefix notation, but you can use the other standard arithemtic operators. For example:

```zil
<- 50 10>
<* 5 10>
</ 30 5>
<MOD 10 3>
```

The above is showing subtraction, multiplication, division and modulus (remainder). Each of these, just like addition, returns the appropriate type, which is a FIX.

And just like `+` (which gets converted to `ADD`), the above get converted to `SUB`, `MUL`, and `DIV` by the compiler.

## More Operations

Now let's consider another example that introduces another concept:

```zil
<SET A 10>
```

This is another FORM. Here I'm using a `SET` operation, which is considered one of the variable instructions. I'm using this to set something called `A` to a FIX value (`10`). Here `A` is a variable. Here's another example:

```zil
<SET B 20>
```

A and B are both an ATOM. So our above operations, schematically, were this:

```
<SET atom-name value>
```

ATOMs in ZIL can probably best be thought of as identifiers in terms of other programming languages. An ATOM identifies some specific, named thing. However, an ATOM can also most commonly be thought of as variables. In this context, an ATOM can be considered LOCAL or GLOBAL. We'll have a chance to explore this concept more as we go on.

Now let's put those variables we just set up to use in an expression that should look a bit familiar:

```zil
<+ .A .B>
```

This is different FORM than what we started with, but it's the same operation. Although you might wonder: what are those periods? In ZIL, to retrieve the value of a LOCAL ATOM, you have to preface the name of the atom with a period. How do I know I'm dealing with LOCAL ATOMs here? Because that's what the `SET` operation sets up. We essentially have two local variables.

You can also set global variables.

```zil
<SETG C 5>
<SETG D 10>
```

Here note that I'm using `SETG` rather than `SET`. Then we can do this:

```zil
<+ ,C ,D>
```

Again, similar to what we did before but, in this case, to retrieve the value of a GLOBAL ATOM, you have to preface the name of the atom with a comma.

### A Bit About LOCAL and GLOBAL

A LOCAL ATOM will generally be used as a variable within a ROUTINE and is only accessible within the context of that ROUTINE when it is executing. The value of a GLOBAL ATOM, by contrast, is accessible to all ROUTINEs at all times.

In the current context, there's no effective difference between local and global since we're operating in a "top level" routine of the REPL. The general concept of routines, and the specific concept of an ATOM known as ROUTINE, will be dealt with very shortly.

## Predicates

There are various operations within ZIL that basically ask a question. These kinds of operations are known as predicates. A predicate is basically anything in ZIL whose value can be true or false. Some of the most common operations in ZIL are predicates and will return one of two values: `true` (not zero) and `false` (zero).

Consistent with the idea of answering a qeustion, a predicate operation will end in a question mark. (This would be very familiar to users of the Ruby language and its use of predicate methods.)

Let's consider a few of these. We have `L?`` (less than), `G?`` (greater than), and `==?` (equal to). These predicate operations will operate on FIX values. So here's an example:</p>

```zil
<SET NUM 10>

<==? .NUM 10>
<L? .NUM 20>
<G? .NUM 50>
```

You can also test for if a value is specifically zero:

```zil
<0? .NUM>
```

Again, all predicates return a `true` value or a `false` value. As I indicated earlier, ZIL has an uncomplicated view of truth. Anything that is not zero is true. Two special tokens are used to mean `true` and `false` in a ZIL context: `T` and `<>` (an open followed immediately by closed angle bracket).

## Operations with Predicates

There are other operations we can perform. Consider this one:

```zil
<EQUAL? .NUM 10 20 30>
```

The `EQUAL?` predicate operation takes from two to four arguments and determines whether the first argument is equal to any of the other arguments. So the above expression checks whether or not the LOCAL ATOM called `NUM` was equal to 10, 20 or 30.

Now let's consier a slightly more complicated example:

```zil
<AND <G? .NUM 5> <L? .NUM 20>>
```
Two or more simple predicates can be combined together using the `AND` operation. In such a case, all of the predicates must be true for the entire predicate to be true. `AND` takes any number of expressions and evaluates them from left to right, returning `true` only if *all* of the expressions are true. So the above expression returns `true` if the value of the LOCAL ATOM called `NUM` is *both* greater than 5 and less than 20.

Incidentally, what this shows you is that it's possible to nest expressions. You can break out the above expression like this:

```zil
<AND
  <G? .NUM 5>
  <L? .NUM 20>
>
```

In general, all FORMs within ZIL are evaluated from left to right, top to bottom.

Let's take another example.

```zil
<OR <L? .NUM 20> <G? .NUM 5>
```

Two or more simple predicates can be combined using the `OR` operation. In that case, the entire predicate is true if any of the parts are true. `OR` is similar to `AND` in that takes any number of expressions and evaluates them from left to right. However, `OR` returns `true` if *any* of the expressions is true. So what the above logic will do is return `true` if the value of the LOCAL ATOM called `NUM` is *either* less than 20 *or* greater than 5.

What this is hopefully doing is giving you some context for how ZIL is structured. I think we're at a good point to take some of this to the next level.

To get out of the REPL, you can type the following:

```
<QUIT>
```

That will exit the ZILF interactive mode.

## Compiling ZIL Source

Create a file called **learning.zil**.

Now let's take what we were doing in the REPL and put it into this script. However, we can't just put those forms in place as we have been. Instead we need a routine. A routine is the most common aspect of ZIL code in that routines are essentially how everything works. There will be built-in routines and there will be routines that you construct yourself. Each ROUTINE has a name, which is a GLOBAL ATOM. In fact, `ROUTINE` itself is an ATOM that indicates a particular kind of FORM.

A ROUTINE is defined as follows:

```
<ROUTINE ROUTINE-NAME (argument list)
  < expressions >
>
```

Here 'name' is a legal ATOM name and 'expression' is any legal ZIL expression.

The first thing the interpreter does is to call a routine that is identified by the ATOM `GO`. You have to provide this routine.

```zil
<ROUTINE GO ()
>
```

Now let's add one of our previous forms with its expression:

```zil
<ROUTINE GO ()
  <SET A 10>
>
```

However, you'll find that doesn't work. In fact, you can't even compile. The problem here is that `A` is not defined in a way that the routine can used it. What you have to do is this:

```zil
<ROUTINE GO ("AUX" A)
  <SET A 10>
>
```

The notation "AUX" in the argument list means that the argument provided is an "auxiliary argument." This means it will be used within the routine but is not passed to the routine by whatever routine calls this one. This is essentially how you provide for a local variable in a routine.

However, this also fails. Entry point routines, which `GO` is, cannot have local variables. So what we actually want is another routine that will be called from our `GO` entry point routine. Let's set up the code like this:

```zil
<ROUTINE GO ()
  <INIT>
>

<ROUTINE INIT ("AUX" A)
  <SET A 10>
>
```

Every routine in a game is activated by being called by some other routine. When a routine is called, each of the expressions is evaluated in turn and the result of the last evaluation is the value of the call to the routine.
