"PLACES for MILLIWAYS
Copyright (C) 1988 Infocom, Inc.  All rights reserved."

"The usual globals"

<OBJECT ROOMS
	(DESC "that")
	(FLAGS NARTICLEBIT)>

;<ROUTINE NULL-F ("OPTIONAL" A1 A2)
	<RFALSE>>

<ROUTINE DOOR-ROOM (RM DR "AUX" (P 0) TBL)
	 <REPEAT ()
		 <COND (<OR <0? <SET P <NEXTP .RM .P>>>
			    <L? .P ,LOW-DIRECTION>>
			<RFALSE>)
		       (<AND <==? ,DEXIT <PTSIZE <SET TBL <GETPT .RM .P>>>>
			     <==? .DR <GET/B .TBL ,DEXITOBJ>>>
			<RETURN <GET/B .TBL ,REXIT>>)>>>

<ROUTINE FIND-IN (RM FLAG "OPTIONAL" (EXCLUDED <>) "AUX" O)
	<SET O <FIRST? .RM>>
	<REPEAT ()
	 <COND (<NOT .O> <RFALSE>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <==? .O .EXCLUDED>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-NOT (RM FLAG ;"OPTIONAL" ;(EXCLUDED <>) "AUX" O)
	<SET O <FIRST? .RM>>
	<REPEAT ()
	 <COND (<NOT .O> <RFALSE>)
	       (<AND <NOT <FSET? .O .FLAG>>
		     <NOT <FSET? .O ,INVISIBLE>>
		     ;<NOT <==? .O .EXCLUDED>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-LG (RM FLAG "OPTIONAL" (FLAG2 0) "AUX" TBL O (CNT 0) SIZE)
	 <COND (<SET TBL <GETPT .RM ,P?GLOBAL>>
		<SET SIZE <RMGL-SIZE .TBL>>
		<REPEAT ()
			<SET O <GET/B .TBL .CNT>>
			<COND (<AND <FSET? .O .FLAG>
				    <NOT <FSET? .O ,INVISIBLE>>
				    <OR <0? .FLAG2> <FSET? .O .FLAG2>>>
			       <RETURN .O>)
			      (<IGRTR? CNT .SIZE> <RFALSE>)>>)>>

<ROUTINE FIND-FLAG-HERE (FLAG "OPTIONAL" (NOT1 <>) (NOT2 <>) "AUX" O)
	<SET O <FIRST? ,HERE>>
	<REPEAT ()
	 <COND (<NOT .O> <RFALSE>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <EQUAL? .O .NOT1 .NOT2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

;<ROUTINE FIND-FLAG-HERE-BOTH (FLAG FLAG2 "OPTIONAL" (NOT2 <>) "AUX" O)
	<SET O <FIRST? ,HERE>>
	<REPEAT ()
	 <COND (<NOT .O> <RFALSE>)
	       (<AND <FSET? .O .FLAG>
		     <FSET? .O .FLAG2>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <EQUAL? .O .NOT2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-HERE-NOT (FLAG NFLAG "OPTIONAL" (NOT2 <>) "AUX" O)
	<SET O <FIRST? ,HERE>>
	<REPEAT ()
	 <COND (<NOT .O> <RFALSE>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O .NFLAG>>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <EQUAL? .O .NOT2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

;<ROUTINE OPEN-CLOSE (DR "OPTIONAL" (SAY-NAME T) X)
	<COND (.SAY-NAME
	       <TELL The .DR>)>
	<TELL " creaks ">
	<COND (<FSET? .DR ,OPENBIT>
	       <FCLEAR .DR ,OPENBIT>
	       <THIS-IS-IT .DR>
	       <TELL "closed.|">
	       <REMOVE-CAREFULLY>
	       <RTRUE>)
	      (<SET X <DOOR-ROOM ,HERE .DR>>
	       <FSET .DR ,OPENBIT>
	       <THIS-IS-IT .X>
	       <TELL "open, revealing">
	       <COND (T ;<FSET? ,HERE ,SECRETBIT>
		      <TELL the .X>)>
	       <FSET .DR ,SEENBIT>
	       <FSET .X ,SEENBIT>
	       <TELL "!" CR>)>>

;<ROUTINE OUTSIDE? (RM) <GLOBAL-IN? ,SKY .RM>>

<ROUTINE UNIMPORTANT-THING-F ()
	 <COND (<AND <VERB? ASK-ABOUT>
		     <EQUAL? ,PRSO ,GUIDE>>
		<RFALSE>)
	       (T
		<TELL "That's not important; leave it alone." CR>)>>

;<OBJECT CAR-WINDOW
	(LOC CAR ;LOCAL-GLOBALS)
	(DESC "car window")
	(ADJECTIVE CAR)
	(SYNONYM WINDOW WINDSHIELD WINDSCREEN DOOR)
	;(GENERIC GENERIC-WINDOW)
	(FLAGS SEENBIT NDESCBIT)
	(ACTION WINDOW-F)>

<OBJECT WINDOW
	(LOC LOCAL-GLOBALS)
	(DESC ;"room " "window")
	;(ADJECTIVE ROOM)
	(SYNONYM WINDOW WINDSHIELD WINDSCREEN DOOR)
	;(GENERIC GENERIC-WINDOW)
	(FLAGS SEENBIT NDESCBIT)
	(ACTION WINDOW-F)>

<ROUTINE WINDOW-F ()
 <COND (<VERB? OPEN CLOSE LOCK UNLOCK>
	<COND (<VERB? OPEN>
	       <TELL "The night air is too damp and chilly." CR>)
	      (T ;<VERB? CLOSE>
	       <ALREADY ,WINDOW "closed">
	       <RTRUE>)>)
       (<VERB? DISEMBARK ;"CLIMB OUT" LEAVE THROUGH>
	<TELL "It's closed tight against the mist." CR>)
       (<VERB? LOOK-INSIDE LOOK-THROUGH LOOK-OUTSIDE>
	<TELL "All you can see are grey shapes in the moonlight." CR>)>>

;<ROOM RAMP
      (DESC "Ramp")
      (LOC ROOMS)
      ;(ADJECTIVE LEGENDARY)
      ;(SYNONYM PLANET MAGRATHEA)
      (LDESC
"The wind moans. Dust drifts across the surface of the alien world. Zaphod,
Ford, and Trillian appear and urge you forward.")
      (FLAGS RLANDBIT ONBIT)
      (THINGS RAMP DOOR NULL-F)
      (IN TO HATCHWAY IF HATCH IS OPEN)
      (UP TO HATCHWAY IF HATCH IS OPEN)
      ;(ACTION RAMP-F)>

;<ROUTINE RAMP-F (RARG)
	 <COND (<EQUAL? .RARG ,M-END>
		<TELL CR
"Slowly, nervously, you step downwards, the cold thin air rasping in your
lungs. You set one single foot on the ancient dust -- and almost instantly
the most incredible adventure starts which you'll have to buy the next game
to find out about." CR CR>
		<V-SCORE>
		<TELL CR
"By the way, there WAS a causal relationship between your taking the "
D ,TOOTHBRUSH " and the tree collapsing at the very beginning of the game.
We apologise for this slight inaccuracy." CR>
		<FINISH>)>>

;<ROOM HATCHWAY
      (LOC ROOMS)
      ;(SYNONYM GPP PERSONALITY)
      ;(ADJECTIVE GENUINE PEOPLE)
      (DESC "Hatchway")
      ;(UP TO AFT-CORRIDOR)
      (DOWN TO RAMP IF HATCH IS OPEN)
      (OUT TO RAMP IF HATCH IS OPEN)
      ;(EAST PER ACCESS-SPACE-ENTER-F)
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL STAIRS HEART-OF-GOLD)
      (ACTION HATCHWAY-F)>

;<ROUTINE HATCHWAY-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are at the bottom of a gangway. A hatch below you is ">
		<COND (<FSET? ,HATCH ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL
". There could be a small access space to starboard, but it's not implemented
yet." CR>)>>

;<OBJECT PUB-OBJECT
	(LOC LOCAL-GLOBALS)
	(DESC "restaurant")
	(SYNONYM RESTAURANT MILLIWAYS)
	(ACTION PUB-OBJECT-F)>

;<ROUTINE PUB-OBJECT-F ()
	 <COND (<VERB? WALK-TO THROUGH>
		<COND (<EQUAL? ,HERE ,PUB>
		       <TELL ,LOOK-AROUND CR>)
		      (T
		       <V-WALK-AROUND>)>)
	       (<VERB? LEAVE DISEMBARK>
		<COND (<EQUAL? ,HERE ,PUB>
		       <DO-WALK ,P?EAST>)
		      (T
		       <TELL ,LOOK-AROUND CR>)>)>>

;<CONSTANT LOOK-AROUND "Look around you.">

<ROOM PUB
      (LOC ROOMS)
      (SYNONYM ALCOHOL)
      (DESC "restaurant")
      (FLAGS RLANDBIT ONBIT OUTSIDE)
      (GLOBAL ;PUB-OBJECT WINDOW PUB-FURNISHINGS)
      (THINGS <> PEOPLE UNIMPORTANT-THING-F)
      (ACTION PUB-F)>

<ROUTINE PUB-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"Milliways is pleasant and cheerful and full of pleasant and cheerful
people who don't know they've got about twelve minutes to live and are
therefore having a spot of lunch." CR>)>>

;<OBJECT BAR
	(LOC PUB)
	(DESC "bar")
	(SYNONYM BAR COUNTER)
	(FLAGS NDESCBIT CONTBIT SURFACEBIT OPENBIT)
	(CAPACITY 60)
	;(ACTION BAR-F)>

;<OBJECT MUSIC
	(LOC PUB)
	(DESC "music")
	(SYNONYM MUSIC SONG SONGS)
	(FLAGS NARTICLEBIT NDESCBIT)
	;(ACTION MUSIC-F)>

;<ROUTINE MUSIC-F ()
	 <COND (<VERB? LISTEN ENJOY>
		<PERFORM ,V?LISTEN ,JUKEBOX>
		<RTRUE>)>>

<OBJECT PUB-FURNISHINGS
	(LOC LOCAL-GLOBALS)
	(DESC "it")
	(ADJECTIVE USUAL SOGGY)
	(SYNONYM BEERMAT GLASSES BOTTLE GLASS)
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION UNIMPORTANT-THING-F)>

;<OBJECT BARMAN
	(LOC PUB)
	(DESC "waiter")
	(LDESC "There is a barman serving at the bar.")
	(SYNONYM BARMAN BARTENDER WAITER)
	(FLAGS PERSONBIT)
	(ACTION BARMAN-F)>

;<ROUTINE BARMAN-F ()
	 <COND (<EQUAL? ,BARMAN ,WINNER>
		<COND (<AND <VERB? TELL-ABOUT>
			    <EQUAL? ,PRSO ,PLAYER>>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK-ABOUT ,BARMAN ,PRSI>
		       <SETG WINNER ,BARMAN>
		       <RTRUE>)
		      (<VERB? HELLO>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?HELLO ,BARMAN>
		       <SETG WINNER ,BARMAN>
		       <RTRUE>)
		      (<AND <VERB? GIVE>
			    <EQUAL? ,PRSO ,PLAYER>
			    <EQUAL? ,PRSI ,SANDWICH ,BEER>>
		       <PERFORM ,V?BUY ,PRSI>
		       <RTRUE>)
		      (T
		       <TELL
"The barman ignores you and keeps polishing the other end of the bar." CR>)>)
	       (<AND <VERB? ASK-FOR>
		     <EQUAL? ,PRSI ,SANDWICH ,BEER>>
		<PERFORM ,V?BUY ,PRSI>
		<RTRUE>)>>

<OBJECT BEER
	;(LOC PUB)
	(DESC "lots of beer")
	(SYNONYM LOTS BITTER PINT BEER)
	(FLAGS DRINKBIT NARTICLEBIT NDESCBIT)
	(ACTION BEER-F)>

<GLOBAL DRUNK-LEVEL 0>

<ROUTINE BEER-F ()
	 <COND (<AND <VERB? DRINK ENJOY COUNT SMELL RUB TAKE>
		     <FSET? ,BEER ,NDESCBIT>>
		<TELL "You'd better buy some first." CR>)
	       (<VERB? COUNT>
		<TELL "Lots." CR>)
	       (<VERB? TAKE>
		<TELL "Just drink it!" CR>)
	       (T
		<COND (<VERB? DRINK ENJOY>
		       <SETG SCORE <+ ,SCORE 5>>
		       <SETG DRUNK-LEVEL <+ ,DRUNK-LEVEL 1>>
		       <COND (<EQUAL? ,DRUNK-LEVEL 4>
			      <TELL
"You can hear the muffled noise of your home being demolished, and the
taste of the beer sours in your mouth." CR CR>
		              ;<PERFORM ,V?GET-DRUNK ,ROOMS>
			      <RTRUE>)
			     (<EQUAL? ,DRUNK-LEVEL 3>
			      ;<QUEUE I-FORD -1>
			      ;<SETG HOUSE-DEMOLISHED T>
			      ;<SETG PROSSER-LYING <>>
			      <TELL
"There is a distant crash which Ford explains is nothing to worry about,
probably just your house being knocked down." CR>)
			     (<EQUAL? ,DRUNK-LEVEL 2>
			      <TELL
"It is really very pleasant stuff, with a very good dry, nutty flavour, some
light froth on top, and a deep colour. It is at exactly room temperature. You
reflect that the world cannot be all bad when there are such pleasures in it.|
|
Ford mentions that the world is going to end in about twelve minutes." CR>)
			     (<EQUAL? ,DRUNK-LEVEL 1>
			      <TELL
"It's very good beer, brewed by a small local company. You particularly like
its flavour, which is why you woke up feeling so wretched this morning. You
were at somebody's birthday party here in the Pub last night.|
|
You begin to relax and enjoy yourself, so when Ford mentions that he's from a
small planet in the vicinity of Betelgeuse, not from Guildford as he usually
claims, you take it in your stride, and say \"Oh yes, which part?\"" CR>)>)
		      (<VERB? BUY>
		       <COND ;(<FSET? ,BEER ,NDESCBIT>
			      <PERFORM ,V?BUY ,PEANUTS>
			      <RTRUE>)
			     (T
			      <TELL
D ,FORD " has already bought an enormous quantity for you!" CR>)>)>)>>

<OBJECT SANDWICH
	(LOC PUB)
	(DESC "cheese sandwich")
	(ADJECTIVE CHEESE UNINVITING)
	(SYNONYM PLATE SANDWICH)
	(FLAGS NDESCBIT EATBIT TRYTAKEBIT)
	(SIZE 10)
	(ACTION SANDWICH-F)>

<GLOBAL SANDWICH-BOUGHT:FLAG <>>
<ROUTINE SANDWICH-F ()
	 <COND (<AND <VERB? BUY>
		     <NOT ,SANDWICH-BOUGHT>>
	        <MOVE ,SANDWICH ,PLAYER>
		<FSET ,SANDWICH ,TAKEBIT>
	        <FCLEAR ,SANDWICH ,TRYTAKEBIT>
		<FCLEAR ,SANDWICH ,NDESCBIT>
		<SETG SANDWICH-BOUGHT T>
		<TELL
"The barman gives you a " D ,SANDWICH ". The bread is like the stuff that
stereos come packed in, the cheese would be great for rubbing out spelling
mistakes, and margarine and pickle have performed an unedifying chemical
reaction to produce something that shouldn't be, but is, turquoise. Since
it is clearly unfit for human consumption you are grateful to be charged
only a pound for it." CR>)
	       (<VERB? BUY>
		<TELL "You already did." CR>)
	       (<AND <VERB? TAKE EAT ENJOY>
		     <FSET? ,SANDWICH ,TRYTAKEBIT>
		     <EQUAL? ,HERE ,PUB>>
		<TELL ,HANDS-OFF CR>)
	       (<VERB? EAT ENJOY>
		<MOVE ,SANDWICH ,LOCAL-GLOBALS>
		<SETG SCORE <- ,SCORE 30>>
		<COND (T
		       <TELL
"It is one of the least rewarding taste experiences you can recall." CR>)>)>>

<CONSTANT HANDS-OFF "The barman snaps \"Hands off until you pay for it!\"">
