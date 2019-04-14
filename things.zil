"THINGS for MILLIWAYS
Copyright (C) 1988 Infocom, Inc.  All rights reserved."

<ROUTINE RANDOM-PSEUDO ()
 <COND (<VERB? ASK-ABOUT ASK-CONTEXT-ABOUT LOOK-BEHIND LOOK-UNDER TELL-ABOUT>
	<RFALSE>)
       (<VERB? EXAMINE LOOK-INSIDE SEARCH>
	<NOTHING-SPECIAL>
	<RTRUE>)
       (T
	<WONT-HELP>
	;<TELL "You can't do anything useful with that." CR>)>>

<OBJECT SCREWDRIVER
	(LOC PLAYER)
	(DESC "flathead screwdriver")
	(SYNONYM SCREWDRIV TOOL TOOLS)
	(ADJECTIVE FLATHEAD PROPER)
	(FLAGS TAKEBIT ;TRYTAKEBIT TOOLBIT)
	(SIZE 3)
	;(GENERIC TWEEZERS)>

<OBJECT TOOTHBRUSH
	(LOC PLAYER)
	(OWNER PLAYER)
	(DESC "toothbrush")
	(ADJECTIVE TOOTH MY PROPER)
	(SYNONYM TOOTHBRUSH BRUSH TOOL TOOLS)
	(FLAGS TAKEBIT TRYTAKEBIT TOOLBIT)
	(SIZE 3)
	(ACTION TOOTHBRUSH-F)>

<ROUTINE TOOTHBRUSH-F ()
	 <COND (<AND <VERB? TAKE>
		     <NOT <FSET? ,TOOTHBRUSH ,TOUCHBIT>>>
		<MOVE ,TOOTHBRUSH ,PLAYER>
		<FSET ,TOOTHBRUSH ,TOUCHBIT>
		<FCLEAR ,TOOTHBRUSH ,TRYTAKEBIT>
		<TELL
"As you pick up the " D ,TOOTHBRUSH " a tree outside the window collapses.
There is no causal relationship between these two events.">
		;<COND (<FSET? ,PHONE ,TOUCHBIT>
		       <TWO-TREES>)>
		<CRLF>)>>

<OBJECT GOWN
	(LOC PLAYER)
	(OWNER PLAYER)
	(DESC "your gown")
	;(LDESC "Your gown is here.")
	(ADJECTIVE MY ;YOUR DRESSING TATTY FADED BATTERED)
	(SYNONYM GOWN POCKET ROBE LOOP)
        (FLAGS WORNBIT WEARBIT TAKEBIT CONTBIT ;NDESCBIT NARTICLEBIT SEARCHBIT)
	(SIZE 15)
	(CAPACITY 14)
	(ACTION GOWN-F)>

<ROUTINE GOWN-F ()
	 <COND (<AND <VERB? OPEN CLOSE>
		     <NOT <FSET? ,GOWN ,WORNBIT>>>
		<TELL
"It's hard to open or close the pocket unless you're wearing the gown." CR>)
	       (<VERB? EXAMINE>
		<TELL "The dressing gown is faded and battered, and is
clearly a garment which has seen better decades. It has a pocket which is ">
		<COND (<FSET? ,GOWN ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<COND ;(,GOWN-HUNG
		       <TELL ". It is hanging from a " D ,HOOK ".">)
		      (T
		       <TELL ", and a small loop at the back of the collar.">)>
		;<COND (,SLEEVE-TIED
		       <TELL " The sleeves are tied closed.">)>
		<CRLF>)
	       ;(<AND <VERB? TAKE>
		     <EQUAL? ,GOWN ,PRSO>
		     ,HEADACHE>
		<FCLEAR ,GOWN ,TRYTAKEBIT>
		<FCLEAR ,GOWN ,NDESCBIT>
		<MOVE ,GOWN ,PLAYER>
		<TELL
"Luckily, this is large enough for you to get hold of. You notice something
in the pocket." CR>)
	       ;(<AND <VERB? WEAR>
		     ,SLEEVE-TIED>
		<TELL "You'll have to untie the sleeve first." CR>)
	       ;(<VERB? TIE UNTIE>
		<PERFORM ,PRSA ,SLEEVES>
		<RTRUE>)>>

<OBJECT SLEEVES
	(LOC GLOBAL-OBJECTS)
	(DESC "sleeve")
	(SYNONYM SLEEVE)
	(ACTION SLEEVES-F)>

<ROUTINE SLEEVES-F ()
	 <COND (<NOT <VISIBLE? ,GOWN>>
		<NOT-HERE ,SLEEVES>)
	       (<VERB? ;WEAR TAKE>
		<PERFORM ,PRSA ,GOWN>
		<RTRUE>)
	       ;(<VERB? TIE CLOSE>
		<SETG PRSO ,GOWN>
		<COND (<IDROP>
		       <RTRUE>)
		      (,SLEEVE-TIED
		       <TELL "It is." CR>)
		      (T
		       <SETG SLEEVE-TIED T>
		       <TELL "The sleeves are now tied closed." CR>)>)
	       ;(<VERB? UNTIE OPEN>
		<COND (,SLEEVE-TIED
		       <SETG SLEEVE-TIED <>>
		       <TELL "Untied." CR>)
		      (T
		       <TELL "It isn't tied!" CR>)>)>>

<OBJECT THING
	(LOC GOWN)
	(DESC "thing your aunt gave you which you don't know what it is")
	(ADJECTIVE AUNT\'S)
	(SYNONYM THING GIFT)
	(FLAGS TAKEBIT CONTBIT SEARCHBIT OPENBIT)
	(SIZE 6)
	(CAPACITY 90)
	(ACTION THING-F)>

<ROUTINE THING-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"Apart from a label on the bottom saying \"Made in Ibiza\" it furnishes you
with no clue as to its purpose, if indeed it has one. You are surprised to see
it because you thought you'd thrown it away. Like most gifts from your aunt,"
,GET-RID CR>)
	       (<AND <VERB? DROP>
		     ;<NOT <EQUAL? ,HERE ,MAZE ,ACCESS-SPACE>>>
		<MOVE ,THING ,HERE>
		<TELL
"It falls to the ground with a light \"thunk.\" It doesn't do anything
else at all." CR>)
	       (<VERB? CLOSE>
		<TELL
"Come to think of it, you vaguely remember an instruction booklet with
directions for that. You never read it and lost it months ago." CR>)>>

<CONSTANT GET-RID " you've been trying to get rid of it for years.">

<ROUTINE I-THING ()
	 <QUEUE I-THING <+ 4 <RANDOM 4>>>
	 <COND (<OR ;<NOT <EQUAL? ,IDENTITY-FLAG ,ARTHUR>>
		    ;<AND <EQUAL? ,HERE ,ENGINE-ROOM>
			 <L? ,LOOK-COUNTER 3>>
		    ;<EQUAL? ,HERE ,DARK ,ACCESS-SPACE ,MAZE>
		    <VISIBLE? ,THING>
		    <HELD? ,THING>
		    ;<IN? ,FLEET ,HERE>>
		<RFALSE>)>
	 <COND (<PROB 40>
		<MOVE ,THING ,HERE>)
	       (<AND <FSET? ,GOWN ,WORNBIT>
		     <FSET? ,GOWN ,OPENBIT>
		     <PROB 65>>
		<MOVE ,THING ,GOWN>)
	       (T
		<MOVE ,THING ,PLAYER>)>
	 <RFALSE>>

<OBJECT GUIDE
	(LOC SATCHEL)
	(DESC "The Hitchhiker's Guide")
	(DESCFCN GUIDE-DESCFCN)
	(ADJECTIVE HITCHHIKER\'S SUB-ETHA)
	(SYNONYM COPY GUIDE)
	(SIZE 10)
	(FLAGS NARTICLEBIT TAKEBIT READBIT)
	(TEXT "Try: CONSULT GUIDE ABOUT (something).")
	(ACTION GUIDE-F)>

<ROUTINE GUIDE-DESCFCN ("OPTIONAL" X)
	 <TELL "There is a copy of " ,GUIDE-NAME " here." CR>>

<ROUTINE GUIDE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The Guide is a Mark II model. Its only resemblance to the Mark IV pictured
in the brochure in your game package is the large, friendly \"Don't Panic!\"
on its cover.|
|
The Guide is a Sub-Etha Relay. You can use it to tap information from a huge
and distant data bank by consulting the Guide about some item or subject." CR>)
	       (<AND <VERB? ASK-ABOUT>
		     <DOBJ? GUIDE>>
		<COND (<FSET? ,TOWEL ,WORNBIT>
		       <TELL ,WITH-TOWEL CR>
		       <RTRUE>)
		      ;(<IOBJ? ACCESS-SPACE>
		       <TELL
"Suddenly, agents of the " ,AGENCY " pop in using Sub-Etha belts, rough you up
a bit, tell you there's no such thing as the " ,AGENCY " and never to consult "
D ,GUIDE " about the " ,AGENCY " again; then they leave." CR>
		       <RTRUE>)>
		<TELL
"The Guide checks through its Sub-Etha-Net database and eventually comes
up with the following entry:" CR CR>
		<COND (<IOBJ? GUIDE>
		       <TELL
D ,GUIDE " is a wholly remarkable product." ,ALREADY-KNOW-THAT CR>)
		      (<IOBJ? HEART-OF-GOLD>
		       <TELL
"There is absolutely no such spaceship as " D ,HEART-OF-GOLD " and anything
you've ever read in this spot to the contrary was just a prank.|
   -- " ,AGENCY CR>)
		      (<IOBJ? SCC ;GALLEY>
		       <TELL
"The " ,SCC " incompetently produces a wide range of inefficient and unreliable
high-tech machinery. However, thanks to SCC's ruthless marketing division, this
junk accounts for over 95% of the high-tech machinery sold in the Galaxy.
(SCC's marketing division will be the first against the wall when the
revolution comes.)" CR>)
		      (<IOBJ? MARVIN>
		       <TELL
,GPP " are a misguided attempt by the " ,SCC " to make their machines behave
more like people. Among the more miserable failures: paranoid-depressive
robots and over-protective computers." CR>)
		      ;(<IOBJ? DARK>
		       <TELL
"A must for the serious hitchhiker, peril-sensitive sunglasses darken at the
first hint of danger, thus shielding the wearer from seeing anything alarming.
Recommended brand: Joo Janta." CR>)   
		      (<IOBJ? RAMP>
		       <TELL
"According to legend, Magrathea was a planet that amassed incredible wealth by
manufacturing other planets. The legends also mention it as the setting
of the very eagerly awaited second Infocom Hitchhiker's game." CR>) 
		      (<OR <IOBJ? ZAPHOD>
			   ;<AND <IOBJ? ME>
				<EQUAL? ,IDENTITY-FLAG ,ZAPHOD>>>
		       <TELL D ,ZAPHOD " is the current" ,PRESIDENT "." CR>) 
		      (<IOBJ? BABEL-FISH>
		       <TELL
"A mind-bogglingly improbable creature. A " D ,BABEL-FISH ", when placed in
one's ear, allows one to understand any language." CR>)
		      (<IOBJ? TOWEL>
		       <TELL
"A towel is the most useful thing (besides the Guide) a Galactic hitchhiker
can have. Its uses include travel, combat, communications, protection from the
elements, hand-drying and reassurance. Towels have great symbolic value, with
many associated points of honour. Never mock the towel of another, even if it
has little pink and blue flowers on it. Never do something to somebody else's
towel that you would not want them to do to yours. And, if you borrow the towel
of another, you MUST return it before leaving their world." CR>)
		      (<IOBJ? GARGLE-BLASTER>
		       <TELL
"The best drink in existence; somewhat like having your brains smashed out by
a slice of lemon wrapped around a large gold brick." CR>)
		      (<IOBJ? THIRD-PLANET ;MAZE>
		       <TELL "Mostly harmless." CR>)
		      (<FSET? ,PRSI ,TOOLBIT>
		       <TELL
"The editor responsible for entries under this heading has been out to lunch
for a couple of years but is expected back soon, at which point there will be
rapid updates. Until then, don't panic, unless your situation is really a life
or death one, in which case, sure, go ahead, panic." CR>)
		      ;(<IOBJ? TEA>
		       <TELL
"Sorry, that portion of our Sub-Etha database was accidentally deleted last
night during a wild office party. The lost data will be restored as soon as
we find someone who knows where the back-up tapes are kept, if indeed any
are kept at all." CR>)
		      (T
		       <TELL
"That is one of the Great Unanswered Questions. For a list of the others,
consult the Guide." CR>)>)>>

<CONSTANT GUIDE-NAME "The Hitchhiker's Guide to the Galaxy">

<CONSTANT ALREADY-KNOW-THAT 
" But then again you must already know that, since you bought one.">

<CONSTANT WITH-TOWEL "With a towel wrapped around your head!?!">

<CONSTANT AGENCY "Galactic Security Agency">

<CONSTANT GPP "Genuine People Personalities">

;<CONSTANT SPACE-TEXT
"If you hyperventilate and then empty your lungs, you will last about thirty
seconds in the vacuum of space. However, because space is so vastly hugely
mind-bogglingly big, getting picked up by another ship within those thirty
seconds is almost infinitely improbable.">

<OBJECT BABEL-FISH
	(LOC PLAYER)
	(DESC "babel fish")
	(ADJECTIVE BABEL)
	(SYNONYM FISH)
	(FLAGS TRYTAKEBIT WORNBIT)
	(ACTION BABEL-FISH-F)>

<ROUTINE BABEL-FISH-F ()
	 <COND (<VERB? TAKE REMOVE>
		<TELL
"That would be foolish. Having a " D ,BABEL-FISH " in your ear is terribly
useful." CR>)>>

<OBJECT TOWEL
	(LOC FORD)
	(DESC "towel")
        (SYNONYM TOWEL TOWELS)
	(FLAGS TAKEBIT TRYTAKEBIT)
	(SIZE 7)
	(CAPACITY 40)
	(ACTION TOWEL-F)>

<ROUTINE TOWEL-F ()
	 <COND (<AND <VERB? TAKE MOVE>
		     <DOBJ? TOWEL>
		     <FSET? ,TOWEL ,SURFACEBIT>>
		<FCLEAR ,TOWEL ,TRYTAKEBIT>
		<FCLEAR ,TOWEL ,SURFACEBIT>
		<ROB ,TOWEL ,HERE>
		<FCLEAR ,TOWEL ,CONTBIT>
		<FCLEAR ,TOWEL ,OPENBIT>
		<FCLEAR ,TOWEL ,NDESCBIT>
		<COND (<VERB? MOVE>
		       <TELL "Okay, it's no longer covering the drain." CR>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? PUT ;TIE>
		     <IOBJ? HEAD EYES>>
		<COND (<FSET? ,TOWEL ,WORNBIT>
		       <TELL "It already is." CR>)
		      (T
		       <TELL
"There's no need for that. It's not as if there's a Bugblatter Beast around,
or something." CR>)>)
	       (<VERB? EXAMINE>
		<COND ;(<FSET? ,TOWEL ,SURFACEBIT>
		       <PERFORM ,V?EXAMINE ,DRAIN>
		       <COND (<FIRST? ,TOWEL>
			      <RFALSE>)>
		       <RTRUE>)
		      (T
		       <TELL
"It's covered with little pink and blue flowers." CR>)>)
	       ;(<AND <VERB? LIE-DOWN>
		     <FSET? ,TOWEL ,SURFACEBIT>>
		<PERFORM ,V?STAND-BEFORE ,HOOK>
		<RTRUE>)>>

<OBJECT SATCHEL
	(LOC FORD)
	(OWNER FORD)
	(DESC "satchel")
	(DESCFCN SATCHEL-DESCFCN)
	(ADJECTIVE BATTERED LEATHER BULKY)
	(SYNONYM SATCHEL)
	(FLAGS CONTBIT SEARCHBIT TAKEBIT TRYTAKEBIT)
	(CAPACITY 30)
	(SIZE 20)
	(ACTION SATCHEL-F)>

<ROUTINE SATCHEL-DESCFCN ("OPTIONAL" X)
	 <TELL "There is a satchel here.">
	 <ITEM-ON-SATCHEL-DESCRIPTION>
	 <CRLF>
	 <RTRUE>>

<GLOBAL ITEM-ON-SATCHEL:OBJECT 0>
<ROUTINE ITEM-ON-SATCHEL-DESCRIPTION ()
	 <COND (,ITEM-ON-SATCHEL
		<TELL " Sitting on top of it is ">
		<TELL a ,ITEM-ON-SATCHEL>
		<TELL ".">)>>

<ROUTINE SATCHEL-F ()
	 <COND (<AND <VERB? OPEN>
		     ;<NOT <EQUAL? ,IDENTITY-FLAG ,FORD>>>
		<PRIVATE "Ford">)
	       (<AND <VERB? PUT>
		     <EQUAL? ,SATCHEL ,PRSI>>
		<COND (<HELD? ,SATCHEL>
		       <TELL "Put down the satchel first." CR>)
		      (,ITEM-ON-SATCHEL
		       <TELL "But">
		       <TELL the ,ITEM-ON-SATCHEL>
		       <TELL " is already on the satchel." CR>)
		      (T
		       <SETG ITEM-ON-SATCHEL ,PRSO>
		       <MOVE ,PRSO ,HERE>
		       <FSET ,PRSO ,NDESCBIT>
		       <FSET ,PRSO ,TRYTAKEBIT>
		       <TELL "Okay,">
		       <TELL the ,PRSO>
		       <TELL " is now sitting on the satchel." CR>)>)
	       (<VERB? EXAMINE>
		<TELL "The satchel, which is ">
		<COND (<FSET? ,SATCHEL ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL ", is fairly bulky.">
		<ITEM-ON-SATCHEL-DESCRIPTION>
		<CRLF>)
	       (<AND <VERB? TAKE>
		     <IN? ,SATCHEL ,FORD>>
		<TELL
"Ford says, \"Hey, Arthur, keep " D ,HANDS "s off my satchel!\"" CR>)>>

<ROUTINE PRIVATE (STRING)
	 <TELL
"You can't. It's not yours. It's " .STRING "'s and it's private." CR>>

<ROOM GARGLE-BLASTER
      (LOC GLOBAL-OBJECTS)
      (DESC "Pan-Galactic Gargle Blaster")
      (ADJECTIVE PAN-GALACTIC GARGLE)
      (SYNONYM BLASTER)>

<ROOM SCC
      (LOC GLOBAL-OBJECTS)
      (DESC "Sirius Cybernetics Corporation")
      (ADJECTIVE SIRIUS CYBERNETICS)
      (SYNONYM CORPORATION SCC)>

<OBJECT HEART-OF-GOLD
	(LOC LOCAL-GLOBALS)
	(DESC "the Heart of Gold")
	(ADJECTIVE SPACE INCREDIBLE NEW)
	(SYNONYM HEART GOLD SHIP SPACESHIP)
	(FLAGS NARTICLEBIT)
	;(ACTION HEART-OF-GOLD-F)>

<OBJECT GAME
	(LOC GLOBAL-OBJECTS)
	(DESC "MILLIWAYS")
	(SYNONYM GAME MILLIWAYS)
	(FLAGS NARTICLEBIT)
	(ACTION GAME-F)>

<ROUTINE GAME-F ()
 	 <COND (<VERB? EXAMINE FIND LAMP-ON PLAY READ THROUGH>
	        <SETG CLOCK-WAIT T>
	        <TELL "[You're playing it now!]" CR>)>>

<OBJECT DINNER
	(LOC PUB)
	(OWNER PLAYER)
	(DESC "your dinner")
	(ADJECTIVE COVERED MY)
	(SYNONYM DINNER FOOD ;ARRAY DISHES PLATE ;FISH)
	(FLAGS NARTICLEBIT TRYTAKEBIT)
	(SIZE 10)
	(DESCFCN DINNER-D)
	(ACTION DINNER-F)>

<ROUTINE DINNER-D (ARG "AUX" (L <LOC ,DINNER>))
 <COND (T ;<EQUAL? .L ,KITCHEN ,SIDEBOARD>
	<TELL "An appetizing aroma wafts from an array of covered dishes">
	;<COND (<==? .L ,KITCHEN>
	       <TELL " sitting about">)
	      (<==? .L ,SIDEBOARD>
	       <TELL " on the " 'SIDEBOARD>)>
	<TELL "." CR>)>>

<ROUTINE DINNER-F ("AUX" I (L <LOC ,DINNER>))
 <COND ;(<VERB? DRESS>
	<COND (<EQUAL? ,HERE <META-LOC ,DINNER-OUTFIT>>
	       <PERFORM ,V?WEAR ,DINNER-OUTFIT>
	       <RTRUE>)
	      (T
	       <NOT-HERE ,DINNER-OUTFIT>
	       <RTRUE>)>)
       (<VERB? EAT>
	<COND ;(<FSET? ,DINNER ,TRYTAKEBIT>	;<QUEUED? ,I-DINNER-SIT>
	       <TELL
"You look around and notice that no one else is eating yet." CR>)
	      (T <TELL "You take a bite and find it delicious." CR>)>)
       (<VERB? EXAMINE ;SMELL>
	<TELL
"A lovely assortment of fish, fowl, greens, and sweets fills the ">
	<COND ;(<EQUAL? .L ,KITCHEN ,SIDEBOARD>
	       <TELL "dishes." CR>)
	      (T <TELL "plate." CR>)>)
       ;(<VERB? TAKE LAMP-ON ;"start">
	<COND (<FSET? ,DINNER ,TRYTAKEBIT>
	       <COND (<==? .L ,KITCHEN>
		      <TELL "It's not ready yet." CR>)
		     (<==? .L ,SIDEBOARD>
		      <SET L <I-DINNER-SIT>>
		      <COND (<ZERO? .L>
			     <TELL
"You look around and notice that no one else is eating yet."
;"Not all the guests are ready yet." CR>
			     <RTRUE>)
			    (T <RETURN .L>)>)>)>)
       ;(<VERB? WAIT-FOR>
	<COND (<SET I <QUEUED? ,I-DINNER>>
	       <V-WAIT <- ,DINNER-TIME ,PRESENT-TIME> ;.I <> T>
	       <RTRUE>)>)
       ;(<VERB? WALK-TO>
	<COND (<EQUAL? ,HERE ,DINING-ROOM>
	       <PERFORM ,PRSA <META-LOC ,DINNER>>)
	      (T <PERFORM ,PRSA ,DINING-ROOM>)>
	<RTRUE>)>>

"For debugging parser:"

<OBJECT RED-FROB
	(LOC RAMP)
	(DESC "red frob")
        (ADJECTIVE RED)
	(SYNONYM FROB FROBS)
	(FLAGS TAKEBIT)
	(SIZE 1)>

<OBJECT GREEN-FROB
	(LOC RAMP)
	(DESC "green frob")
        (ADJECTIVE GREEN)
	(SYNONYM FROB FROBS)
	(FLAGS TAKEBIT)
	(SIZE 1)>

<OBJECT BIG-BLUE-FROB
	(LOC THING)
	(DESC "big blue frob")
        (ADJECTIVE BIG BLUE)
	(SYNONYM FROB FROBS)
	(FLAGS TAKEBIT)
	(SIZE 1)>

<OBJECT SMALL-BLUE-FROB
	(LOC THING)
	(DESC "small blue frob")
        (ADJECTIVE SMALL BLUE)
	(SYNONYM FROB FROBS)
	(FLAGS TAKEBIT)
	(SIZE 1)>
