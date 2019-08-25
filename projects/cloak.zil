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
  (FLAGS LIGHTBIT)
>
