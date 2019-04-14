
 
;"Magrathea for
 	The Restaurant at the End of the Universe
     (c) Copyright 1988 Infocom, Inc.  All Rights Reserved."

;"The rooms for Magrathea (Act 1)"

<ROOM HATCHWAY
      (LOC ROOMS)
      (DESC "Hatchway")
      (DOWN TO RAMP IF HATCH IS OPEN)
      (OUT TO RAMP IF HATCH IS OPEN)
      (SOUTH TO RAMP IF HATCH IS OPEN)
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL STAIRS HEART-OF-GOLD HATCH)
      ;(ACTION HATCHWAY-F)>

<OBJECT HATCH
	(LOC LOCAL-GLOBALS)
	(DESC "hatch")
	(ADJECTIVE DOOR) ;"for debugging parser"
	(SYNONYM HATCH ;HATCHWAY DOOR)
	(FLAGS DOORBIT OPENBIT)
	(ACTION HATCH-F)>

<VOC "NORTH" NOUN>
<VOC "SOUTH" NOUN>
<VOC "FROB" ADJ>  ;"for debugging parser"
<VOC "HAND" ADJ>

<ROUTINE HATCH-F ()
	 <COND (<AND <NOT <EQUAL? ,HERE ,HATCHWAY ,RAMP>>
		     <VERB? OPEN CLOSE EXAMINE RUB>>
		<NOT-HERE ,HATCH>)
	       ;(<AND <VERB? OPEN THROUGH>
		     <NOT ,LANDED>>
		<TELL
"Loud sirens blare, fantastically bright red lights flash from all sides, and
a soft female voice mentions that opening this hatch in space will evacuate
the air from the ship." CR>)
	       (<AND <VERB? OPEN THROUGH>
		     <NOT <FSET? ,HATCH ,OPENBIT>>>
		<TELL "The hatch appears to be jammed shut." CR>)>>

<ROOM RAMP
      	(LOC ROOMS)
	(DESC "On the Ramp")
	(FDESC 
"You are on the ramp leading from the starship Heart of Gold down to the
surface of the legendary lost planet of Magrathea, which isn't.  Lost,
that is.  It isn't lost because if it were, you wouldn't be here, but
you are, so it isn't.  If the logic of all that is too much for you,
just go down to the surface or up to the hatchway.  Go anywhere else and
you'll just get into awful difficulties.  Not that you'll take any
notice, of course; just don't say you weren't warned.")
	(NORTH TO HATCHWAY IF HATCH IS OPEN)
	(UP TO HATCHWAY IF HATCH IS OPEN)
	(SOUTH TO BLIGHTED-GROUND)
	(WEST SORRY "You bang you head against the ship's side.")
	(EAST PER FALL-OFF-RAMP)
	(NE SORRY "You bang you head against the ship's side.")
	(NW SORRY "You bang you head against the ship's side.")
	(SE PER FALL-OFF-RAMP)
	(SW PER FALL-OFF-RAMP)
	(DOWN TO BLIGHTED-GROUND)
	(GLOBAL HATCH)
	(FLAGS RLANDBIT ONBIT ;COLDBIT)>
;"If COLDBIT is set Player dies of cold after 8 moves unless has dressing
gown on."

<ROUTINE FALL-OFF-RAMP ()
	<TELL "You fall off the edge of the ramp onto the surface of
Magrathea.It's not a long way down and the ground breaks your fall, but
nevertheless you die.">
	 <COND (<L? ,MOVES 10>
	 <TELL "  This is something which is going to happen to you
quite a lot, so you might as well get used to it.">)
	 (<TELL "  You might not think it's very fair, but nobody said the Galaxy was a very fair place anyway.">)>
	 <JIGS-UP>
	 <RFALSE>>


<ROOM BLIGHTED-GROUND
	(LOC ROOMS)
	(DESC "Blighted Ground")
	(LDESC
"The surface of Magrathea is barren and inhospitable: a cold, constant
wind, a sifting of dust, no sign of life or movement.  In short, it is not
unlike a Chinese restaurant after 11.00 at night when they all want to go 
home.  The only difference is that there isn't a little silent gang of
waiters staring sullenly at the back of your neck.  The ramp lies upwards to
the north; to the south-east, there's an unhealthy-looking crater.")
	(NORTH TO RAMP)
	(SOUTH PER WANDER-AROUND)
	(WEST PER WANDER-AROUND)
	(EAST PER WANDER-AROUND)
	(NE PER WANDER-AROUND)
	;(SE TO RIDGE1)
	(NW PER WANDER-AROUND)
	(SW PER WANDER-AROUND)
	(FLAGS ONLANDBIT ONBIT ;COLDBIT ;NOAIRBIT)>

<ROUTINE WANDER-AROUND ()
	<TELL 
"You wander gloomily around for a while, ruining your shoes, becoming
thoroughly depressed, and ending up where you started." CR>
	<RFALSE>>

<ROOM LIP1
	(LOC ROOMS)
	(DESC "Crater Lip")
	(FDESC "The dusty ground rises here before falling away into a
crater.  The crater seems rather new, as if it had been created by the
impact of something huge and confused, travelling downwards at high
velocity.  It is as if a sperm whale had inexplicably materialized
several miles above the surface of Magrathea and immediately plunged
downwards, reaching terminal velocity almost immediately, terminal
incomprehension soon afterwards, and, finally, terminal impact just as
it was wondering whether it was going to have a nice day.  This
impression is heightened by the shards of whalebone and meat you can see
glistening here and there around the crater.

The crater continues south-west and south-east, and the blighted ground
lies to the north-west.")
	(LDESC
"You are on the rim of a great crater which continues to the south-west
and south-east, while the blighted ground lies north-west")
	(WEST PER SLOPE-SCRAMBLE)
	(EAST PER SLOPE-SCRAMBLE)
	(NORTH PER SLOPE-SCRAMBLE)
	(SOUTH PER DEATH-BY-BLUBBER)
	(NW TO BLIGHTED-GROUND)
	(NE PER SLOPE-SCRAMBLE)
	(SW TO LIP4)
	(SE TO LIP2)
	(FLAGS ONLANDBIT ONBIT)
	(GLOBAL WHALE-CRATER)>

<ROUTINE DEATH-BY-BLUBBER ()
	<TELL
"You fall into the new-ish, nasty-ish crater, where the blubber and blood
liberally spattered around break your fall. Unfortunately, however, on
becoming aware of your surroundings, you die of disgust." CR>
	<JIGS-UP>
	<RFALSE>>

<ROUTINE SLOPE-SCRAMBLE ()
	<TELL "You plunge recklessly over the edge of the " D ,HERE ",
ruining your shoes in your desperate scrabble for a foothold.
Fortunately for you, you regain your footing and scramble breathlessly
back to level ground again." CR>
	<RFALSE>>

<ROOM	LIP2
	(LOC ROOMS)
	(LDESC  "The rim of the whale crater continues northwest and
southwest. The scene of the whale's final disiluusionment lies below
you, but there's no way down")
	(DESC "Crater Lip")
	(WEST PER DEATH-BY-BLUBBER)
	(EAST PER SLOPE-SCRAMBLE)
	(NORTH PER SLOPE-SCRAMBLE)
	(SOUTH PER SLOPE-SCRAMBLE)
	(NW TO LIP1)
	(NE PER WANDER-AROUND)
	(SW TO LIP3)
	(SE PER SLOPE-SCRAMBLE)
	(FLAGS ONLANDBIT ONBIT)
	(GLOBAL WHALE-CRATER)>

<ROOM	LIP3
	(LOC ROOMS)
	(DESC "Crater Lip")
	(LDESC "The crater lip continues north-east and north-west.
Below you is a build-your-own-dead-whale kit (glue not included).
There's no way down.")
	(NORTH PER DEATH-BY-BLUBBER)
	(NE TO LIP2)
	(EAST PER SLOPE-SCRAMBLE)
	(SE PER SLOPE-SCRAMBLE)
	(SOUTH PER SLOPE-SCRAMBLE)
	(SW PER SLOPE-SCRAMBLE)
	(WEST PER SLOPE-SCRAMBLE)
	(NW TO LIP4)
	(FLAGS ONLANDBIT ONBIT)
	(GLOBAL WHALE-CRATER)>


<ROOM	LIP4
	(LOC ROOMS)
	(DESC "Crater Lip")
	(FDESC
"The crater lip continues northeast and southeast here, and below you is
a ledge.  If you fell from here to the ledge you would probably
break and ankle and nobody would hear you screaming and you
would die from pain and exposure.  On the other hand, if you
climbed down carefully, you'd have no trouble.  So what are you
making all the fuss about?")
 	(LDESC  "The crater lip continues northeat and southeast here,
and below you is a ledge.")
	(NORTH PER SLOPE-SCRAMBLE)
	(NE TO LIP1)
	(EAST TO LEDGE)
	(DOWN TO LEDGE)
	(SE TO LIP3)
	(SOUTH PER SLOPE-SCRAMBLE)
	(SW PER SLOPE-SCRAMBLE)
	(WEST PER SLOPE-SCRAMBLE)
	(NW PER SLOPE-SCRAMBLE)
	(FLAGS ONBIT ONLANDBIT)
	(GLOBAL WHALE-CRATER)>


<ROOM	LEDGE
	(LOC ROOMS)
	(DESC "Ledge")
	(FDESC "This ledge lies halfway between the crater lip and the
floor of the whale crater itself. It doesn't seem quite like any ledge
you've encountered before, perhaps because of the pillars on either side
of you and the rather nice wall - marble, perhaps, or ivory? - between
you and the steep but survivable slope down to the crater floor.")
	(LDESC
"This ledge lies halfway between the crater lip and the floor of the whale
crater itself.")
	(NORTH PER DEATH-BY-BLUBBER)
	(NE PER DEATH-BY-BLUBBER)
	(EAST PER DOWN-TO-CRATER)
	(SE PER DEATH-BY-BLUBBER)
	(SOUTH PER DEATH-BY-BLUBBER)
	(SW SORRY "You bang your head on the rock face.")
	;(WEST PER UP-TO-LIP)
	(NW SORRY "You bang your head on the rock face.")
	(FLAGS ONBIT ONLANDBIT)
	(GLOBAL WHALE-CRATER)>

<ROUTINE DOWN-TO-CRATER ()
	<TELL "You hop over the teeth and scramble down to the crater floor">
	<MOVE ,WINNER  ,WHALE-CRATER>>

<OBJECT	WHALE-CRATER-BOX
	(LOC LOCAL-GLOBALS)
	(FLAGS CONTBIT TRANSBIT NDESCBIT)>
	
<ROOM	WHALE-CRATER
	(LOC ROOMS)
	(DESC "Crater")
	(FDESC
"The floor of this deeply crufty crater is splattered with all kinds of disgusting stuff.  Film at eleven.")
	(LDESC "This is the whale crater, liberally supplied with whale.")
	(FLAGS ONLANDBIT ONBIT)>