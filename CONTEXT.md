# Context: What Is ZILF?

ZILF (apparently an acronym for *ZIL implementation of the Future*) is an interpreter and compiler for the ZIL language. It can produce Z-Machine assembly code for use with another program called ZAPF (an acronym for the *Z-machine Assembler Program of the Future*). In a bit of a naming oddity note that in both cases the "future" means basically "now."

But speaking of the future, let's turn back a bit to the past. Let's consider some history.

The ZIL that keeps coming up is the language Infocom used to write their interactive fiction titles. ZIL is often stated to be an acronym for Zork Implementation Language, although you see it referred to as other things in historical documents, one of which I'll quote from soon. ZIL was developed to fit the game Zork onto the space- and memory-constrained home computers of the early late 1970s and early 1980s.

From a document just titled *ZIL* authored by Marc Blank in 1982, we essentially get the terminology of what would become the Infocom context:

> The Z System is composed of the various modules which are used to create INTERLOGIC games. At the highest level is Z Implementation Language (ZIL), which is an interpreted language running under MDL. Since ZIL is a MDL subsystem, all of the debugging features of MDL itself can be used in the creation and debugging of INTERLOGIC games. ZIL code is run through the ZIL Compiler (ZILCH) producing Z Assembly Language code which is, in turn, assembled by the Z Assembler Program (ZAP) into machine-independent Z-codes. These Z-codes can be run on any target machine which sports a Z-machine emulator (ZIP).

The first version of Zork was [MDL Zork](https://github.com/historicalsource/zork-mdl). Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling wrote this game at MIT around 1977 to 1979.

Wait, MDL? What happened to ZIL? MDL, originally called "Muddle" and later an acronym for MIT Design Language, was a Lisp-like functional language created at MIT. Some references on it (all PDF files):

* [The MDL Programming Language](http://ifarchive.org/if-archive/programming/mdl/manuals/MDL_Programming_Language.pdf) Stu Galley and Greg Pfister (1979).
* [The MDL Programming Environment](http://ifarchive.org/if-archive/programming/mdl/manuals/MDL_Programming_Environment.pdf) David Lebling (May 1980).
* [The MDL Programming Language Primer](http://publications.csail.mit.edu/lcs/pubs/pdf/MIT-LCS-TR-292.pdf) Michael Dornbrook and Marc Blank, Marc (1980)

MDL ran on the PDP-10. So the first incarnation of Zork ran on this kind of system.

Zork was [ported to Fortran](https://github.com/historicalsource/zork-fortran) by Bob Supnik in 1980 and then was [ported to C](http://ifarchive.org/if-archive/games/source/dungeon-2.5.6.tar.gz). Note that the latter link is a distribution of the actual soruce. These versions, generally known as "mainframe Zork" (or "Dungeon") circulated among the users groups at DEC. This was a side fork of the Zork history.

The group responsible for MDL Zork eventually founded a company called Infocom who decided to use Zork as a way to gain capital. This might providing Zork as a sellable product to the home computer market. However, MDL programs couldn't possibly run on an Apple II, Commodore 64 or a TRS-80.

The long-story-made-short version is that Infocom created a new language called ZIL, which was derived from MDL. They then ported Zork from MDL to ZIL. This is why the language was probably eventually called the "Zork Implementation Language." They couldn't use the MDL compiler any more because they weren't using MDL so they had to write a new compiler. This compiler, called ZILCH, would compile the ZIL source into a binary format.

The binary format was called z-code. This was a program for an imaginary computer called the Z-Machine. Nobody at Infocom ever intended to build an actual Z-Machine. Instead it would remain forever virtual. What they did do, however, was write programs that could emulate this virtual Z-Machine. These programs were called ZIPs, for Z-language Implementation Program. These were small enough to run on 8-bit and 16-bit home computers. Infocom would thus put the z-code and a ZIP on some distributable medium (usually floppy disk or cassette tape) and thus they were able to sell games to the rapidly growing home computer market.

Andrew Plotkin (in ["What is ZIL anyway?"](http://blog.zarfhome.com/2019/04/what-is-zil-anyway.html)) asks us to consider one bit of code in each implementation:

* [Villain Strength](https://github.com/historicalsource/zork-mdl/blob/master/melee.mud#L149) (MDL)
* [Villain Strength](https://github.com/historicalsource/zork1/blob/master/1actions.zil#L3383) (ZIL)

The languages are quite different. But What matters for us is the ZIL version.

Which brings us to ZILF.

ZILF is an interpreter and compiler for ZIL. So in that sense it acts a bit like ZILCH. ZILF can produce Z-machine assembler code, which can be use with ZAPF.

ZILF takes ZIL source code that you write and compiles it into Z-Machine assembly code. That assembly code is then passed to ZAPF, which makes a final z-code story file. Here "z-code" refers to the byte code and data file format used by the Z-Machine.

ZAPF acts like ZAP, which was Infocom's assembler.

So for Infocom, code was written in ZIL, which was derived from MDL. That was then compiled by ZILCH to assembly code that was passed to ZAP. ZAP would then make the ZIP. Here's a rough schematic of how ZILF recreates that for the "future" (i.e., "now"):

```
  ZIL --> ZILCH --> ZAP --> ZIP
    ZILF ------> ZAPF
```

<p>In the ZILF ecosystem, there are actually two stages and thus two tools: `zilf.exe` and `zapf.exe`. Compiling a game with ZILF will generate ZAP assembly code. You can then compile that assembly code to get a playable game. For example, let's say you create a file called **cloak.zil**, which contains the source code for your game. You would compile that with ZILF as such:

```
zilf.exe cloak.zil
```

ZILF produces some assembly files as part of its operation. You'll get the following:

* cloak.zap
* cloak_data.zap
* cloak_str.zap
* cloak_freq.zap

The `cloak.zap` file is the main file and that's the one that has all of the routines that your game is made up of. The `cloak_data.zap` contains things like constants, objects, and tables. That probably won't make much sense if you don't know what those are yet. The `cloak_str.zap` file contains all the strings (i.e., text) of your game. The file `cloak_freq.zap` refers to frequently used words or abbreviations.

To get a playable game, you compile with ZAPF as such:

```
zapf.exe cloak.zap
```

That will create a **cloak.z3** file which should be capable of being played in any Z-Machine interpreter.
