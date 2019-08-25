"Cloak of Darkness"

<CONSTANT GAME-BANNER
"Cloak of Darkness|
A basic IF demonstration.|
Original game by Roger Firth|
ZIL conversion by Jesse McGrew, Jayson Smith, and Josh Lawrence|
Tutorial version by Jeff Nyman.">

<INSERT-FILE "parser">

<ROUTINE GO ()
  <INIT>
  <MAIN-LOOP>
>

<ROUTINE INIT ()
  <CRLF> <CRLF>
  <TELL "Hurrying through the rainswept November night, you're glad to see the bright lights of the Opera House. It's surprising that there aren't more people about but, hey, what do you expect in a cheap demo game...?" CR CR>
  <V-VERSION> <CRLF>
  <SETG HERE ,FOYER>
  <MOVE ,PLAYER ,HERE>
  <V-LOOK>
>

<ROOM FOYER
  (IN ROOMS)
  (DESC "Foyer of the Opera House")
  (LDESC "You are standing in a spacious hall, splendidly decorated in red and gold, with glittering chandeliers overhead. The entrance from the street is to the north, and there are doorways south and west.")
  (SOUTH TO BAR)
  (WEST TO CLOAKROOM)
  (NORTH SORRY "You've only just arrived, and besides, the weather outside seems to be getting worse.")
  (FLAGS LIGHTBIT)
>

<ROOM BAR
  (IN ROOMS)
  (DESC "Foyer Bar")
  (LDESC "The bar, much rougher than you'd have guessed after the opulence of the foyer to the north, is completely empty.")
  (NORTH TO FOYER)
  (ACTION BAR-R)
>

<ROOM CLOAKROOM
  (IN ROOMS)
  (DESC "Cloakroom")
  (LDESC "The walls of this small room were clearly once lined with hooks, though now only one remains. The exit is a door to the east.")
  (EAST TO FOYER)
  (FLAGS LIGHTBIT)
>

<OBJECT CLOAK
  (IN PLAYER)
  (DESC "cloak")
  (SYNONYM CLOAK)
  (ADJECTIVE DARK)
  (FLAGS TAKEBIT WEARBIT WORNBIT)
  (ACTION CLOAK-R)
>

<OBJECT HOOK
  (IN CLOAKROOM)
  (DESC "small brass hook")
  (FDESC "A small brass hook is on the wall.")
  (SYNONYM HOOK PEG)
  (ADJECTIVE SMALL BRASS)
  (FLAGS CONTBIT SURFACEBIT)
>

<ROUTINE CLOAK-R ()
  <COND (<VERB? EXAMINE> <TELL "The cloak is unnaturally dark." CR>)>
>

<ROUTINE BAR-R (RARG)
  <COND
    (<==? .RARG ,M-ENTER>
      <COND (<FSET? ,CLOAK ,WORNBIT> <FCLEAR ,BAR ,LIGHTBIT>)
      (ELSE <FSET ,BAR ,LIGHTBIT>)
      >)

    (<==? .RARG ,M-BEG>
      <COND (<AND <NOT <FSET? ,BAR ,LIGHTBIT>>
        <NOT <GAME-VERB?>>
        <NOT <VERB? LOOK>>
        <NOT <AND <VERB? WALK> <==? ,PRSO ,P?NORTH>>>
        <TELL "You grope around clumsily in the dark. Better be careful." CR>>)
      >)
  >
>
