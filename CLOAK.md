# Cloak of Darkness

## Getting Started

Let's start by creating a basic template for a game so we can get started:

```
"Cloak of Darkness"

<CONSTANT GAME-BANNER
"Cloak of Darkness|
A basic IF demonstration.|
Original game by Roger Firth|
ZIL conversion by Jesse McGrew, Jayson Smith, and Josh Lawrence|
Tutorial version by Jeff Nyman.">

<INSERT-FILE "parser">
```

All of this is covered in the [tutorial](https://github.com/jeffnyman/zil-retro/blob/master/TUTORIAL.md). In order for this to compile at all, you will need a `GO` routine. We know how to create that from the tutorial as well but let's use our exploration of *Cloak of Darkess* to build up some understanding.

## The Game Loop

According to the *ZIL Course* document:

> "The flexibility and complexity allowed in INTERLOGIC games are almost wholly due to the parser/main loop combination."

It continues:

> "It is best to think of the parser as a black box with from one to three outputs: an action to be performed, a direct object, and an indirect object. Each of the three corresponds to a GLOBAL ATOM: PRSA, PRSO, and PRSI, respectively."

The main loop starts with a call to the parser. Ultimately a command is received from the player and that command is run through the parser. If there is a "parser failure", this means that the parser was not able to break the command into the PRSA, PRSO, or PRSI. Thus nothing further happens and the loop is restarted.

If the parser succeeds in "understanding" the command, it will pass the "parts of speech" (PRSA, PRSO, PRSI) to the rest of the program. What this means is that the three ATOMs are set (using an operation called `SETG`). The game gets to decide which object will handle the command. What this means is that a number of ROUTINE objects will be called in turn to determine the result of the player's intended action.

According to the *ZIL Course*:

> "In ZIL, we say that a ROUTINE ’handled’ the player’s action if it finishes all of the processing required for that action. Each ROUTINE decides whether or not it considers the action ’handled’, and its decision is final. A ROUTINE ’handles’ an action simply by returning a ’non-false’ (i.e. anything other than a ’false’)."

By convention, the object in PRSI gets the first attempt at handling the command. This is assuming there is a PRSI, since a command does not have to have one. According to *Learning ZIL*:

> "What this means, is that if PRSI has an associated object action routine, that action routine tries to handle the input. If it does so, the current turn is considered to be complete."

However, if there is no PRSI or it does not contain such an action routine, then the object held by PRSO is given the next shot at handling. If the PRSO also doesn’t handle the input (because it has no routine to do so), the task falls to the routine associated with the verb.

The PRSO and PRSI routines can give very specific responses to the input. Whereas the routine associated with the verb is generally considered the "default response" and is the least interesting and/or most generic.

*Learning ZIL* gives a good example:

```
>HIT THE OAK CHEST WITH THE CROWBAR
The crowbar bends! It appears to be made of rubber, not iron!
```

Here the "oak chest" is the PRSO and the "crowbar" is the PRSI. The above output was handled by the action routine on the PRSI.

```
>HIT THE OAK CHEST WITH THE CROWBAR
The sound of the impact reverberates inside the chest.
```

This output was handled by the action routine on the PRSO.

```
>HIT THE OAK CHEST WITH THE CROWBAR
Hitting the oak chest accomplishes nothing.
```

Here neither the PRSI nor PRSO provided an action routine and so action handling fell to the object in the PRSA, which would be "hit", and that provided a default response. Behind the scenes the default action handler for HIT might be this:

```zil
<TELL "Hitting the " D .OBJ " accomplishes nothing." CR>
```

So you can see that if HIT for a specific OBJECT wants to do something different, then the OBJECT itself must supply a ROUTINE to ’handle’ the HIT action. Any object can provide such a routine by having an ACTION property on it.

As stated, actions don’t have to have a PRSI. As an example, "take oak chest" only has a PRSA and a PRSO. Actions also don’t have to have a PRSO. As an example, "inventory" or "jump" or "scream" all have a PRSA and nothing else. If there is no PRSI or PRSO, the value of it is set to false. There must always be a PRSA or there will be a parser failure.

## Routines

According to to the *ZIL Course* document:

> "ROUTINEs are user-constructed subroutines which are the backbone of the INTERLOGIC games."

According to the *Learning ZIL* document:

> "A routine is the most common item that makes up ZIL code."

The schematic of a routine is:

```
<ROUTINE ROUTINE - NAME ( argument - list )
  <expressions of the routine >>
```

Each ROUTINE has a "NAME", which, in the context of MDL and ZIL, is a GLOBAL ATOM. This means the routine can be referenced by any part of your program. In fact, it's this very ATOM that the interpreter will be looking for. So let's put that in our source:

```zil
<ROUTINE GO ()>
```

The argument list appears within parentheses after the routine name. Arguments are variables used only within the specific routine. In many cases, a routine will have no arguments; in that case, the argument list must still appear, but as an empty set of parentheses.

When a game first starts, the first thing the interpreter does is to call a routine called `GO`. You can put a lot of expressions in `GO` if you want but the last thing that `GO` should do is call the routine called `MAIN-LOOP`. `MAIN-LOOP` is what starts the processing logic. Every routine in the game is directly or indirectly called by `MAIN-LOOP`. As *Learning ZIL* puts it:

> "MAIN-LOOP is basically a giant REPEAT which loops once for each turn of the game."

So let's add that to our routine:

```zil
<ROUTINE GO ()
  <MAIN-LOOP>
>
```

Let's consider a schematic of this main loop:

```
<ROUTINE MAIN - LOOP ( argument-list )
  <REPEAT ()
    <PARSER>
    <COND (<did -the - parser - fail ?>
      <AGAIN >)>
    <PERFORM ,PRSA ,PRSO ,PRSI >
    <COND (<did -this -input -cause -time -to - pass ?>
      <call -room - function -with -M-END>
      <CLOCKER>)>>>
```

Consistent with the above details, the parser is called first so the command from the player can be inspected.

If there is a parser failure at this point, some failure message will be printed, and the turn is considered complete. The loop starts over again. That's what AGAIN is basically doing; it sends processing to the top of the REPEAT.

If the parser succeeds at this point, it identifies the PRSA, PRSO, and PRSI, again as described before. Then a routine called `PERFORM` is called. This routine uses all of that information to allow the action routines of PRSI and/or PRSO a chance to handle the input. If not, the verb default will handle the input. MAIN-LOOP then causes any events to occur via M-END and CLOCKER but that only happens if the action taken was one that was "in world" which means it caused time to pass.

The MAIN-LOOP runs over and over until something tells the interpreter to quit the game. A common way that would happen is with the `V-QUIT` expression which calls the `<QUIT>` instruction. This corresponds to the player typing "quit" in the game.

Every routine in a game is activated by being called by some other routine. A routine calls another routine by putting the name of the called routine at the appropriate place, inside brackets.

According to the *ZIL Course*:

> "When a ROUTINE is called, each of the expressions is evaluated in turn and the result of the last evaluation is the value of the call to the ROUTINE."

So let's add our own routine and have our `GO` routine call it:

```zil
<ROUTINE GO ()
  <INIT>
  <MAIN-LOOP>
>

<ROUTINE INIT ()>
```

If you try to compile this, you'll get an interesting error message:

```
ROUTINE requires 3 or more args
```

This is referring to the `INIT` routine we just created. I just talked about arguments earlier as part of the argument list so you might think that what's being asked for are three arguments in the parentheses for this routine. However, that's not the case. What is needed here is at least one function call. To see this, add the following:

```zil
<ROUTINE INIT ()
  <V-VERSION>
>
```

This will now compile. The trick here is that you have to understand the form `ROUTINE` is the name of a function. But isn't `INIT` the name of our function? Yes, but in a Lisp-like language, the keyword to define a function is "ROUTINE" and it takes three arguments. The first of those is the name (in our case, `INIT`), the second of those is the parameter list, and then the third is at least one function call (which for us is `V-VERSION`).

## The Starting Room

We saw in the tutorial the idea of defining an object that was the location where the player could begin. Let's put that in place for our game, which starts in a foyer.

```zil
<ROOM FOYER
  (IN ROOMS)
  (DESC "Foyer of the Opera House")
  (FLAGS LIGHTBIT)
>
```

I showed you something very similar in the tutorial, one difference here being that instead of using `OBJECT`, I'm using `ROOM`. This is a concept provided by the ZILF library. I'm also making sure the room is lit so the player will be able to see in it. In fact, we'll have to do what we did in the initial tutorial by making sure to put the player in that room at the start. So change your `INIT` routine as such:

```zil
<ROUTINE INIT ()
  <V-VERSION>
  <SETG HERE ,FOYER>
  <MOVE ,PLAYER ,HERE>
  <V-LOOK>
>
```

This will place the player in the foyer and perform an initial look action.

If you try this out, you'll find that your output in the game looks a little messy, with everything sort of jumbled together. The game also just dumps you in the foyer without providing any context for the narrative. So let's change the `INIT` routine to look like this:

```zil
<ROUTINE INIT ()
  <CRLF> <CRLF>
  <TELL "Hurrying through the rainswept November night, you're glad to see the bright lights of the Opera House. It's surprising that there aren't more people about but, hey, what do you expect in a cheap demo game...?" CR CR>
  <V-VERSION> <CRLF>
  <SETG HERE ,FOYER>
  <MOVE ,PLAYER ,HERE>
  <V-LOOK>
>
```

The `TELL` atom refers to a kind of routine that's called a macro. This particular macro deals with printing everything the user sees as output. In its simplest use, as in the above example, `TELL` does nothing more than take the string provided as an argument and prints it. The `CR` after the string means "carriage return." But we've already done `CRLF` ("carriage return line feed"). What's the difference? Apparently there isn't one.

Our room is still a little boring in that all we have is the description. Let's provide a longer description to the player. Change the foyer object to look like this:

```zil
<ROOM FOYER
  (IN ROOMS)
  (DESC "Foyer of the Opera House")
  (LDESC "You are standing in a spacious hall, splendidly decorated in red and gold, with glittering chandeliers overhead. The entrance from the street is to the north, and there are doorways south and west.")
  (FLAGS LIGHTBIT)
>
```

The `LDESC` atom lets you put in place the unchanging description of a room.
