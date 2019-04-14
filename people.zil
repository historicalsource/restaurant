"PEOPLE for MILLIWAYS
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

"Constants used as table offsets for each character, including the player:"
<CONSTANT PLAYER-C 0>
<CONSTANT MARVIN-C 1>
<CONSTANT FORD-C 2>
<CONSTANT ZAPHOD-C 3>
<CONSTANT TRILLIAN-C 4>
<CONSTANT CHARACTER-MAX 4>

<CONSTANT BODY-PARTS-OWNERS
	<TABLE (LENGTH PURE) PLAYER MARVIN FORD ZAPHOD TRILLIAN>>

<OBJECT PLAYER
	(LOC RAMP)
	(DESC "yourself")
	(SYNONYM ;"I" ME MYSELF SELF)
	(FLAGS NDESCBIT NARTICLEBIT SEARCHBIT PERSONBIT SEENBIT TOUCHBIT
		;TRANSBIT OPENBIT ;"see GET-OBJECT")
	(CHARACTER 0)
	(ACTION PLAYER-F)>

<CONSTANT ME PLAYER>

<ROUTINE PLAYER-F ("OPTIONAL" (ARG <>) "AUX" (L <>))
 <COND (<NOT <==? .ARG ,M-WINNER>>
	<COND (<DOBJ? PLAYER>
	       <COND (<VERB? ;DANCE ;GOODBYE HELLO SORRY THANK>
		      <HAR-HAR>
		      <RTRUE>)
		     (<VERB? ALARM>
		      <TELL ,YOU-ARE CR>
		      <RTRUE>)
		     ;(<VERB? EXAMINE>
		      <TELL "You are wearing">
		      <COND (<ZERO? ,NOW-WEARING> <TELL " nothing">)
			    (T <TELL the ,NOW-WEARING>)>
		      <SET L <FIRST? ,PLAYER>>
		      <REPEAT ()
			      <COND (<ZERO? .L>
				     <RETURN>)
				    (<AND <FSET? .L ,WORNBIT>
					  <NOT <==? .L ,NOW-WEARING>>>
				     <TELL " and" the .L>)>
			      <SET L <NEXT? .L>>>
		      <TELL "." CR>
		      <RTRUE>)
		     (<VERB? FIND>
		      <TELL "You're right here, ">
		      <TELL-LOCATION>
		      <CRLF>
		      <RTRUE>)
		     (<VERB? FOLLOW>
		      <TELL
"I'd like to, but like most computers I don't have legs." CR>
		      <RTRUE>)
		     (<OR <VERB? KILL MUNG>
			  ;<AND <VERB? SHOOT>
				<IOBJ? BLASTER>>>
		      <JIGS-UP "Done.">
		      <RTRUE>)
		     (<VERB? LISTEN>
		      <TELL "Yes?" CR>
		      <RTRUE>)
		     (<VERB? MOVE>
		      <V-WALK-AROUND>
		      <RTRUE>)
		     (<VERB? PULL-TOGETHER>
		      <TELL ,ZEN CR>
		      <RTRUE>)
		     (<VERB? SEARCH>
		      <V-INVENTORY>
		      <RTRUE>)
		     (<VERB? TELL>
		      <FUCKING-CLEAR>
		      <TELL
"Talking to yourself is a sign of impending mental collapse." CR>
		      <RTRUE>)>)
	      (<IOBJ? PLAYER>
	       <COND (<VERB? GIVE>
		      <COND (<AND <IN? ,PRSO ,PLAYER>
				  <NOT <DOBJ? BABEL-FISH>>>
			     <PRE-TAKE>
			     <RTRUE>)
			    (T
			     <PERFORM ,V?TAKE ,PRSO>
			     <RTRUE>)>)>)
	      (T <RFALSE>)>)
       ;(<DIVESTMENT? ,NOW-WEARING>
	<COND (<NO-CHANGING?> <RTRUE>)
	      (T
	       <COND (<AND <NOT <ZERO? ,NOW-WEARING>>
			   <NOT <VERB? DISEMBARK REMOVE>>>
		      <FIRST-YOU "remove" ,NOW-WEARING>
		      <FCLEAR ,NOW-WEARING ,WORNBIT>
		      <SETG NOW-WEARING <>>)>
	       <RFALSE>)>)
       (<AND <T? ,PRSI>
	     <NOT <VERB? SEARCH-FOR>>
	     <FSET? ,PRSI ,SECRETBIT>
	     <NOT <FSET? ,PRSI ,SEENBIT>>>
	<NOT-FOUND ,PRSI>
	<RTRUE>)
       (<AND <T? ,PRSO>
	     <NOT <VERB? FIND WALK>>
	     <FSET? ,PRSO ,SECRETBIT>
	     <NOT <FSET? ,PRSO ,SEENBIT>>>
	<NOT-FOUND ,PRSO>
	<RTRUE>)
       ;(<AND <T? ,AWAITING-REPLY>
	     <VERB? FOLLOW THROUGH WALK WALK-TO>>
	<SETG CLOCK-WAIT T>
	<PLEASE-ANSWER>
	<RTRUE>)
       (<AND <EQUAL? <SET L <LOC ,PLAYER>> ,HERE ;,CAR>
	     ;<NOT ,PLAYER-SEATED>
	     ;<NOT ,PLAYER-HIDING>>
	<RFALSE>)
       (<T? ,P-WALK-DIR>		<TOO-BAD-SIT-HIDE>)
       (<EQUAL? ,PRSO <> ,ROOMS .L>
					<RFALSE>)
       (<VERB? WALK-TO SEARCH SEARCH-FOR FIND>
	<COND (<DOBJ? SLEEP-GLOBAL>	<RFALSE>)
	      (T			<TOO-BAD-SIT-HIDE>)>)
       (<SPEAKING-VERB?>		<RFALSE>)
       (<GAME-VERB?>			<RFALSE>)
       (<REMOTE-VERB?>			<RFALSE>)
       (<VERB? AIM FAINT LISTEN LOOK-ON NOD SHOOT SMILE>
					<RFALSE>)
       (<HELD? ,PRSO>			<RFALSE>)
       (<HELD? ,PRSO ,GLOBAL-OBJECTS>	<RFALSE>)
       (<VERB? EXAMINE>			<RFALSE>)
       (<NOT <HELD? ,PRSO .L ;,PLAYER-SEATED>>	<TOO-BAD-SIT-HIDE>)
       (<NOT ,PRSI>			<RFALSE>)
       (<HELD? ,PRSI>			<RFALSE>)
       (<HELD? ,PRSI ,GLOBAL-OBJECTS>	<RFALSE>)
       (<NOT <HELD? ,PRSI .L ;,PLAYER-SEATED>>	<TOO-BAD-SIT-HIDE>)>>

<ROUTINE TOO-BAD-SIT-HIDE ()
	<MOVE ,WINNER ,HERE>
	<FIRST-YOU "stand up">
	<RFALSE>>

<ROUTINE FUCKING-CLEAR ()
	 <SETG P-CONT <>>
	 ;<SETG QUOTE-FLAG <>>
	 <RFATAL>>

<CONSTANT YOU-ARE "You already are!">

;<ROUTINE PLEASE-ANSWER ("AUX" (P <GETB ,QUESTIONERS ,AWAITING-REPLY>))
	<TELL D .P " says, \"">
	<COND (<EQUAL? .P ,BUTLER ,DOCTOR>
	       <TELL "Pardon me, "TN", but">)
	      (T <TELL "Wait a mo'.">)>
	<TELL " I asked you a question.\"" CR>>

<OBJECT MARVIN
	(LOC RAMP)
	(DESC "Marvin")
	(TEXT "Marvin, the Paranoid Android, looks very depressed.")
	(ADJECTIVE DEPRESSED PARANOID)
	(SYNONYM MARVIN MARV ROBOT ANDROID)
	(FLAGS NARTICLEBIT PERSONBIT)
	(LDESC 0)
	(WEST SORRY "sulking")
	(LINE 0)	;"unfriendliness"
	(CHARACTER 1)
	(DESCFCN MARVIN-D)
	(ACTION MARVIN-F)>

<CONSTANT M-OTHER 42>

<ROUTINE MARVIN-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,MARVIN>> <RFATAL>)
	      (<SET X <COM-CHECK ,MARVIN>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T
	       <FUCKING-CLEAR>
	       <TELL
"\"I think you ought to know I'm feeling very depressed.\"" CR>)>)
       (<SET OBJ <ASKING-ABOUT? ,MARVIN>>
	<COND (<NOT <GRAB-ATTENTION ,MARVIN .OBJ>>
	       <RFATAL>)
	      (<EQUAL? .OBJ ,OBJECT-OF-GAME>
	       <TELL
"\"Being clever doesn't always make you happy, you know. Look at me, brain
the size of a planet, how many points do you think I've got? Minus thirty
zillion at the last count.\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,MARVIN .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,MARVIN .OBJ>)>)
       (<AND <VERB? ALARM SHAKE>
	     <EQUAL? <GETP ,MARVIN ,P?LDESC> 14 ;"asleep">>
	<TELL "Rather like trying to wake the dead." CR>)
       (T <PERSON-F ,MARVIN .ARG>)>>

<ADJ-SYNONYM MR MISTER>
<ADJ-SYNONYM MS MISS>

<OBJECT FORD
	(LOC RAMP)
	(DESC "Ford Prefect")
	(TEXT "Ford is a Betelgeusan who could pass for an Earthling.")
	(ADJECTIVE FORD MR)
	(SYNONYM FORD PREFECT)
	(FLAGS PERSONBIT CONTBIT SEARCHBIT OPENBIT NARTICLEBIT)
	(LDESC 0)
	(WEST SORRY "deep in thought")
	(LINE 0)	;"unfriendliness"
	(CHARACTER 2)
	(DESCFCN FORD-D)
	(ACTION FORD-F)>

<ROUTINE ASKING-ABOUT? (WHO "AUX" DR)
	<COND (<VERB? ASK-ABOUT ;CONFRONT SHOW>
	       <COND (<EQUAL? .WHO ,PRSO>
		      <RETURN ,PRSI>)>)
	      ;(<VERB? FIND ;WHAT>
	       <COND (<EQUAL? .WHO ,WINNER>
		      <RETURN ,PRSO>)>)
	      (T <RFALSE>)>>

<ROUTINE FORD-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,FORD>> <RFATAL>)
	      (<SET X <COM-CHECK ,FORD>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T
	       <FUCKING-CLEAR>
	       <TELL "Ford, busy scanning the sky">
	       <COND (<EQUAL? ,HERE ,PUB>
		      <TELL " through the window">)>
	       <TELL ", ignores you." CR>)>)
       (<SET OBJ <ASKING-ABOUT? ,FORD>>
	<COND (<NOT <GRAB-ATTENTION ,FORD .OBJ>>
	       <RFATAL>)
	      (<EQUAL? .OBJ ,THIRD-PLANET>
	       <TELL
"Ford explains that the Earth has been demolished. To cheer you up, he points
out that there are an awful lot of little planets like that around, and the
Earth wasn't even a particularly nice one." CR>)
	      (<SET X <COMMON-ASK-ABOUT ,FORD .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,FORD .OBJ>)>)
       (<AND <VERB? ALARM SHAKE>
	     <EQUAL? <GETP ,FORD ,P?LDESC> 14 ;"asleep">>
	<TELL "Rather like trying to wake the dead." CR>)
       (T <PERSON-F ,FORD .ARG>)>>

<ROUTINE TELL-DUNNO (PER OBJ)
 <COND ;(<FSET? .OBJ ,PERSONBIT>
	<TELL "\"I don't indulge much in idle gossip, you know.\"" CR>)
       (T
	<TELL "\"You know as much as I do.\"" CR>)>>

<CONSTANT PRESIDENT " President of the Galaxy">

<OBJECT ZAPHOD
	(LOC RAMP)
	(DESC "Zaphod Beeblebrox")
	(TEXT "Zaphod looks completely normal, except for his two heads.")
	(ADJECTIVE ZAPHOD PRESIDENT MR)
	(SYNONYM BEEBLEBROX ZAPHOD PRESIDENT)
	(FLAGS NARTICLEBIT PERSONBIT ;NDESCBIT)
	(LDESC 0)
	(WEST SORRY "admiring himself")
	(LINE 0)	;"unfriendliness"
	(CHARACTER 3)
	(DESCFCN ZAPHOD-D)
	(ACTION ZAPHOD-F)>

<ROUTINE ZAPHOD-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,ZAPHOD>> <RFATAL>)
	      (<SET X <COM-CHECK ,ZAPHOD>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T
	       <FUCKING-CLEAR>
	       <TELL "\"Shut up, Earthman.\"" CR>)>)
       (<SET OBJ <ASKING-ABOUT? ,ZAPHOD>>
	<COND (<NOT <GRAB-ATTENTION ,ZAPHOD .OBJ>>
	       <RFATAL>)
	      (<SET X <COMMON-ASK-ABOUT ,ZAPHOD .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,ZAPHOD .OBJ>)>)
       (<VERB? EXAMINE>
	<TELL "Zaphod has two heads." CR>)
       (T <PERSON-F ,ZAPHOD .ARG>)>>

<OBJECT TRILLIAN
	(LOC RAMP)
	(DESC "Trillian")
	(TEXT "Tricia MacMillan is more attractive than most astrophysicists.")
	(ADJECTIVE TRICIA DARK-HAIR DARK HAIRED MS)
	(SYNONYM TRILLIAN MCMILLAN WOMAN TRICIA)
	(FLAGS NARTICLEBIT PERSONBIT ;NDESCBIT CONTBIT OPENBIT FEMALE)
	(LDESC 0)
	(WEST SORRY "looking at you with pity")
	(LINE 0)	;"unfriendliness"
	(CHARACTER 4)
	(DESCFCN TRILLIAN-D)
	(ACTION TRILLIAN-F)>

<ROUTINE TRILLIAN-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,TRILLIAN>> <RFATAL>)
	      (<SET X <COM-CHECK ,TRILLIAN>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T
	       <FUCKING-CLEAR>
	       <TELL
D ,TRILLIAN " smiles disinterestedly at you and looks away." CR>)>)
       (<SET OBJ <ASKING-ABOUT? ,TRILLIAN>>
	<COND (<NOT <GRAB-ATTENTION ,TRILLIAN .OBJ>>
	       <RFATAL>)
	      (<SET X <COMMON-ASK-ABOUT ,TRILLIAN .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,TRILLIAN .OBJ>)>)
       (T <PERSON-F ,TRILLIAN .ARG>)>>

<CONSTANT CHARACTER-TABLE
	<PTABLE PLAYER MARVIN FORD ZAPHOD TRILLIAN ;4>>

<CONSTANT FOLLOW-LOC	 <TABLE 0 0 0 0 0>>

<CONSTANT TOUCHED-LDESCS <TABLE 0 0 0 0 0>>

;<ROUTINE WHY-ME ()
 <COND (<PROB 33>
	<TELL "\"You could do that " 'PLAYER ", you know.\"" CR>)
       (<PROB 50>
	<TELL "\"If you think that will help, do it!\"" CR>)
       (T <TELL "\"I think you can do that better " 'PLAYER ".\"" CR>)>>

<ROUTINE MARVIN-D ("OPTIONAL" (ARG <>))
	<DESCRIBE-PERSON ,MARVIN>
	<RTRUE>>

<ROUTINE FORD-D ("OPTIONAL" X)
	 <COND (<EQUAL? <GETP ,FORD ,P?LDESC> 14 ;"asleep">
		<TELL "Ford is in the corner, snoring loudly." CR>)
	       (T
		<DESCRIBE-PERSON ,FORD>
		<RTRUE>)>>

<ROUTINE ZAPHOD-D ("OPTIONAL" (ARG <>))
	<DESCRIBE-PERSON ,ZAPHOD>
	<RTRUE>>

<ROUTINE TRILLIAN-D ("OPTIONAL" (ARG <>))
	<DESCRIBE-PERSON ,TRILLIAN>
	<RTRUE>>

<ROUTINE DESCRIBE-PERSON (PER "AUX" (STR <>))
	<SET STR <GETP .PER ,P?LDESC>>
	<COND (<AND .STR ;<NOT <==? .STR 6 ;"walking along">>>
	       <PUT ,TOUCHED-LDESCS <GETP .PER ,P?CHARACTER> .STR>
	       <RFALSE>)>
	<TELL The .PER " is ">
	<COND (<AND <SET STR <GETPT .PER ,P?WEST>>
		    <SET STR <GET .STR ,NEXITSTR>>>
	       <TELL .STR>)
	      (T
	       <TELL "looking bored">)>
	<TELL ".">
	<COND (<==? .STR 6 ;"walking along"> <PRINTC 32>)
	      (T <CRLF>)>
	<RTRUE>>

<CONSTANT LDESC-STRINGS
 <PLTABLE	"dancing"
		"sipping sherry"
	;3	"watching you" ;"talking quietly"
		"looking at you with suspicion"
		0 ;"gazing out the window"
	;6	"walking along"
		"sobbing quietly"
		"poised to attack"
	;9	"waiting patiently"
		"eating with relish"
		"preparing dinner"
	;12	"listening to you"
		"lounging and chatting"
		"asleep"
	;15	0 ;"reading a note"
		"listening"
		"preparing to leave"
	;18	"deep in thought"
		"out cold"
		"ignoring you"
	;21	"searching"
		"playing the piano"
		"following you"
	;24	"brushing her hair"
		"looking sleepy">>

;<ROUTINE TELL-ABOUT-OBJECT (PER OBJ GL "AUX" C)
	<COND (<T? <GET .GL ,PLAYER-C>>
	       <SET C <GETP .PER ,P?CHARACTER>>
	       <COND (<ZERO? <GET .GL .C>>
		      <PUT .GL .C T>
		      <RETURN <GOOD-SHOW .PER .OBJ>>)
		     (T <TELL"\"I know that you found a " D .OBJ ".\"" CR>)>)>>

<ROUTINE PERSON-F (PER ARG "AUX" OBJ X L C N)
 <SET L <LOC .PER>>
 <SET C <GETP .PER ,P?CHARACTER>>
 <COND (<VERB? ALARM SHAKE>
	<COND (<==? ,PRSO .PER>
	       <COND (<UNSNOOZE .PER T>
		      <TELL He .PER " gasps to see you so close!" CR>
		      <RTRUE>)
		     (T
		      <TELL He+verb .PER "is" " still ">
		      <COND (<SET X <GETP .PER ,P?LDESC>>
			     <TELL <GET ,LDESC-STRINGS .X>>)
			    (<SET X <GETPT .PER ,P?WEST>>
			     <TELL <GET .X ,NEXITSTR>>)>
		      <TELL "." CR>)>)>)
       (<VERB? GIVE>
	<COND (<AND <EQUAL? ,PRSI .PER> <HELD? ,PRSO>>
	       <COND (<NOT <GRAB-ATTENTION .PER>> <RFATAL>)>
	       <RFALSE>)>)
       (<VERB? LAMP-OFF>
	<COND (<T? <GETP .PER ,P?LINE>>
	       <TELL "Seems you've already done that." CR>)
	      (T <WONT-HELP>)>)
       (<VERB? MUNG SEARCH SEARCH-FOR>
	<COND (<AND <==? .PER ,PRSO>
		    <FSET? .PER ,PERSONBIT>
		    <NOT <FSET? .PER ,MUNGBIT>>>
	       <PUTP .PER ,P?LINE <+ 1 <GETP .PER ,P?LINE>>>
	       <COND (<NOT <EQUAL? <GETP .PER ,P?LDESC>
				   4 ;"looking at you with suspicion">>
		      <PUTP .PER ,P?LDESC 20 ;"ignoring you">)>
	       <TELL
He .PER " pushes you away and mutters, \"I don't think that's
called for.\"" CR>
	       <RTRUE>)>)
       (<VERB? SHOW>
	<COND (<==? .PER ,PRSO>
	       <COND (<AND ;<NOT <EQUAL? ,PRSI ,PASSAGE>>
			   <NOT <GRAB-ATTENTION .PER>>>
		      <RFATAL>)
		     (T
		      <PERFORM ,V?TELL-ABOUT ,PRSO ,PRSI>
		      <RTRUE>)>)>)
       (<VERB? SMILE>
	<COND (<==? .PER ,PRSO>
	       <COND (<NOT <GRAB-ATTENTION .PER>>
		      <RFATAL>)
		     (T
		      <TELL He+verb ,PRSO "smile" " back at you." CR>
		      <RTRUE>)>)>)
       (<VERB? TELL-ABOUT>
	<COND (<==? .PER ,PRSO>
	       <COND (<NOT <GRAB-ATTENTION .PER>>
		      <RFATAL>)>
	       <PUTP .PER ,P?LDESC 12 ;"listening to you">
	       ;<COND (<SECRET-PASSAGE-OR-DOOR? ,PRSI>
		      <TELL-ABOUT-OBJECT ,PRSO ,PASSAGE ,FOUND-PASSAGES>
		      <RTRUE>)>
	       <TELL "\"I don't know what you mean.\"" CR>)>)
       (<VERB? THROW-AT>
	<COND (<AND <==? .PER ,PRSI>
		    <FSET? .PER ,PERSONBIT>
		    <NOT <FSET? .PER ,MUNGBIT>>>
	       <MOVE ,PRSO ,PRSI>
	       <TELL He .PER " catches" the ,PRSO " with" his .PER !\ >
	       <COND ;(<EQUAL? .PER ,DEB ,DOCTOR> <TELL "lef">)
		     (T <TELL "righ">)>
	       <TELL "t hand." CR>
	       <RTRUE>)>)
       ;(<SET OBJ <ASKING-ABOUT? .PER>>
	<COND (<NOT <GRAB-ATTENTION .PER>>
	       <RFATAL>)
	      ;(<SET X <COMMON-ASK-ABOUT .PER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW .PER .OBJ>)>)
       (T <COMMON-OTHER .PER>)>>

"People Functions"

<ROUTINE CARRY-CHECK (PER)
 <COND (<FIRST? .PER>
	<TELL He+verb .PER "is" " holding">
	<PRINT-CONTENTS .PER>
	<TELL "." CR>)>>

<ROUTINE TRANSIT-TEST (PER)
	<COND (<OR <VERB? DISEMBARK LEAVE TAKE-TO THROUGH WALK WALK-TO>
		   ;<AND <VERB? FOLLOW>
			<DOBJ? PLAYER>>>
	       T ;<WILLING? .PER>)>>

<ROUTINE COM-CHECK (PER "AUX" N)
 	 <SET N <GETP .PER ,P?LINE>>
	 <COND (<VERB? $CALL>	;"e.g. TAMARA, LOVE ME"
		<DONT-UNDERSTAND>
		<RETURN ,M-OTHER>)
	       (<TRANSIT-TEST .PER>
		<RFATAL>)
	       (<VERB? ALARM HELLO SORRY>
		<COND (<OR <DOBJ? ROOMS> <==? ,PRSO .PER>>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,PRSA .PER>
		       <RTRUE>)
		      (T <RFALSE>)>)
	       (<L? 0 .N>
		<TELL "\"I'm too ">
		<COND (<1? .N> <TELL "peeved">) (T <TELL "angry">)>
		<TELL " with you now.\"" CR>
		<RTRUE>)
	       (<VERB? NO THANK YES>
		<RFATAL>		;"let thru to next handler")
	       (<VERB? FOLLOW WALK-TO>
		<COND (<AND <VERB? WALK-TO>
			    <DOBJ? SLEEP-GLOBAL ;BED>>
		       <RFATAL>)
		      (T
		       <TELL
"\"I will go where I please, thank you very much.\"" CR>
		       <RTRUE>)>)
	       (<VERB? INVENTORY>
		<COND (<NOT <CARRY-CHECK .PER>>
		       <TELL He+verb .PER "is" "n't holding anything." CR>)>
		<RTRUE>)
	       (<VERB? LISTEN>
		<COND (<OR <DOBJ? PLAYER>
			   <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
		       <TELL "\"I'm trying to!\"" CR>
		       <RTRUE>)
		      (T <RFALSE>)>)
	       (<VERB? RUB>
		<FACE-RED>
		<RTRUE>)>
	 <COND ;(<AND <VERB? DANCE> <DOBJ? PLAYER>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,PRSA .PER>
		<RTRUE>)
	       (<OR ;<VERB? DANCE>
		    <AND <VERB? WALK>
			 <DOBJ? P?OUT>>>
		<RFATAL> ;"let thru to next handler")
	       (<VERB? KISS>
		<UNSNOOZE .PER>
		<TELL
"\"I really don't think this is the proper time or place.\"" CR>)
	       ;(<VERB? WALK-TO>
		<COND (<DOBJ? HERE GLOBAL-HERE>
		       <TELL "\"I am here!\"" CR>)>)
	       (<VERB? TAKE ;"GET SEND SEND-TO BRING">
		<COND (<IN? ,PRSO ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?GIVE ,PRSO .PER>
		       <RTRUE>)>)
	       (<VERB? EXAMINE LOOK-INSIDE READ>
		<COND (<IN? ,PRSO ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?SHOW .PER ,PRSO>
		       <RTRUE>)>)
	       (<AND <VERB? GIVE THROW-AT> <FSET? ,PRSI ,PERSONBIT>>
		<SETG WINNER ,PRSI>
		<PERFORM ,V?ASK-FOR .PER ,PRSO>
		<RTRUE>)
	       (<AND <VERB? SGIVE> <FSET? ,PRSO ,PERSONBIT>>
		<SETG WINNER ,PRSO>
		<PERFORM ,V?ASK-FOR .PER ,PRSI>
		<RTRUE>)
	       (<VERB? HELP>
		<COND (<EQUAL? ,PRSO <> ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PER>
		       <RTRUE>)
		      (T <RFATAL>)>)
	       (<VERB? FIND SHOW SSHOW>
		<COND (<VERB? SHOW>
		       <SETG PRSA ,V?SSHOW>
		       <SET N ,PRSI>
		       <SETG PRSI ,PRSO>
		       <SETG PRSO .N>)>
		<COND (<IN? ,PRSO ,ROOMS>	;"SHOW ME MY ROOM"
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?WALK-TO ,PRSO>
		       <RTRUE>)
		      (<IN? ,PRSO .PER>
		       <COND (<==? <ITAKE> T>
			      <TELL
He .PER " fumbles in" his .PER " pocket and produces" him ,PRSO "." CR>)>
		       <RTRUE>)
		      (<VERB? FIND>
		       ;<SETG WINNER ,PLAYER>
		       ;<PERFORM ,PRSA ,PRSO>
		       <RFATAL>)>)
	       (<VERB? TELL>
		<COND (<DOBJ? PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PER>
		       <RTRUE>)>)
	       (<VERB? TELL-ABOUT>
		<COND (<FSET? ,PRSO ,PERSONBIT>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK-ABOUT .PER ,PRSI>
		       ;<SETG WINNER .PER>
		       <RTRUE>)>)
	       (<VERB? STOP WAIT-FOR>
		<COND (<DOBJ? HERE GLOBAL-HERE PLAYER ROOMS>
		       <COND (<==? .PER ,FOLLOWER>
			      <SETG FOLLOWER 0>
			      <TELL "\"As you wish.\"" CR>)
			     (T
			      <SETG WINNER ,PLAYER>
			      <PERFORM ,V?$CALL .PER>
			      <RTRUE>)>)>)
	       (<VERB? ;WHAT TALK-ABOUT>
		<SETG WINNER ,PLAYER>
	        <PERFORM ,V?ASK-ABOUT .PER ,PRSO>
		<RTRUE>)>>

<ROUTINE COMMON-ASK-ABOUT (PER OBJ)
 <COND (<EQUAL? .OBJ .PER>
	<TELL "\"I have no secrets. Anyone can see what I am.\"" CR>)
       (<EQUAL? .OBJ ,PLAYER>
	<TELL "\"You're Arthur Dent, the next-to-last Earthling.\"" CR>)
       (<FSET? .OBJ ,PERSONBIT>
	<RFALSE>)
       (<EQUAL? .OBJ ,OBJECT-OF-GAME>
	<TELL
"\"Oh...you're trying to figure that out also? The
manual's not much help, is it? By the way, do you know your score? I don't.
My computer doesn't have a status line.\"" CR>)
       (<IN? .OBJ .PER>
	<TELL "\"I have it right here.\"" CR>)>>

<ROUTINE COMMON-OTHER (PER "AUX" (X <>) N)
 <COND (<VERB? ASK> <RFALSE>)
       (<VERB? EXAMINE>
	<TELL <GETP .PER ,P?TEXT> CR>
	<COND (<AND <IN? .PER ,HERE>
		    <SET N <FIRST? .PER>>
		    <NOT <FSET? .N ,NDESCBIT>>>
	       <COND (<CARRY-CHECK .PER>
		      <SET X T>)>)>
	<COND (<FSET? .PER ,MUNGBIT>
	       <COND (<NOT <ZERO? .X>> <TELL "And">)>
	       <HE-SHE-IT .PER <NOT .X> "is">
	       <TELL !\  <GET ,LDESC-STRINGS <GETP .PER ,P?LDESC>> "." CR>)>
	<RTRUE>)
       (<AND <EQUAL? ,PRSO .PER> <VERB? SHOW>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI>
	<RTRUE>)>>
