"VERBS for MILLIWAYS
Copyright (C) 1988 Infocom, Inc.  All rights reserved."

<ROUTINE TRANSCRIPT (STR)
	<TELL "Here " .STR "s a transcript of interaction with" CR>>

<ROUTINE V-SCRIPT ()
	<LOWCORE FLAGS <BOR <LOWCORE FLAGS> 1>>
	<TRANSCRIPT "begin">
	<V-VERSION>
	<RTRUE>>

<ROUTINE V-UNSCRIPT ()
	<TRANSCRIPT "end">
	<V-VERSION>
	<LOWCORE FLAGS <BAND <LOWCORE FLAGS> -2>>
	<RTRUE>>

<ROUTINE V-$ID ()
	 <TELL "Interpreter ">
	 <PRINTN <LOWCORE INTID>>
	 <TELL " Version ">
	 <PRINTC <LOWCORE INTVR>>
	 <CRLF>
	 <RTRUE>>

<ROUTINE V-$VERIFY ()
 <COND (<T? ,PRSO>
	<COND (<AND <EQUAL? ,PRSO ,INTNUM>
		    <EQUAL? ,P-NUMBER 105>>
	       <TELL N ,SERIAL CR>)
	      (T <DONT-UNDERSTAND>)>)
       (T
	<TELL "Verifying disk..." CR>
	<COND (<VERIFY> <TELL "The disk is correct." CR>)
	      (T <TELL
"Oh, oh! The disk seems to have a defect. Try verifying again. (If
you've already done that, the disk surely has a defect.)" CR>)>)>>

%<DEBUG-CODE [
<ROUTINE V-$CHEAT ("AUX" (N 0) CH)
	 <COND (<OR <NOT <DOBJ? INTNUM>>
		    <NOT <EQUAL? ,P-NUMBER 1 2 3>>>
		<SETG CLOCK-WAIT T>
		<TELL "{Try $CHEAT 1, 2 or 3.}" CR>
		<RTRUE>)>
	 <COND (<NOT <ZERO? ,MOVES>>
		<TELL "Don't you want to restart first?">
		<COND (<YES?> <RESTART>)
		      (T <TELL "Okay, but this may not work!" CR>)>)>>

<GLOBAL IDEBUG:FLAG <>>
<CONSTANT G-DEBUG 4>

<ROUTINE V-$QUEUE ("AUX" C E TICK)
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E> <RETURN>)
		       (<AND <NOT <ZERO? <GET .C ,C-ENABLED?>>>
			     <NOT <ZERO? <SET TICK <GET .C ,C-TICK>>>>>
			<APPLY <GET .C ,C-RTN> ,G-DEBUG>
			<PRINTC 9>
			<TELL N .TICK CR>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<ROUTINE V-$COMMAND ()
	 <DIRIN 1>
	 <RTRUE>>

<ROUTINE V-$RANDOM ()
	 <COND (<NOT <DOBJ? INTNUM>>
		<TELL "Illegal." CR>)
	       (T
		<RANDOM <- 0 ,P-NUMBER>>
		<RTRUE>)>>

<ROUTINE V-$RECORD ()
	 <DIROUT ,D-RECORD-ON> ;"all READS and INPUTS get sent to command file"
	 <RTRUE>>

<ROUTINE V-$UNRECORD ()
	 <DIROUT ,D-RECORD-OFF>
	 <RTRUE>>
]>

"ZORK game commands"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSITY:NUMBER 1>	"0=SUPERB 1=BRIEF 2=VERBOS"

<ROUTINE YOU-WILL-GET (STR)
	<TELL "[Okay, you will get " .STR " descriptions.]" CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG VERBOSITY 0>
	 <YOU-WILL-GET "superbrief">>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSITY 1>
	 <YOU-WILL-GET "brief">>

<ROUTINE V-VERBOSE ()
	<SETG VERBOSITY 2>
	<YOU-WILL-GET "verbose">
	<CRLF>
	<V-LOOK>>

<ROUTINE V-INVENTORY ()
	;<COND (<ZERO? ,LIT>
	       <TOO-DARK>
	       <RFATAL>)>
	<TELL He+verb ,WINNER "is" " holding">
	<COND (<ZERO? <PRINT-CONTENTS ,WINNER>>	;"was PRINT-CONT"
	       <TELL " nothing">)>
	<TELL !\.>
	<COND ;(<AND <==? ,WINNER ,PLAYER>
		    <T? ,NOW-WEARING>>
	       <TELL !\ >
	       <PERFORM ,V?LOOK-INSIDE ,POCKET>)
	      (T <CRLF>)>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T))
	 <V-SCORE>
	 <COND (<NOT .ASK?> <QUIT>)>
	 <TELL
"[If you want to continue from this point at another time, you must
\"SAVE\" first. Do you want to stop the story now?]">
	 <COND (<YES?> <QUIT>)
	       (T <TELL "Okay." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE>
	 <TELL "[Do you want to start over from the beginning?]">
	 <COND (<YES?>
		<RESTART>
		<TELL-FAILED>)
	       (T <TELL "Okay." CR>)>>

<ROUTINE TELL-FAILED ()
	<TELL
"[Sorry, but it didn't work. Maybe your instruction manual or Reference
Card can tell you why.]" CR>>

<ROUTINE V-SAVE ("AUX" X)
	 <PUTB ,G-INBUF 1 0>
	 <SETG CLOCK-WAIT T>
	 <SET X <SAVE>>
	 <COND (<OR <EQUAL? .X 2>
		    <BTST <LOWCORE FLAGS> 4>>
		<V-$REFRESH>)>
	 <COND (<ZERO? .X>
		<TELL-FAILED>
		<RFATAL>)
	       (T
	        <TELL "[Okay.]" CR>
		<COND (<NOT <EQUAL? .X 1>>
		       <V-FIRST-LOOK>)>
		<RTRUE>)>>

<ROUTINE V-RESTORE ()
	 <COND (<NOT <RESTORE>>
		<TELL-FAILED>
		<RFALSE>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT <0? ,VERBOSITY>>
		       <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-VERSION ()
	 <TELL "MILLIWAYS|
Infocom interactive science fiction|
Copyright (c) 1988 by Infocom, Inc.  All rights reserved.|
Release number " N <BAND <LOWCORE ZORKID> *3777*> " / Serial number ">
	 <LOWCORE-TABLE SERIAL 6 PRINTC>
	 <CRLF>>

<CONSTANT SCORE-MAX 400>
<ROUTINE V-SCORE ()
	 <TELL
"Your score is " N ,SCORE " of a possible " N ,SCORE-MAX ", in " N ,MOVES
" turn">
	 <COND (<1? ,MOVES>
		<TELL ".">)
	       (T
		<TELL "s.">)>
	 <CRLF>
	 ,SCORE>

<ROUTINE NO-NEED ("OPTIONAL" (STR <>) (OBJ <>))
	<SETG CLOCK-WAIT T>
	<TELL !\( He+verb ,WINNER "do" "n't need to ">
	<COND (.STR <TELL .STR>) (T <VERB-PRINT>)>
	<COND (<EQUAL? .STR "go" "drive">
	       <TELL " in that " D ,INTDIR>)
	      (<T? .OBJ>
	       <TELL the .OBJ>)
	      (T <TELL the ,PRSO>)>
	<TELL ".)" CR>>

<ROUTINE YOU-CANT ("OPTIONAL" (STR <>) (WHILE <>) (STR1 <>))
	<SETG CLOCK-WAIT T>
	<TELL !\( He ,WINNER " can't ">
	<COND (<ZERO? .STR>
	       <VERB-PRINT>)
	      (T <TELL .STR>)>
	<COND (<EQUAL? .STR "go" "drive">
	       <TELL " in that " D ,INTDIR>)
	      (T
	       <COND (<==? ,PRSO ,PSEUDO-OBJECT>
		      <TELL " it">)
		     (<AND <DOBJ? FLOOR>
			   <OUTSIDE? ,HERE>>
		      <TELL " the ground">)
		     (T <TELL the ,PRSO>)>
	       <COND (.STR1
		      <TELL " while">
		      <COND (.WHILE
			     <TELL he+verb .WHILE "is">)
			    (T <TELL he+verb ,PRSO "is">)>
		      <TELL !\  .STR1>)
		     ;(T <TELL " now">)>)>
	<TELL ".)" CR>>

;<ROUTINE YOU-SHOULDNT ("OPT" (PREP <>))
	<SETG CLOCK-WAIT T>
	<TELL !\( He ,WINNER " shouldn't ">
	<VERB-PRINT>
	<TELL the ;him ,PRSO>
	<COND (<T? .PREP>
	       <TELL .PREP the ,PRSI>)>
	<TELL ".)" CR>>

""

"SUBTITLE - GENERALLY USEFUL ROUTINES & CONSTANTS"

<ROUTINE TELL-BEING-WORN (OBJ)
	<COND (<FSET? .OBJ ,WORNBIT>
	       <TELL " (actually, wearing it)">)
	      ;(<AND <FSET? .OBJ ,ONBIT>
		    <NOT <EQUAL? ,LIT ,HERE ;1>>>
	       <TELL " (providing light)">)>>

<GLOBAL YAWNS <LTABLE 0 "unusual" "interesting" "extraordinary" "special">>

<ROUTINE PRINT-CONTENTS (CONT "AUX" OBJ NXT (1ST? T) (VAL <>))
	 <SET OBJ <FIRST? .CONT>>
	 <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <FSET? .OBJ ,NDESCBIT> ;"was semied"
				  <EQUAL? .OBJ ,WINNER ;,NOW-WEARING>>
			      <MOVE .OBJ ,INTDIR>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
	 <SET OBJ <FIRST? .CONT>>
	 <COND (<NOT .OBJ>
		<COND (<NOT <==? .CONT ,PLAYER>>
		       <TELL " nothing " <PICK-ONE-NEW ,YAWNS>>)>)
	       (T
		<REPEAT ()
		        <COND (.OBJ
		               <SET NXT <NEXT? .OBJ>>
		               <COND (.1ST?
			              <SET VAL T>
				      <SET 1ST? <>>)
			             (T
			              <COND (.NXT <TELL !\,>)
				            (T <TELL " and">)>)>
		               <TELL the .OBJ>
		               <TELL-BEING-WORN .OBJ>
			       <THIS-IS-IT .OBJ>
		               <FCLEAR .OBJ ,SECRETBIT>
			       <FSET .OBJ ,SEENBIT>
			       <SET OBJ .NXT>)
			      (T
		               <RETURN>)>>)>
	 <ROB ,INTDIR .CONT>
	 .VAL>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (CONT <>)
			   "AUX" OBJ NXT STR (VAL <>) (HE 0) (SHE 0)
				 (FIRST T) (TWO? <>) (IT? <>) (ANY? <>))
	 <COND (<ZERO? .CONT>
		<SET CONT ,HERE>)>
	 <COND (<ZERO? ,LIT>
	        <TOO-DARK>
	        <RTRUE>)>
      ;"Hide invisible objects"
	<SET OBJ <FIRST? .CONT>>
	<COND (<ZERO? .OBJ>
	       <RFALSE>)>
	<REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <FSET? .OBJ ,NDESCBIT>
				  <EQUAL? .OBJ ,WINNER>
				  <AND <FSET? .OBJ ,PERSONBIT>
				       <OR <FSET? .OBJ ,RMUNGBIT>;"not desc'd"
					   ;<IN-MOTION? .OBJ>>>
				  <EQUAL? .OBJ <LOC ,PLAYER>>>
			      <FCLEAR .OBJ ,RMUNGBIT>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
      <COND (<EQUAL? .CONT ,HERE>
	;"Describe people in proper order:"
       <SET NXT ,CHARACTER-MAX>
       <REPEAT ()
	       <PUT ,TOUCHED-LDESCS .NXT 0>
	       <COND (<DLESS? NXT 1> <RETURN>)>>
       <SET NXT 0>
       <REPEAT ()
	       <COND (<IGRTR? NXT ,CHARACTER-MAX>
		      <RETURN>)
		     (<IN? <SET OBJ <GET ,CHARACTER-TABLE .NXT>> ,HERE>
		      <PUT ,FOLLOW-LOC .NXT ,HERE>
		      <SET VAL <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		      <FSET .OBJ ,SEENBIT>
		      <COND (<OR <==? .VAL ,M-FATAL>
				 <ZERO? .ANY?>>
			     <SET ANY? .VAL>)>
		      <COND (<FSET? .OBJ ,FEMALEBIT>
			     <COND (<0? .SHE> <SET SHE .OBJ>)
				   (T <SET SHE 1>)>)
			    (T
			     <COND (<0? .HE> <SET HE .OBJ>)
				   (T <SET HE 1>)>)>
		      <MOVE .OBJ ,PSEUDO-OBJECT>)>>
       <SET NXT 0>
       <REPEAT ()
	       <COND (<IGRTR? NXT ,CHARACTER-MAX>
		      <RETURN>)
		     (<T? <SET OBJ <GET ,TOUCHED-LDESCS .NXT>>>
		      ;<PUT ,TOUCHED-LDESCS .NXT 0>
		      <SET FIRST T>
		      <SET STR <GET ,CHARACTER-TABLE .NXT>>
		      <TELL The .STR>
		      <SET STR .NXT>
		      <REPEAT ()
			      <COND (<IGRTR? STR ,CHARACTER-MAX>
				     <COND (.FIRST <TELL " is ">)
					   (T <TELL " are ">)>
				     <TELL <GET ,LDESC-STRINGS .OBJ> !\. CR>
				     <RETURN>)
				    (<==? .OBJ <GET ,TOUCHED-LDESCS .STR>>
				     <PUT ,TOUCHED-LDESCS .STR 0>
				     <SET FIRST <>>
				     <TELL " and" the
					   <GET ,CHARACTER-TABLE .STR>>)>>)>>
	<COND (<NOT <EQUAL? .SHE 0 1>>
	       <THIS-IS-IT .SHE>)
	      (<EQUAL? .SHE 1>
	       <SETG P-HER-OBJECT <>>)>
	<COND (<NOT <EQUAL? .HE 0 1>>
	       <THIS-IS-IT .HE>)
	      (<EQUAL? .HE 1>
	       <SETG P-HIM-OBJECT <>>)>
	<SET FIRST T>
	; "Apply all DESCFCNs and hide those objects"
       <SET OBJ <FIRST? .CONT>>
       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?DESCFCN>>
		       <COND (.STR
		              ;<CRLF>
			      <SET VAL <APPLY .STR ,M-OBJDESC>>
			      <COND (<OR <==? .VAL ,M-FATAL>
					 <ZERO? .ANY?>>
				     <SET ANY? .VAL>)>
			      <THIS-IS-IT .OBJ>
			      <FSET .OBJ ,SEENBIT>
			      ;<CRLF>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
      ;"Apply all FDESCs and eliminate those objects"
	<SET OBJ <FIRST? .CONT>>
	<REPEAT ()
		<COND (<AND .OBJ
			    <NOT <FSET? .OBJ ,TOUCHBIT>>>
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?FDESC>>
		       <COND (.STR
			      ;<SET VAL T>
			      <COND (<ZERO? .ANY?> <SET ANY? T>)>
			      <TELL ;CR .STR CR>
			      <FCLEAR .OBJ ,SECRETBIT>
			      <FSET .OBJ ,SEENBIT>
			      <THIS-IS-IT .OBJ>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
       ;"Apply all LDESC's and eliminate those objects"
       <SET OBJ <FIRST? .CONT>>
       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?LDESC>>
		       <COND (.STR
		              ;<SET VAL T>
			      <COND (<ZERO? .ANY?> <SET ANY? T>)>
			      <TELL ;CR .STR CR>
			      <FCLEAR .OBJ ,SECRETBIT>
			      <FSET .OBJ ,SEENBIT>
			      <THIS-IS-IT .OBJ>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>)>
       ;"Print whatever's left in a nice sentence"
	<SET OBJ <FIRST? ,HERE>>
	<SET VAL <>>
	<COND (.OBJ
	       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET VAL T>
		       <COND (.FIRST
			      <SET FIRST <>>
			      ;<CRLF>
			      <COND (<EQUAL? .CONT ,HERE>
				     <CRLF>
				     <COND (<FSET? ,HERE ,ONBIT>
					    <TELL "You see">)
					   ;(<OR <FIND-IN ,WINNER ,ONBIT>
						<FIND-IN ,HERE ,ONBIT>>
					    <TELL
His ,WINNER " light reveals">)
					   (T <TELL
"The light reveals" ;" from the next room">)>)>)
			     (T
			      <COND (.NXT <TELL !\,>)
				    (T <TELL " and">)>)>
		       <TELL the .OBJ>
		       <FCLEAR .OBJ ,SECRETBIT>
		       <FSET .OBJ ,SEENBIT>
		       <THIS-IS-IT .OBJ>
		       <TELL-BEING-WORN .OBJ>	
		       <COND (<AND <SEE-INSIDE? .OBJ>
				   <SEE-ANYTHING-IN? .OBJ>>
			      <MOVE .OBJ ,INTNUM>)>
		       <COND (<AND <NOT .IT?>
				   <NOT .TWO?>>
			      <SET IT? .OBJ>)
			     (T
			      <SET TWO? T>
			      <SET IT? <>>)>
		       <SET OBJ .NXT>)
		      (T
		       <COND (<AND .IT?
				   <NOT .TWO?>>
			      <SETG P-IT-OBJECT .IT?>)>
		       <COND (<EQUAL? .CONT ,HERE>
			      <TELL " here">)>
		       <TELL !\.>
		       <COND (<ZERO? .ANY?> <SET ANY? T>)>
		       <RETURN>)>>)>
	<SET OBJ <FIRST? ,INTNUM>>
	<REPEAT ()
		<COND (<ZERO? .OBJ>
		       <RETURN>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL ;CR CR "On">)
		      (T
		       <TELL ;CR CR "Inside">)>
		<SET VAL T>
		<TELL the .OBJ>
		<TELL " you see">
		<PRINT-CONTENTS .OBJ>
		<TELL !\.>
		<SET OBJ <NEXT? .OBJ>>>
	<COND (<T? .VAL ;.ANY?> <CRLF>)>
	<ROB ,INTNUM .CONT>
	<ROB ,PSEUDO-OBJECT .CONT>
	.ANY? ;.VAL>

<ROUTINE SEE-ANYTHING-IN? (CONT "AUX" OBJ NXT (ANY? <>))
	 <SET OBJ <FIRST? .CONT>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<AND <NOT <FSET? .OBJ ,INVISIBLE>>
				    <NOT <FSET? .OBJ ,NDESCBIT>>
				    <NOT <EQUAL? .OBJ ,WINNER>>>
			       <SET ANY? T>
			       <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <RETURN .ANY?>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR L)
	 <COND (<T? .LOOK?> <SET V? T>)
	       (<==? 2 ,VERBOSITY> <SET V? T>)
	       (<==? 0 ,VERBOSITY> <SET V? <>>)
	       (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<SET V? T>)>
	 <COND (T ;<IN? ,HERE ,ROOMS>
		<TELL !\(>
		<COND (<ZERO? ,VERBOSITY>
		       <TELL D ,HERE>)
		      (T
		       <TELL "You are">
		       <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
			      <TELL " now">)>
		       <COND (<FSET? ,HERE ,SURFACEBIT>
			      <TELL " on">)
			     (T ;<NOT <==? ,HERE ,BACKSTAIRS>>
			      <TELL " in">)>
		       <TELL the ,HERE !\.>)>
		<TELL ")|">)>
	 <COND (<ZERO? ,LIT>
		<TOO-DARK>
		;<TELL "It is pitch black." CR>
		<RFALSE>)
	       (<NOT <EQUAL? ,LIT ,HERE>>
		;<1? ,LIT>	;<NOT <FSET? ,HERE ,ONBIT>>
		<TELL "Light comes from" the ,LIT ;" the next room" "." CR>)>
	 <COND (.V?
		<COND (<FSET? <SET L <LOC ,WINNER>> ,VEHBIT>
		       <TELL "(You're ">
		       <COND ;(<EQUAL? .L ,COFFIN> <TELL "ly">)
			     (T <TELL "sitt">)>
		       <TELL "ing on">
		       <THIS-IS-IT .L>
		       <TELL the .L ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       T)
		      (<AND .V? <SET STR <GETP ,HERE ,P?FDESC>>>
		       <TELL .STR CR>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		;<COND (<NOT <==? ,HERE .L>>
		       <APPLY <GETP .L ,P?ACTION> ,M-LOOK>)>)>
	 ;<COND (<GETP ,HERE ,P?CORRIDOR>
		<CORRIDOR-LOOK>)>
	 <FSET ,HERE ,SEENBIT>
	 <FSET ,HERE ,TOUCHBIT>
	 T>

"Lengths:"
<CONSTANT REXIT 0>
<CONSTANT UEXIT <VERSION? (ZIP 1) (T 2)>>
	"Uncondl EXIT:	(dir TO rm)		 = rm"
<CONSTANT NEXIT <VERSION? (ZIP 2) (T 3)>>
	"Non EXIT:	(dir ;SORRY string)	 = str-ing"
<CONSTANT FEXIT <VERSION? (ZIP 3) (T 4)>>
	"Fcnl EXIT:	(dir PER rtn)		 = rou-tine, 0"
<CONSTANT CEXIT <VERSION? (ZIP 4) (T 5)>>
	"Condl EXIT:	(dir TO rm IF f)	 = rm, f, str-ing"
<CONSTANT DEXIT <VERSION? (ZIP 5) (T 6)>>
	"Door EXIT:	(dir TO rm IF dr IS OPEN)= rm, dr, str-ing, 0"

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG <VERSION? (ZIP 1) (T 4)>>	"GET/B"
<CONSTANT CEXITSTR 1>		"GET"
<CONSTANT DEXITOBJ 1>		"GET/B"
<CONSTANT DEXITSTR <VERSION? (ZIP 1) (T 2)>>	"GET"

<ROUTINE HAR-HAR ()
	<SETG CLOCK-WAIT T>
	<TELL <PICK-ONE-NEW ,YUKS> CR>>

<GLOBAL YUKS
 <LTABLE 0
	 "What a concept."
         "Nice try."
	 "You can't be serious."
	 "Not bloody likely.">>

<ROUTINE IMPOSSIBLE ()
	<SETG CLOCK-WAIT T>
	<TELL <PICK-ONE-NEW ,IMPOSSIBLES> CR>>

<GLOBAL IMPOSSIBLES
 <LTABLE 0
	 "You have lost your mind."
	 "You are clearly insane."
	 "You appear to have gone barking mad."
	 "I'm not convinced you're allowed to be playing with this computer."
	 "Run out on the street and say that. See what happens."
	 "No, no, a thousand times no. Go boil an egg.">>

;<ROUTINE WONT-HELP ()
	<SETG CLOCK-WAIT T>
	<TELL "(That won't help solve this case!)" CR>>

<ROUTINE WONT-HELP ()
	<SETG CLOCK-WAIT T>
	<TELL <PICK-ONE-NEW ,WASTES> CR>>

<GLOBAL WASTES
 <LTABLE 0
	 "Complete waste of time."
	 "Useless. Utterly useless."
	 "A totally unhelpful idea.">>

<ROUTINE PICK-ONE-NEW (FROB "AUX" L CNT RND MSG RFROB)
	 <SET L <- <GET .FROB 0> 1>>
	 <SET CNT <GET .FROB 1>>
	 <SET FROB <REST .FROB 2>>
	 <SET RFROB <REST .FROB <* .CNT 2>>>
	 <SET RND <- .L .CNT>>
	 <SET RND <RANDOM .RND>>
	 %<DEBUG-CODE
	   <COND (<NOT <G? .RND 0>>
		  <TELL
"{PICK-ONE-NEW: L=" N .L " CNT=" N .CNT " RND=" N .RND " FROB="N .FROB"}"CR>)>>
	 <SET MSG <GET .RFROB .RND>>
	 <PUT .RFROB .RND <GET .RFROB 1>>
	 <PUT .RFROB 1 .MSG>
	 <SET CNT <+ .CNT 1>>
	 <COND (<==? .CNT .L> <SET CNT 0>)>
	 <PUT .FROB 0 .CNT>
	 .MSG>

<ROUTINE PICK-ONE (FROB) <GET .FROB <RANDOM <GET .FROB 0>>>>

<ROUTINE NOT-HOLDING? (OBJ)
	<COND (<AND <NOT <IN? .OBJ ,WINNER>>
		    <NOT <IN? <LOC .OBJ> ,WINNER>>>
	       <SETG CLOCK-WAIT T>
	       <TELL
!\( He+verb ,WINNER "is" " not holding" him .OBJ ".)" CR>)>>

<ROUTINE GOTO (RM "OPTIONAL" (TEST T) (FOLLOW? T) "AUX" X)
	<COND (<IN? ,WINNER .RM>
	       <WALK-WITHIN-ROOM>
	       <RFALSE>)>
	<COND (<APPLY <GETP ,HERE ,P?ACTION> ,M-LEAVE>
	       <RFALSE>)
	      (<==? ,WINNER ,PLAYER>
	       <COND (<AND .FOLLOW?
			   <T? ,FOLLOWER>>
		      <FRIEND-FOLLOWS-YOU .RM>)>)
	      ;(<FSET? ,WINNER ,MUNGBIT>
	       <TELL "\"I wish I could!\"" CR>
	       <RFALSE>)
	      ;(<FSET? .RM ,SECRETBIT>
	       <NOT-INTO-PASSAGE ,WINNER>
	       <RFALSE>)
	      ;(<EQUAL? .RM ,YOUR-BATHROOM>
	       <NOT-INTO-PASSAGE ,WINNER <> <>>
	       <RFALSE>)>
	<COND (<AND <T? .TEST>
		    <==? ,WINNER ,PLAYER>>
	       <SET X <DIR-FROM ,HERE .RM>>
	       <COND (<T? .X>
		      <COND (<==? ,M-FATAL <APPLY <GETP ,HERE ,P?ACTION> .X>>
			     <RFALSE>)>)>)>
	<PUT ,FOLLOW-LOC <GETP ,WINNER ,P?CHARACTER> .RM>
	<MOVE ,WINNER .RM>
	<COND (<==? ,WINNER ,PLAYER>
	       <SETG OHERE ,HERE>
	       <SETG HERE .RM>
	       <MAKE-ALL-PEOPLE -12 ;"listening to you">
	       <ENTER-ROOM>
	       <RTRUE>)
	      (T <RTRUE>)>>

<ROUTINE MAKE-ALL-PEOPLE (NUM "OPTIONAL" (RM 0) "AUX" P NNUM)
	<COND (<ZERO? .RM>
	       <SET RM ,HERE>)>
	<COND (<L? .NUM 0>
	       <SET NNUM <- 0 .NUM>>)>
	<SET P <FIRST? .RM>>
	<REPEAT ()
		<COND (<ZERO? .P>
		       <RETURN>)
		      (<FSET? .P ,PERSONBIT>
		       <COND (<G? .NUM 0>
			      <PUTP .P ,P?LDESC .NUM>)
			     (<==? .NNUM <GETP .P ,P?LDESC>>
			      <PUTP .P ,P?LDESC 0>)>)>
		<SET P <NEXT? .P>>>>

<GLOBAL FOLLOWER:OBJECT 0>

;<ROUTINE NEW-FOLLOWER (PER)
	<COND (<NOT <EQUAL? ,FOLLOWER <> .PER>>
	       <PUTP ,FOLLOWER ,P?LDESC 0>
	       <TELL
"\"I'll leave you two alone, then,\" says " D ,FOLLOWER ".|">)>
	<SETG FOLLOWER .PER>>

<ROUTINE FRIEND-FOLLOWS-YOU (RM "AUX" C)
 <COND ;(<ZERO? <GETP .RM ,P?LINE>>
	<RFALSE>)
       (<IN? ,FOLLOWER .RM>
	<RFALSE>)
       (T
	<MOVE ,FOLLOWER .RM>
	<PUTP ,FOLLOWER ,P?LDESC 23 ;"following you">
	<TELL D ,FOLLOWER>
	<TELL <PICK-ONE ,TRAILS-ALONG>>
	<CRLF>)>>

<GLOBAL TRAILS-ALONG
 <PLTABLE " walks a few steps behind."
	" trails along."
	" stays at your side."
	" walks along with you.">>

<ROUTINE DIR-FROM (HERE THERE "AUX" (V <>) P D)
 <COND (<DIR-FROM-TEST .HERE .THERE ,P?UP>	<RETURN ,P?UP>)
       (<DIR-FROM-TEST .HERE .THERE ,P?DOWN>	<RETURN ,P?DOWN>)
       (<DIR-FROM-TEST .HERE .THERE ,P?IN>	<RETURN ,P?IN>)
       (<DIR-FROM-TEST .HERE .THERE ,P?OUT>	<RETURN ,P?OUT>)>
 <SET P 0>
 <REPEAT ()
	 <COND (<L? <SET P <NEXTP .HERE .P>> ,LOW-DIRECTION>
		<RETURN .V>)
	       (<SET D <DIR-FROM-TEST .HERE .THERE .P>>
		<COND (<AND <L? .D ,LOW-DIRECTION> <NOT .V>>
		       <SET V .P>)
		      (T <RETURN .P>)>)>>>

<ROUTINE DIR-FROM-TEST (HERE THERE P "AUX" L TBL)
	<COND (<ZERO? <SET TBL <GETPT .HERE .P>>>
	       <RFALSE>)>
	<SET L <PTSIZE .TBL>>
	<COND (<AND <EQUAL? .L ,DEXIT ,UEXIT ,CEXIT>
		    <==? <GET/B .TBL ,REXIT> .THERE>>
	       <RETURN .P>)>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR him ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<PLTABLE
	 " won't help any."
	 " is a waste of time.">>

<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>) "AUX" L)
	 <COND (<ZERO? .CONT> <SET CONT ,PLAYER ;,WINNER>)>
	 <REPEAT ()
		 <SET L <LOC .OBJ>>
		 <COND (<NOT .L> <RFALSE>)
		       (<EQUAL? .L .CONT> <RTRUE>)
		       (<EQUAL? .CONT ,PLAYER ,WINNER>
			<COND (<EQUAL? .OBJ ,HANDS ,HEAD ,EYES>
			       <RTRUE>)
			      ;(<EQUAL? .OBJ ,NOW-WEARING>
			       <RTRUE>)
			      ;(<AND <EQUAL? .OBJ ,ARTIFACT>
				    <EQUAL? ,WINNER .L <LOC .L>>>
			       <RTRUE>)
			      (T <SET OBJ .L>)>)
		       (<EQUAL? .L ,ROOMS ,GLOBAL-OBJECTS> <RFALSE>)
		       (T <SET OBJ .L>)>>>

<ROUTINE IDROP ()
	 <COND ;(<FSET? ,PRSO ,PERSONBIT>
		<TELL The ,PRSO " wouldn't enjoy that." CR>
		<RFALSE>)
	       (<NOT-HOLDING? ,PRSO>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TOO-BAD-BUT <LOC ,PRSO> "closed">
		<RFALSE>)
	       (T
		<MOVE ,PRSO ,HERE ;"<LOC ,WINNER>">
		<FCLEAR ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<RTRUE>)>>

;<GLOBAL INDENTS
	<PTABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

<GLOBAL FUMBLE-NUMBER:NUMBER 7>
<GLOBAL FUMBLE-PROB:NUMBER 8>
;<GLOBAL ITAKE-LOC:OBJECT <>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) (OB 0) "AUX" CNT OBJ L)
	 <COND (<ZERO? .OB>
		<SET OB ,PRSO>)>
	 <SET L <LOC .OB>>
	 <COND (<AND .L <FSET? .L ,PERSONBIT>>
		<COND (<AND <NOT <FSET? .OB ,TAKEBIT>>
			    <NOT <FSET? .L ,MUNGBIT>>>
		       <COND (.VB <YOU-CANT "take">)>
		       <RFALSE>)
		      (T <FSET .OB ,TAKEBIT>)>)>
	 <COND (<NOT <FSET? .OB ,TAKEBIT>>
		<COND (.VB <YOU-CANT "take">)>
		<RFALSE>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>
		     <SET OBJ <FIND-FLAG-NOT ,WINNER ,WORNBIT>>>
		<TOO-BAD-BUT>
		<TELL
the .OBJ " slips from" his ,WINNER " arms while" he+verb ,WINNER "is" " taking"
him .OB ", and both tumble " <GROUND-DESC> ". " He+verb ,WINNER "is"
" carrying too many things.|">
		<MOVE .OBJ ,HERE>	;<PERFORM ,V?DROP .OBJ>
		<MOVE ;-FROM .OB ,HERE>
		<RFATAL>)
	       (T
		<MOVE ;-FROM .OB ,WINNER>
		<FSET .OB ,SEENBIT>
		<FSET .OB ,TOUCHBIT>
		<FCLEAR .OB ,NDESCBIT>
		<FCLEAR .OB ,INVISIBLE>
		<FCLEAR .OB ,SECRETBIT>
		;<COND (<==? ,WINNER ,PLAYER> <SCORE-OBJ .OB>)>
		;<SETG ITAKE-LOC <>>
		<COND (<AND <NOT <VERB? TAKE>>
			    <NOT <==? .L ,WINNER>>
			    <OR <FSET? .L ,PERSONBIT>
				;<EQUAL? .L ,SIDEBOARD>>>
		       <FIRST-YOU "take" .OB .L>
		       ;<COND (<NOT .VB> <SETG ITAKE-LOC .L>)>)>
		<RTRUE>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<NOT <FSET? .X ,WORNBIT>>
			       <SET CNT <+ .CNT 1>>)>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

<ROUTINE CHECK-DOOR (DR)
	<TELL The .DR " is ">
	<THIS-IS-IT .DR>
	<COND (<FSET? .DR ,OPENBIT> <TELL "open">)
	      (T
	       <TELL "closed and ">
	       <COND (<NOT <FSET? .DR ,LOCKED>> <TELL "un">)>
	       <TELL "locked">)>
	<TELL "." CR>>

<ROUTINE ROOM-CHECK ("AUX" P PA)
	 <SET P ,PRSO>
	 <COND (<EQUAL? .P ,ROOMS>
		<RFALSE>)
	       (<IN? .P ,ROOMS>
		<COND (<EQUAL? ,HERE .P>
		       <RFALSE>)
		      (<OR ;<EQUAL? ,HERE <GETP .P ,P?STATION>>
			   <GLOBAL-IN? .P ,HERE>>
		       <COND (<AND <VERB? LIE SIT SEARCH SEARCH-FOR>
				   <NOT <==? <SET P <META-LOC .P>> ,HERE>>>
			      <FIRST-YOU "try to enter" .P>
			      <SET PA ,PRSA>
			      <SET P <PERFORM ,V?THROUGH .P>>
			      <SETG PRSA .PA>
			      <COND (<==? ,M-FATAL .P>
				     <RTRUE>)
				    (T <RFALSE>)>)
			     (T <RFALSE>)>)
		      (<NOT <SEE-INTO? .P>>
		       <RTRUE>)
		      (T <RFALSE>)>)
	       (<OR ;<==? .P ,PSEUDO-OBJECT>
		    <EQUAL? <META-LOC .P>
			    ,HERE ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>>
		<RFALSE>)
	       (<NOT <VISIBLE? .P>>
		<NOT-HERE .P>)>>

<ROUTINE SEE-INSIDE? (OBJ "OPTIONAL" (ONLY-IN <>))
	<COND ;(<FSET? .OBJ ,INVISIBLE> <RFALSE>)	;"for LIT? - PLAYER"
	      (<FSET? .OBJ ,TRANSBIT> <RTRUE>)
	      (<FSET? .OBJ ,OPENBIT> <RTRUE>)
	      (.ONLY-IN <RFALSE>)
	      (<FSET? .OBJ ,SURFACEBIT> <RTRUE>)>>

<ROUTINE ARENT-TALKING ()
	<SETG CLOCK-WAIT T>
	<TELL "(You aren't talking to anyone!)" CR>>

<ROUTINE ALREADY (OBJ "OPTIONAL" (STR <>))
	<SETG CLOCK-WAIT T>
	<TELL !\(>
	<COND ;(<NOUN-USED? .OBJ ,W?DOOR>	;"confusing in secret passage"
	       <TELL "The door">)
	      (T <TELL The .OBJ>)>
	<COND (<EQUAL? .OBJ ,PLAYER> <TELL " are">)
	      (T <TELL " is">)>
	<TELL " already ">
	<COND (.STR <TELL .STR "!)" CR>)>
	<RTRUE>>

<ROUTINE NOT-CLEAR-WHOM ()
	;<SETG QUOTE-FLAG <>>
	<SETG P-CONT <>>
	<TELL "[It's not clear whom you're talking to.]"
;"[To talk to someone, type their name, then a comma, then what you want
them to do.]" CR>>

<ROUTINE OKAY ("OPTIONAL" (OBJ <>) (STR <>))
	<COND (<EQUAL? ,WINNER ,PLAYER ;,BUTLER>
	       <COND (<VERB? THROUGH WALK WALK-TO>
		      <RTRUE>)>)
	      (T <TELL "\"">)>
	<TELL "Okay">
	<COND (.OBJ
	       <TELL !\, he .OBJ>
	       <COND (.STR <TELL " is now " .STR>)>
	       <COND (<=? .STR "on">		<FSET .OBJ ,ONBIT>)
		     (<=? .STR "off">		<FCLEAR .OBJ ,ONBIT>)
		     (<=? .STR "open">		<FSET .OBJ ,OPENBIT>)
		     (<=? .STR "closed">	<FCLEAR .OBJ ,OPENBIT>)
		     (<=? .STR "locked">	<FSET .OBJ ,LOCKED>)
		     (<=? .STR "unlocked">	<FCLEAR .OBJ ,LOCKED>)>)>
	<COND (<OR .STR <NOT .OBJ>>
	       <COND (<NOT <==? ,WINNER ,PLAYER>>
		      <TELL ",\" says " 'WINNER ". " He ,WINNER " does so."CR>
		      <RTRUE>)>
	       <TELL "." CR>)>
	<COND (<AND <ZERO? ,LIT>
		    <T? <SETG LIT <LIT? ;,HERE>>>>
	       <CRLF>
	       <V-LOOK>)>
	<RTRUE>>

<ROUTINE TOO-BAD-BUT ("OPTIONAL" (OBJ <>) (STR <>))
	<TELL "Too bad, but">
	<COND (.OBJ
	       <TELL he .OBJ>)>
	<COND (.STR
	       <TELL " is " .STR>
	       <COND (<EQUAL? .STR "angry" "peeved">
		      <TELL " with you">)>
	       <TELL "." CR>)>
	<RTRUE>>

<ROUTINE TOO-DARK () ;("OPTIONAL" (OBJ 0)) <TELL "(It's too dark to see!)" CR>>

"<ROUTINE NOT-ACCESSIBLE? (OBJ)
 <COND (<EQUAL? <META-LOC .OBJ> ,WINNER ,HERE ,GLOBAL-OBJECTS> <RFALSE>)
       (<VISIBLE? .OBJ> <RFALSE>)
       (T <RTRUE>)>>"

<ROUTINE VISIBLE? ;"can player SEE object?"
		  (OBJ "AUX" L)
	 <COND (<NOT .OBJ> <RFALSE>)
	       (<ACCESSIBLE? .OBJ> <RTRUE>)>
	 ;<COND (<CORRIDOR-LOOK .OBJ>
		<RETURN T>)>
	 <SET L <LOC .OBJ>>
	 <COND (<SEE-INSIDE? .L>
		<VISIBLE? .L>)>>

<ROUTINE ACCESSIBLE? (OBJ "AUX" L)	;"can player TOUCH object?"
	 <COND (<NOT .OBJ> <RFALSE>)
	       (T <SET L <LOC .OBJ>>)>
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<EQUAL? .OBJ ,PSEUDO-OBJECT>
		<COND (<EQUAL? ,LAST-PSEUDO-LOC ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       ;(<EQUAL? .OBJ ,CAR>
		<COND (<EQUAL? <GETP ,CAR ,P?STATION> ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<RTRUE>)	       
	       ;(<EQUAL? .L ,ROOMS>
		<RETURN <SEE-INTO? .OBJ <>>>)	       
	       (<EQUAL? .L ,LOCAL-GLOBALS>
		<RETURN <GLOBAL-IN? .OBJ ,HERE>>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE>
		<RTRUE>)
	       (<OR <FSET? .L ,OPENBIT>
		    <FSET? .L ,SURFACEBIT>
		    <FSET? .L ,PERSONBIT>>
		<ACCESSIBLE? .L>)
	       (T
		<RFALSE>)>>

<CONSTANT WHO-CARES-LENGTH 4>

<GLOBAL WHO-CARES-VERB
	<PLTABLE "do" "do" "let" "seem">>

<GLOBAL WHO-CARES-TBL
	<PLTABLE "n't appear interested"
		"n't care"
		" out a loud yawn"
		" impatient">>

<ROUTINE WHO-CARES ("AUX" N)
	<SET N <RANDOM ,WHO-CARES-LENGTH>>
	<HE-SHE-IT ,PRSO T <GET ,WHO-CARES-VERB .N>>
	<TELL <GET ,WHO-CARES-TBL .N> "." CR>>

"SUBTITLE REAL VERBS"

<ROUTINE PRE-SAIM ()
	<PERFORM ,V?AIM ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SAIM () <V-FOO>>

;<ROUTINE V-STEER () <TELL "That would be pointless." CR>>
<ROUTINE V-AIM () <YOU-CANT ;"aim">>

<ROUTINE PRE-SANALYZE () <PERFORM ,V?ANALYZE ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SANALYZE () <V-FOO>>

<ROUTINE PRE-ANALYZE ()
 <COND (<ROOM-CHECK>
	<RTRUE>)
       (<OR <FSET? ,PRSO ,PERSONBIT> ;<EQUAL? ,PRSO ,YOU ,ME>>
	<SETG CLOCK-WAIT T>
	<TELL "(Leave that to the police.)" CR>)
       ;(<AND <EQUAL? ,PRSI ,FINGERPRINTS>
	     <NOT <EQUAL? <META-LOC ,PRINT-KIT> ,HERE>>>
	<NOT-HERE ,PRINT-KIT>
	<RTRUE>)>>

<ROUTINE V-ANALYZE ()
 <COND ;(<EQUAL? ,PRSI ,FINGERPRINTS>
	<TELL "You don't find any interesting prints." CR>
	<RTRUE>)
       (<FSET? ,PRSO ,PERSONBIT> <TELL "How?" CR>)
       ;(<FSET? ,PRSO ,LIGHTBIT> <CHECK-ON-OFF>)
       (<FSET? ,PRSO ,DOORBIT> <CHECK-DOOR ,PRSO>)
       (T <TELL He+verb ,PRSO "look" " normal." CR> ;<YOU-CANT "check">)>>

<ROUTINE V-ANSWER ()
	 <COND (<T? ,AWAITING-REPLY>
		<COND (<EQUAL? <GET ,P-LEXV ,P-CONT> ,W?YES>
		       <PERFORM ,V?YES>)
		      (T ;<EQUAL? <GET ,P-LEXV ,P-CONT> ,W?NO>
		       <PERFORM ,V?NO>)>)
	       (T <NOT-CLEAR-WHOM>
		;<TELL "Nobody is waiting for an answer." CR>)>
	 <SETG P-CONT <>>
	 ;<SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <SETG P-CONT <>>
	 ;<SETG QUOTE-FLAG <>>
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<WAITING-FOR-YOU-TO-SPEAK>)
	       (T <YOU-CANT ;"answer">)>> 

<ROUTINE WAITING-FOR-YOU-TO-SPEAK ()
	<TELL He+verb ,PRSO "seem" " to be waiting for you to speak." CR>>

<ROUTINE V-ASK ()
 <COND (<AND <T? ,P-CONT>
	     <FSET? ,PRSO ,PERSONBIT>
	     <NOT <FSET? ,PRSO ,MUNGBIT>>>
	<SETG WINNER ,PRSO>
	<SETG QCONTEXT ,PRSO>)
       (T <V-ASK-ABOUT>)>>

<ROUTINE PRE-ASK ()
 <COND ;(<DOBJ? BUST CREW-GLOBAL JACK-TAPE MUSIC OCEAN PIANO
	       PLAYER-NAME RECORDER VOICE>
	<RFALSE>)
       ;(<AND <DOBJ? COUSIN>
	     <IN? ,BUST ,HERE>>
	<RETURN <DO-INSTEAD-OF ,BUST ,COUSIN>>)
       (<AND <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
	     <NOT <GLOBAL-IN? ,PRSO ,HERE>>>
	<NOT-HERE ;-PERSON ,PRSO>
	<RFATAL>)
       (<OR <DOBJ? PLAYER>
	    ;<DOBJ? COUSIN MAID GHOST-OLD>
	    <NOT <FSET? ,PRSO ,PERSONBIT>>
	    ;<FSET? ,PRSO ,MUNGBIT>>
	<COND (<AND <VERB? $CALL> <ZERO? ,P-CONT>>
	       <MISSING "verb">
	       <RFATAL>)
	      (<NOT <VERB? LISTEN>>
	       <WONT-HELP-TO-TALK-TO ,PRSO>
	       <RFATAL>)>)
       (<NOT <GRAB-ATTENTION ,PRSO ,PRSI>>
	<RFATAL>)>>

;<ROUTINE MISSING (NV)
	<TELL "[I think there's a " .NV " missing in that sentence!]" CR>>

<ROUTINE GRAB-ATTENTION (PERSON "OPTIONAL" (OBJ <>) "AUX" N GT ATT)
	 <COND (<FSET? .PERSON ,MUNGBIT>
		<COND (<EQUAL? <GETP .PERSON ,P?LDESC> 14 ;"asleep">
		       <TOO-BAD-BUT .PERSON "asleep">
		       <RFALSE>)
		      (T
		       <TOO-BAD-BUT .PERSON "out cold">
		       <RFALSE>)>)>
	 <SETG QCONTEXT .PERSON>
	 <COND (<NOT <==? <GETP .PERSON ,P?LDESC> 21 ;"searching">>
		<PUTP .PERSON ,P?LDESC 12 ;"listening to you">)>
	 <RTRUE>>

;<ROUTINE NOT-HERE-PERSON (PER "AUX" L)
	<SETG CLOCK-WAIT T>
	<TELL !\( The .PER " isn't ">
	<COND (<VISIBLE? .PER>
	       <TELL "close enough">
	       <COND (<SPEAKING-VERB?> <TELL " to hear you">)>
	       <TELL !\.>)
	      (T <TELL "here!">)>
	<TELL ")" CR>>

<ROUTINE V-ASK-ABOUT ()
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <DOBJ? PLAYER>>>
		<TELL
"A long silence tells you that" the ,PRSO " isn't interested in talking about">
		<COND (<IN? ,PRSI ,ROOMS>
		       <TELL " that">)
		      (T
		       <TELL the ,PRSI>)>
		<TELL "." CR>)
	       (T
		<PERFORM ,V?TELL ,PRSO>
		<RTRUE>)>>

<ROUTINE WONT-HELP-TO-TALK-TO (OBJ)
	;<VERB-PRINT>
	<TELL
"You talk to" the .OBJ " for a minute before you realize that" he .OBJ
" won't respond." CR>>

<ROUTINE PRE-ASK-CONTEXT-ABOUT ("OPTIONAL" (V 0) "AUX" P)
 <COND (<ZERO? .V> <SET V ,V?ASK-ABOUT>)>
 <COND (<QCONTEXT-GOOD?>
	<PERFORM .V ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL-I-ASSUME .P " Ask">
	<PERFORM .V .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-ABOUT () <ARENT-TALKING>>

<ROUTINE V-ASK-FOR ()
	 <TELL "Unsurprisingly," the ,PRSO " doesn't oblige." CR>>

<ROUTINE PRE-ASK-CONTEXT-FOR ("AUX" P)
 <COND (<FSET? <SET P <LOC ,PRSO>> ,PERSONBIT>
	<PERFORM ,V?ASK-FOR .P ,PRSO>
	<RTRUE>)
       (T <PRE-ASK-CONTEXT-ABOUT ,V?ASK-FOR>)>>

<ROUTINE V-ASK-CONTEXT-FOR () <ARENT-TALKING>>

<ROUTINE V-ATTACK () <IKILL "attack">>

;<ROUTINE V-BOW ("AUX" P)
	<SET P ,PRSO>
	<COND (<ZERO? .P>
	       <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	       <COND (<ZERO? .P>
		      <TELL "No one notices." CR>
		      <RTRUE>)>)>
	<COND (<OR <NOT <FSET? .P ,PERSONBIT>>
		   <EQUAL? .P ,PLAYER>>
	       <HAR-HAR>)
	      (<NOT <GRAB-ATTENTION .P>>
	       <RTRUE>)
	      (T
	       <TELL He .P !\ >
	       <COND (<FSET? .P ,FEMALEBIT> <TELL "curtsey">) (T <TELL "bow">)>
	       <TELL "s back to you." CR>)>>

<ROUTINE PRE-BRUSH ()
 <COND (<AND <DOBJ? ROOMS>
	     <NOT <EQUAL? ,P-PRSA-WORD ,W?SCRAPE ,W?SCRATCH>>>
	<SETG PRSO ,WINNER>
	<RFALSE>)>>

;<CONSTANT AHHH "Ahhh! How refreshing!|">

;<ROUTINE V-BRUSH ()
	 <COND (<NOT ,PRSI>
		<COND (<HELD? ,TOOTHBRUSH>
		       <TELL "(with the " D ,TOOTHBRUSH ")" CR>
		       <PERFORM ,V?BRUSH ,PRSO ,TOOTHBRUSH>
		       <RTRUE>)
		      (T
		       <TELL "You have nothing to brush">
		       <TELL the ,PRSO>
		       <TELL " with." CR>)>)
	       (<NOT <IOBJ? TOOTHBRUSH>>
		<TELL "With " a ,PRSI "!" CR>)
	       (<NOT <DOBJ? TEETH>>
		<TELL
"In general, " D ,TOOTHBRUSH "es are meant for teeth." CR>)
	       (T
		<TELL "Congratulations on your fine dental hygiene." CR>)>>

;<ROUTINE V-CLEAN ()
	 <COND (<DOBJ? TEETH>
		<PERFORM ,V?BRUSH ,TEETH>
		<RTRUE>)
	       (T
		<TELL "It is now much cleaner." CR>)>>

<ROUTINE V-BRUSH ()
	 <COND (<NOT ,PRSI>
		<COND (<HELD? ,TOOTHBRUSH>
		       <TELL "(with the " D ,TOOTHBRUSH ")" CR>
		       <PERFORM ,V?BRUSH ,PRSO ,TOOTHBRUSH>
		       <RTRUE>)
		      (T
		       <TELL "You have nothing to brush">
		       <TELL the ,PRSO>
		       <TELL " with." CR>)>)
	       (<NOT <EQUAL? ,PRSI ,TOOTHBRUSH>>
		<TELL "With " a ,PRSI "!" CR>)
	       (<NOT <EQUAL? ,PRSO ,TEETH>>
		<TELL
"In general, " D ,TOOTHBRUSH "es are meant for teeth." CR>)
	       (T
		<TELL "Congratulations on your fine dental hygiene." CR>)>>

;<ROUTINE UNCLEAN ()
	<TELL
"You try for a minute and then decide it's an endless task." CR>>

<ROUTINE V-BUY ()
	 <TELL "Sorry," the ,PRSO " isn't for sale." CR>>

;<ROUTINE REMOVE-CAREFULLY ("OPTIONAL" (OBJ <>) "AUX" OLIT)
	 <SET OLIT ,LIT>
	 <COND (<T? .OBJ>
		<NOT-IT .OBJ>
		<MOVE .OBJ ,LOCAL-GLOBALS>)>
	 <SETG LIT <LIT? ;,HERE>>
	 <COND (<AND <T? .OLIT> <ZERO? ,LIT>>
		<TELL "You are left in the dark..." CR>)>
	 T>

<ROUTINE V-$CALL () ;("AUX" (MOT <>))
	 <UNSNOOZE ,PRSO>
	 <COND (<FSET? ,PRSO ,PERSONBIT>
		<COND (<==? <META-LOC ,PRSO> ,HERE>
		       <COND (<GRAB-ATTENTION ,PRSO>
			      ;<FCLEAR ,PRSO ,TOUCHBIT>
			      <PUTP ,PRSO ,P?LDESC 12 ;"listening to you">
			      <TELL The ,PRSO>
			      <COND ;(.MOT
				     <TELL
verb ,PRSO "stop" " and" verb ,PRSO "turn" " toward you." CR>)
			      	    (T <TELL
" is " <GET ,LDESC-STRINGS 12> ;"listening to you" "." CR>)>)
			     (T
			      ;<TELL " ignores you." CR>
			      <RFATAL>)>)
		      ;(<CORRIDOR-LOOK ,PRSO>
		       <COND ;(<COR-GRAB-ATTENTION ;,PRSO>
			      <RTRUE>)
			     (T
			      <TELL The ,PRSO " ignores you." CR>)>)
		      (T <NOT-HERE ,PRSO>)>)
	       (T <SETG CLOCK-WAIT T> <MISSING "verb">)>>

<ROUTINE UNSNOOZE (PER "OPTIONAL" (NO-TELL? <>)
		       "AUX" RM GT (C <GETP .PER ,P?LDESC>))
 <COND (<EQUAL? .C 14 ;"asleep">
	<COND (T <PUTP .PER ,P?LDESC 25 ;"looking sleepy">)>
	<FCLEAR .PER ,MUNGBIT>
	<SET RM <META-LOC .PER>>
	<COND (<AND <IN? .PER ,HERE> <ZERO? .NO-TELL?>>
	       <TELL He .PER " wakes up first. ">
	       <COND (<NOT <FSET? .RM ,ONBIT>>
		      <TELL He .PER " turns on the light. ">)>)>
	<FSET .RM ,ONBIT>
	<RTRUE>)>>

<ROUTINE V-CHASTISE ()
	<COND (<NOT <EQUAL? ,PRSO ,INTDIR>>
	       <TELL
,I-ASSUME " Look at" him ,PRSO ", not look in" him ,PRSO " nor look for"
him ,PRSO " nor any other preposition.]" CR>)>
	<PERFORM ,V?EXAMINE ,PRSO>
	<RTRUE>>

<ROUTINE V-BOARD ()
 <COND (<OR <IN? ,PRSO ,ROOMS> <FSET? ,PRSO ,DOORBIT>>
	<V-THROUGH>)
       (<FSET? ,PRSO ,VEHBIT>
	<COND (<IN? ,WINNER ,PRSO>
	       <ALREADY ,PLAYER>
	       <TELL "in" the ,PRSO ".)" CR>)
	      (T
	       <MOVE ,WINNER ,PRSO>
	       <TELL He+verb ,WINNER "is" " now ">
	       <COND (<FSET? ,PRSO ,SURFACEBIT>
		      <TELL "on">)
		     (T <TELL "in">)>
	       <TELL the ,PRSO "." CR>
	       ;<APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	       <RTRUE>)>)
       (T <YOU-CANT "get in">)>>

<ROUTINE V-CLIMB-ON ()
	<PERFORM ,V?SIT ,PRSO>
	<RTRUE>>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 <COND (<IN? ,PRSO ,ROOMS>	;"GO UP TO room"
		<PERFORM ,V?WALK-TO ,PRSO>
		<RTRUE>)
	       (<GETPT ,HERE .DIR>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<YOU-CANT "go">)
	       (ELSE <HAR-HAR>)>>

<ROUTINE V-CLIMB-DOWN () <V-CLIMB-UP ,P?DOWN>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <EQUAL? ,PRSO ,WINDOW>>>
		<YOU-CANT ;"close">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <EQUAL? ,PRSO ,WINDOW>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND ;(<FSET? ,PRSO ,MUNGBIT>
			      <TELL
"It won't stay closed. The latch is broken." CR>)
			     (T
			      <OKAY ,PRSO "closed">)>)
		      (T <ALREADY ,PRSO "closed">)>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <0? <GETP ,PRSO ,P?CAPACITY>>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <OKAY ,PRSO "closed">)
		      (T <ALREADY ,PRSO "closed">)>)
	       (T <YOU-CANT ;"close">)>>

<ROUTINE V-COUNT () <IMPOSSIBLE>>

;<ROUTINE PRE-DESCRIBE ()
 <COND (<==? ,WINNER ,PLAYER>
	<COND (<EQUAL? ,PRSI <> ,ROOMS>
	       <COND (<QCONTEXT-GOOD?>
		      <SETG WINNER ,QCONTEXT>
		      <PERFORM ,PRSA ,PRSO>
		      <RTRUE>)
		     (T <ARENT-TALKING>)>)
	      (T
	       <PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO>
	       <RTRUE>)>)>>

;<ROUTINE V-DESCRIBE () <V-FOO>>

<ROUTINE V-DIAGNOSE ()
 <COND (<T? ,PRSO> <YOU-CANT ;"diagnose">)
       (T <TELL He+verb ,WINNER "is" " wide awake and in good health." CR>)>>

<ROUTINE TELL-NOT-IN (OBJ)
	<SETG CLOCK-WAIT T>
	<TELL !\( He+verb ,WINNER "is" " not in" him .OBJ "!)" CR>>

<ROUTINE V-DRINK () <YOU-CANT ;"drink">>

<ROUTINE V-DROP ("AUX" L)
 <COND (<IDROP>
	<COND (<OR ;<IN? <SET L ,TABLE-DINING> ,HERE>
		   <SET L <FIND-FLAG-HERE ,VEHBIT;,SURFACEBIT ,PRSO>>>
	       <MOVE ,PRSO .L>
	       <OKAY ,PRSO>
	       <TELL " is now on" the .L "." CR>)
	      (T
	       <OKAY ,PRSO <GROUND-DESC>>)>)>>

<ROUTINE GROUND-DESC ()
	 <COND (<NOT <OUTSIDE? ,HERE>>
		"on the floor")
	       (T "on the ground")>>

<ROUTINE PRE-EAT ()
 <COND (<EQUAL? ,PRSO <> ,ROOMS>
	<COND (<EQUAL? <META-LOC ,DINNER> ,HERE>
	       ;<SETG PRSO ,DINNER>
	       <PERFORM ,PRSA ,DINNER>
	       <RTRUE>)
	      (T
	       <NOT-HERE ,DINNER>
	       <RTRUE>)>)>>

<ROUTINE V-EAT ()
	 <TELL
"Stuffing" the ,PRSO " in your mouth would do little to help at this point."
CR>>

<ROUTINE V-ENJOY ()
	 <COND (<FSET? ,PRSO ,PERSONBIT>
		<V-KISS>)
	       (T <TELL
"Not difficult at all, considering how enjoyable" the ,PRSO " is." CR>)>>

<ROUTINE PRE-THROUGH ("AUX" VEH)
 <COND (<DOBJ? ROOMS GLOBAL-HERE>
	<COND (<SET VEH <FIND-IN ,HERE ,VEHBIT>>
	       <PERFORM ,V?BOARD .VEH>
	       <RTRUE>)
	      (T
	       <DO-WALK ,P?IN>)>
	<RTRUE>)
       ;(<T? ,PRSI>	;"DRIVE CAR THRU object"
	<COND (<DOBJ? CAR>
	       <COND (<EQUAL? <LOC ,WINNER> ;,HERE ,CAR>
		      <SETG PRSO ,PRSI>
		      <RFALSE>)
		     (T
		      <TELL-NOT-IN ,CAR>
		      <RTRUE>)>)
	      (T <DONT-UNDERSTAND>)>)>>

<ROUTINE V-THROUGH ("AUX" RM DIR)
	<COND (<AND <NOUN-USED? ,PRSO ,W?DOOR ;,W?GATE ;,W?HOLE>
		    ;<FSET? ,PRSO ,DOORBIT>
		    <OR <FSET? ,PRSO ,OPENBIT>
			<WALK-THRU-DOOR? <> ,PRSO <>>>>
	       <COND (<OR <NOT <SET RM <DOOR-ROOM ,HERE ,PRSO>>>
			  <NOT <GOTO .RM>>>
		      <V-FOO>)>)
	      (<IN? ,PRSO ,ROOMS>
	       <COND (<==? ,PRSO ,HERE>
		      <WALK-WITHIN-ROOM>)
		     (<SEE-INTO? ,PRSO <>>
		      <GOTO ,PRSO>)
		     (T <PERFORM ,V?WALK-TO ,PRSO>)>
	       <RTRUE>)
	      (<AND <FSET? ,PRSO ,VEHBIT>
		    ;<FSET? ,PRSO ,CONTBIT>>
	       <PERFORM ,V?BOARD ,PRSO>)
	      (<FSET? ,PRSO ,PERSONBIT>
	       <HAR-HAR>)
	      (<NOT <FSET? ,PRSO ,TAKEBIT>>
	       <TELL He+verb ,WINNER "bang" " into" the ,PRSO>
	       <THIS-IS-IT ,PRSO>
	       <TELL " trying to go through" him ,PRSO "." CR>)
	      (<IN? ,PRSO ,WINNER>
	       <PERFORM ,V?EXAMINE ,EYES>
	       <RTRUE>)
	      (ELSE <HAR-HAR>)>>

<ROUTINE PRE-EXAMINE () <ROOM-CHECK>>

<ROUTINE V-EXAMINE ("AUX" (TXT <>))
	 <COND (<OR <==? ,PRSO ,PSEUDO-OBJECT>
		    <AND <NOUN-USED? ,PRSO ,W?DOOR ;,W?DOORS ;,W?KEYHOLE>
			 <GLOBAL-IN? ,PRSO ,HERE>>>
		<SET TXT T>)>
	 <COND (<DOBJ? INTDIR>
		<SETG CLOCK-WAIT T>
		<TELL "(If you want to see what's there, go there!)" CR>)
	       (<DOBJ? HANDS HEAD EYES TEETH EARS WALL LIGHT-GLOBAL>
		<NOTHING-SPECIAL>)
	       ;(<DOBJ? NOW-WEARING>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<AND <IN? ,PRSO ,ROOMS>	;<FSET? ,PRSO ,RLANDBIT>
		     <ZERO? .TXT>>
		<ROOM-PEEK ,PRSO>)
	       (<AND <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
		     <NOT <GLOBAL-IN? ,PRSO ,HERE>>
		     <ZERO? .TXT>>
		<TOO-BAD-BUT ,PRSO "too far away">)
	       (<SET TXT <GETP ,PRSO ,P?TEXT>>
		<TELL .TXT CR>)
	       (<FSET? ,PRSO ,DOORBIT>
		<CHECK-DOOR ,PRSO>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,SURFACEBIT>
		    ;<NOUN-USED? ,PRSO ,W?KEYHOLE>>
		<V-LOOK-INSIDE>)
	       (T <NOTHING-SPECIAL>)>>

<ROUTINE NOTHING-SPECIAL ()
	<TELL "You see nothing special about" the ,PRSO "." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TEE)
	 <COND (<EQUAL? .OBJ1 .OBJ2>
		<RTRUE>)
	       (<SET TEE <GETPT .OBJ2 ,P?GLOBAL>>
		<INTBL? .OBJ1 .TEE </ <PTSIZE .TEE> 2>>)>>

<ROUTINE V-FAINT ()
	 <TELL "You doze for several minutes. ">
	 <V-WAIT>>

<ROUTINE V-FILL ()
	 <YOU-CANT>
	 ;<TELL "You may know how to do that, but this story doesn't." CR>>

<ROUTINE PRE-FIND ()
	 <COND (<DOBJ? PLAYER ;PLAYER-NAME>
		<RFALSE>)
	       (<AND <FSET? ,PRSO ,SECRETBIT>
		     <NOT <FSET? ,PRSO ,SEENBIT>>>
		<NO-FUN>)
	       (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <ALREADY ,WINNER "here">)
		      (T
		       <PERFORM ,V?WALK-TO ,PRSO>
		       <RTRUE>)>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     ;<NOT <==? ,PRSO ,OTHER-CHAR>>>
		<COND (<AND <==? <META-LOC ,WINNER> <META-LOC ,PRSO>>
			    <NOT <FSET? ,PRSO ,NDESCBIT>>>
		       <BITE-YOU>
		       <RTRUE>)
		      (<NOT <FOLLOW-LOC?>>
		       <WHO-KNOWS? ,PRSO>
		       <RFATAL>)>
		<RTRUE>)>>

<ROUTINE BITE-YOU ()
	<TELL "If" he ,PRSO " were any closer," he ,PRSO "'d bite you!" CR>>

<ROUTINE FAR-AWAY? (L)
 <COND ;(<ZERO? <GETP ,HERE ,P?LINE>>
	<RTRUE>)
       (<EQUAL? .L ,GLOBAL-OBJECTS>
	<RTRUE>)
       (<AND <FSET? .L ,SECRETBIT>
	     <NOT <FSET? .L ,SEENBIT>>>
	<RTRUE>)
       ;(<ZERO? <GETP .L ,P?LINE>>
	<RTRUE>)>
 <COND (<OR <AND <FSET? ,HERE ,SECRETBIT>
		 <NOT <FSET? .L ,SECRETBIT>>>
	    <AND <NOT <FSET? ,HERE ,SECRETBIT>>
		 <FSET? .L ,SECRETBIT>>>
	<RETURN <NOT <SEE-INTO? .L <> ;T> ;<GLOBAL-IN? .L ,HERE>>>)>
 <RFALSE>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<EQUAL? ,PRSO ,HANDS ,HEAD ,EARS ,TEETH ,EYES>
		<TELL "Are you sure" the ,PRSO " is lost?" CR>)
	       (<HELD? ,PRSO>
		<TELL "You have it!" CR>)
	       ;(<OR <FSET? ,PRSO ,SECRETBIT>
		    ;<==? ,PRSO ,ARTIFACT>>
		<NO-FUN>)
	       (<AND <FSET? .L ,PERSONBIT>
		     <VISIBLE? .L>>
		<TELL "As far as you can tell,">
		<TELL the .L>
		<THIS-IS-IT .L>
		<TELL " has it." CR>)
	       (<VISIBLE? ,PRSO>
		<COND ;(<FSET? ,PRSO ,SECRETBIT>
		       <DISCOVER ,PRSO>)
		      (T <TELL "Right in front of you." CR>)>)
	       (<AND ;<NOT <FSET? ,PRSO ,TOUCHBIT>>
		     <NOT <FSET? ,PRSO ,SEENBIT>>
		     ;<OR <IN? ,PRSO ,ROOMS>
			 <FSET? ,PRSO ,SECRETBIT>>>
		<NOT-HERE ,PRSO T>)
	       (<OR <EQUAL? .L ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
		    ;<EQUAL? ,PRSO ,DRAPES>>
		<TELL "It's around somewhere." CR>)
	       (<FAR-AWAY? <META-LOC ,PRSO>>
		<TELL "It's far away from here." CR>)
	       (<OR <FSET? .L ,SURFACEBIT>
		    <FSET? .L ,CONTBIT>
		    <IN? .L ,ROOMS>>
		<THIS-IS-IT .L>
		<TELL "It's probably ">
		<COND (<FSET? .L ,SURFACEBIT> <TELL "on">) (T <TELL "in">)>
		<TELL the .L "." CR>)
	       (T
		<TELL "You'll have to do that yourself." CR>)>>

<ROUTINE NO-FUN ()
	<SETG CLOCK-WAIT T>
	<TELL "(If it's that easy, it spoils the fun!)" CR>>

<ROUTINE TELL-LOCATION ("AUX" DIR)
	;<COND (<EQUAL? ,HERE ,UNCONSCIOUS>
	       <TELL "unconscious.">
	       <RTRUE>)>
	<COND (<NOT <IN? ,PLAYER ,HERE>>
	       <TELL "sitting ">)>
	;<COND (<ZERO? ,PLAYER-SEATED>	T)
	      (<L? 0 ,PLAYER-SEATED>	<TELL "sitting ">)
	      (T 			<TELL "lying ">)>
	<COND (<FSET? ,HERE ,SURFACEBIT>
	       <TELL "on">)
	      (T
	       <TELL "in">)>
	<TELL the ,HERE ".">>

<ROUTINE V-FIX () <MORE-SPECIFIC>>

;<ROUTINE V-REPAIR ()
	 <COND (<OR <AND <EQUAL? ,PRSO ,THUMB>
		         <FSET? ,THUMB ,MUNGEDBIT>>
		    <AND <EQUAL? ,PRSO ,HATCH>
			 ,LANDED>>
		<TELL "You have neither the tools nor the expertise." CR>)
	       (T
		<TELL "I'm not sure it's broken." CR>)>>

<ROUTINE FOLLOW-LOC? ("AUX" L)
	 <SET L <GETP ,PRSO ,P?CHARACTER>>
	 <COND (<SET L <GET ,FOLLOW-LOC .L>>
		<TELL "The last you knew," he ,PRSO " was ">
		<COND (<FSET? .L ,SURFACEBIT>
		       <TELL "on">)
		      (T <TELL "in">)>
		<TELL the .L>
		<TELL ".|">
		.L)>>

<ROUTINE V-FOLLOW ("AUX" L)
	 <COND (<==? ,PRSO ,WINNER>
		<YOU-CANT>)
	       (<AND ;<NOT <DOBJ? GHOST-NEW>>
		     <NOT <FSET? ,PRSO ,PERSONBIT>>>
		<IMPOSSIBLE>)
	       (<==? ,HERE <META-LOC ,PRSO>>
		<TELL "You're in the same place as" he ,PRSO "!" CR>)
	       ;(<SET L <GET ,FOLLOW-LOC <GETP ,PRSO ,P?CHARACTER>>
		       ;<FOLLOW-LOC?>>
		<PERFORM ,V?WALK-TO .L>)
	       (T
		<WHO-KNOWS? ,PRSO>
		<RFATAL>)>>

<ROUTINE V-FOO () <TELL "[Foo!! This is a bug!!]" CR>>

<ROUTINE V-FOOTNOTE ()
	 <COND (<NOT <EQUAL? ,PRSO ,INTNUM>>
		<TELL "Specify a number, as in \"FOOTNOTE 6.\"" CR>)
	       ;(<EQUAL? ,P-NUMBER 8>
		<SETG AWAITING-REPLY 13>
		<QUEUE I-REPLY 1> ;"only 1 since FOOTNOTE isn't move"
		<NOT-VERY-GOOD "legend">)
	       (<EQUAL? ,P-NUMBER 11> ;"not referenced"
		<SETG AWAITING-REPLY 14>
		<QUEUE I-REPLY 2>
		<TELL "Isn't it fun reading through all the footnotes?" CR>)
	       (<EQUAL? ,P-NUMBER 12>
	        <TELL
"This is the famous recursive footnote (Footnote 12)." CR>)
	       (<EQUAL? ,P-NUMBER 14>
		<TELL
,GUIDE-NAME " is also the name of a terrific work of interactive fiction by
Douglas Adams and S. Eric Meretzky." ,ALREADY-KNOW-THAT CR>)
	       (T
		<TELL "There is no Footnote " N ,P-NUMBER "." CR>)>>

;<ROUTINE NOT-VERY-GOOD (STRING)
	 <SETG AWAITING-REPLY 13>
	 <QUEUE I-REPLY 1> ;"only 1 since FOOTNOTE isn't move"
	 <TELL "It's not a very good " .STRING ", is it?" CR>>

<ROUTINE I-REPLY ()
	 <SETG AWAITING-REPLY <>>
	 <RFALSE>>

<GLOBAL AWAITING-REPLY <>>

<ROUTINE PRE-GIVE ()
	 <COND (<AND <NOT <EQUAL? ,PRSI ,PLAYER ;,PLAYER-NAME>>
		     <NOT-HOLDING? ,PRSO>>
		<RTRUE>)>>

;<ROUTINE PRE-GIVE ()
	 <COND (<IDROP>
		<RTRUE>)>>

<ROUTINE V-GIVE ()
	 <COND (<ZERO? ,PRSI>
		<YOU-CANT ;"give">)
	       (<NOT <FSET? ,PRSI ,PERSONBIT>>
		<TELL
He ,WINNER " can't give " a ,PRSO " to " a ,PRSI "!" CR>)
	       ;(<FSET? ,PRSI ,MUNGBIT>
		<TELL He+verb ,PRSI "do" "n't respond." CR>)
	       (<IOBJ? PLAYER>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (T
		<TELL "Politely," the ,PRSI " refuses your offer." CR>)
	       ;(T
		<MOVE ,PRSO ,PRSI>
		<TELL He+verb ,PRSI "accept" " your gift." CR>
		<RTRUE>)>>

<ROUTINE PRE-SGIVE ("AUX" X)
	;<PROG ()
	      <SET X <GET ,P-NAMW 0>>
	      <PUT ,P-NAMW 0 <GET ,P-NAMW 1>>
	      <PUT ,P-NAMW 1 .X>>
	<PERFORM ,V?GIVE ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SGIVE () <V-FOO>>

<CONSTANT I-ASSUME "[I assume you mean:">

<ROUTINE TELL-I-ASSUME (OBJ "OPT" PRON)
	<COND (<AND <NOT <FSET? .PRON ,TOUCHBIT>> 
		    <NOT <EQUAL? ,OPRSO .OBJ>>>
	       <FSET .PRON ,TOUCHBIT>
	       <TELL ,I-ASSUME>
	       <TELL !\ >
	       <TELL-THE .OBJ>
	       <TELL ".]" CR>)>>

<ROUTINE PRE-HELLO (;"OPTIONAL" ;(STR 0) "AUX" P (WORD <>))
 <COND (<EQUAL? ,P-PRSA-WORD ,W?HELLO ,W?HI>
	<SET WORD " Greet">)
       ;(<EQUAL? ,P-PRSA-WORD ,W?SORRY>
	<SET WORD " Apologize to">)>
 <COND (<NOT <DOBJ? ROOMS>>
	<COND (<AND <NOT <FSET? ,PRSO ,PERSONBIT>>
		    ;<NOT <DOBJ? CREW-GLOBAL>>>
	       <WONT-HELP-TO-TALK-TO ,PRSO>
	       <RTRUE>)
	      (<FSET? ,PRSO ,MUNGBIT>
	       <PERFORM ,V?ALARM ,PRSO>
	       <RTRUE>)
	      (<T? .WORD>
	       <TELL ,I-ASSUME .WORD him ,PRSO ".]" CR>
	       <RFALSE>)>
	;<UNSNOOZE ,PRSO>
	<COND ;(<NOT <GRAB-ATTENTION ,PRSO>>
	       <RFATAL>)
	      (T <RFALSE>)>)
       (<QCONTEXT-GOOD?>
	<TELL ,I-ASSUME>
	;<COND (<T? .WORD>
	       <TELL .WORD>)>
	<TELL !\  D ,QCONTEXT ".]" CR>
	<PERFORM ,PRSA ,QCONTEXT>
	<RTRUE>)
       (<AND <EQUAL? ,WINNER ,PLAYER>
	     <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	<TELL ,I-ASSUME>
	;<COND (<T? .WORD>
	       <TELL .WORD>)>
	<TELL !\  D .P ".]" CR>
	<PERFORM ,PRSA .P>
	<RTRUE>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELLO () ;("OPTIONAL" (HELL T))
 <COND (<FSET? ,PRSO ,PERSONBIT> ;<GETP ,PRSO ,P?CHARACTER>
	<COND (<NOT <FSET? ,PRSO ,MUNGBIT>>
	       <TELL "\"Hello to you too.\"" CR>)
	      (T <WONT-HELP-TO-TALK-TO ,PRSO>)>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELP ()
 <COND (<EQUAL? ,PRSO <> ,PLAYER>
	<HELP-TEXT>)
       (T <MORE-SPECIFIC>)>>

;<ROUTINE V-SAVE-SOMETHING ()
	 <TELL "Sorry, but">
	 <TELL the ,PRSO>
	 <TELL " is beyond help." CR>>

<ROUTINE HELP-TEXT ()
	<SETG CLOCK-WAIT T>
	<TELL
"[You'll find plenty of help in your " D ,GAME " package.|
If you're really stuck, you can order a complete map and InvisiClues (TM)
hint booklet
from your dealer or via mail with the form in your package.]" CR>>

<ROUTINE V-HIDE ()
	 <TELL "There's no place to hide here." CR>>

;<ROUTINE V-HITCHHIKE ()
	 <PERFORM ,V?PUSH ,GREEN-BUTTON>
	 <RTRUE>>

<ROUTINE V-KILL ()
	 <TELL
"You are obviously letting things get to you. You should learn to
relax a little." CR>>

<CONSTANT YOU-DIDNT-SAY-W "[You didn't say w">

<ROUTINE IKILL ("OPTIONAL" (STR <>))
	 <COND (<ZERO? ,PRSO>
		<SETG CLOCK-WAIT T>
		<TELL "(There's nothing here to " .STR ".)" CR>)
	       (<ZERO? ,PRSI>
		<SETG CLOCK-WAIT T>
		<TELL ,YOU-DIDNT-SAY-W "hat to " .STR the ,PRSO>
		<COND (<FSET? ,PRSO ,WEAPONBIT>
		       <TELL " at">)
		      (T ;<FSET? ,PRSO ,PERSONBIT>
		       <TELL " with">)>
		<TELL ".]" CR>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<HAR-HAR>)
	       (T <TELL ,NO-VIOLENCE> <RTRUE>)>>

<CONSTANT NO-VIOLENCE "You think it over. There's no need to get violent.|">

;<ROUTINE V-KISS ()
	 <TELL "This is family entertainment, not a video nasty." CR>>

<ROUTINE V-KISS ("AUX" X)
	 <COND (<EQUAL? ,PRSO ,PLAYER>
		<TELL "You kiss " 'PLAYER " for a minute. Yuk!" CR>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<FACE-RED>)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE V-KNOCK ("AUX" P)
 <COND (<OR <FSET? ,PRSO ,DOORBIT>
	    ;<EQUAL? ,PRSO ,WINDOW>>
	<COND (<FSET? ,PRSO ,OPENBIT>
	       <TELL "It's open!" CR>)
	      ;(<AND <SET P <DOOR-ROOM ,HERE ,PRSO>>
		    <SET P <FIND-IN .P ,PERSONBIT ,PLAYER>>>
	       <FCLEAR ,PRSO ,LOCKED>
	       <FSET ,PRSO ,OPENBIT>
	       <FSET ,PRSO ,ONBIT>
	       <UNSNOOZE .P>
	       <THIS-IS-IT .P>
	       <TELL He .P " opens the door, then retreats into the room."
			  ;"Someone shouts \"Come!\"" CR>)
	      (T <TELL "Nobody's home." CR>)>)
       (T
	<HACK-HACK "Knocking on">)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<NOT <FSET? ,PRSO ,LIGHTBIT>>
		<YOU-CANT "turn off">)
	       (<NOT <FSET? ,PRSO ,ONBIT>>
		<ALREADY ,PRSO "off">)
	       (T
		<OKAY ,PRSO "off">)>>

<ROUTINE V-LAMP-ON ()
	 <COND (<FSET? ,PRSO ,ONBIT>
		<ALREADY ,PRSO "on">)
	       (<FSET? ,PRSO ,LIGHTBIT>
		<OKAY ,PRSO "on">)
	       (<FSET? ,PRSO ,PERSONBIT>
		<HAR-HAR>)
	       (T <YOU-CANT "turn on">)>>

<ROUTINE V-LEAP ()
	 <COND (<AND ,PRSO
		     <NOT <DOBJ? INTDIR>>>
		<IMPOSSIBLE>
		<RTRUE>)
	       ;(<GETPT ,HERE ,P?DOWN>
		<TELL "This was not a very safe place to try jumping.">
		<FINISH>)
	       (T <V-SKIP>)>>

<ROUTINE V-SKIP ()
	 <COND ;(<FSET? <LOC ,PLAYER> ,VEHBIT>
		<TELL "That would be tough from your current position." CR>)
	       (T <WHEE>)>>

<ROUTINE WHEE ("AUX" X)
	<SET X <RANDOM 5>>
	<COND (<==? 1 .X>
	       <TELL "Very good. Now you can go to the second grade." CR>)
	      (<==? 2 .X>
	       <TELL "I hope you enjoyed that more than I did." CR>)
	      (<==? 3 .X>
	       <TELL "Are you enjoying " 'PLAYER "?" CR>)
	      (<==? 4 .X>
	       <TELL "Wheeeeeeeeee!!!!!" CR>)
	      (T <TELL "Do you expect someone to applaud?" CR>)>>

<ROUTINE V-LEAVE ("AUX" GT)
	<COND (<==? ,WINNER ,FOLLOWER>
	       <SETG FOLLOWER 0>)>
	<COND (<EQUAL? ,PRSO <> ,ROOMS ,HERE>
	       <DO-WALK ,P?OUT>
	       <PUTP ,WINNER ,P?LDESC 9 ;"waiting patiently">
	       <RTRUE>)
	      (<EQUAL? <LOC ,PRSO> ,PLAYER ;,POCKET>
	       <PERFORM ,V?DROP ,PRSO>
	       <RTRUE>)
	      (<==? <LOC ,WINNER> ,PRSO>
	       <PERFORM ,V?DISEMBARK ,PRSO>
	       <RTRUE>)
	      (T
	       <TELL-NOT-IN ,PRSO>
	       <RFATAL>)>>

<ROUTINE PRE-LIE () <ROOM-CHECK>>

<ROUTINE V-LIE () <V-SIT T>>

<ROUTINE PRE-LISTEN ()
 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
	     <EQUAL? <GETP ,PRSO ,P?LDESC> 14 ;"asleep">>
	<TELL "\"Zzzzzzz...\"" CR>
	<RTRUE>)
       (T <PRE-ASK>)>>

<ROUTINE V-LISTEN ()
 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
	     <NOT <FSET? ,PRSO ,MUNGBIT>>>
	<WAITING-FOR-YOU-TO-SPEAK>
	<RTRUE>)
       (T
	<TELL "At the moment," the ,PRSO " makes no sound." CR>)>>

<ROUTINE V-LOCK ()
 <COND ;(<FSET? ,PRSO ,DOORBIT>
	<COND (<EQUAL? ,PRSO ,HERE>
	       <OKAY ,PRSO "locked">)
	      (T <TELL-FIND-NONE "a way to lock" ,PRSO>)>)
       (T <HAR-HAR>)>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS ;T>
		;<CRLF>)>>

<ROUTINE V-LOOK-BEHIND ()
 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
	<TOO-BAD-BUT ,PRSO "closed">)
       (T <TELL "There's nothing behind" him ,PRSO "." CR>)>>

<ROUTINE V-LOOK-DOWN ()
 <COND (<==? ,PRSO ,ROOMS>
	<PERFORM ,V?EXAMINE ,FLOOR>
	<RTRUE>)
       (T
	<PERFORM ,V?LOOK-INSIDE ,PRSO>
	<RTRUE>)>>

<ROUTINE PRE-LOOK-INSIDE () <ROOM-CHECK>>

<ROUTINE V-LOOK-INSIDE ("OPTIONAL" (DIR ,P?IN) "AUX" RM)
	 <COND (<DOBJ? ROOMS>
		<COND (<==? .DIR ,P?OUT>
		       <COND (<GLOBAL-IN? ,WINDOW ,HERE>
			      <PERFORM ,PRSA ,WINDOW ,PRSI>
			      <RTRUE>)>)
		      (T
		       <COND (<OR <FSET? <SET RM ,P-IT-OBJECT> ,CONTBIT>
				  <SET RM <FIND-FLAG-LG ,HERE ,CONTBIT>>
				  <GLOBAL-IN? <SET RM ,WINDOW> ,HERE>
				  <SET RM <FIND-FLAG-LG ,HERE ,DOORBIT>>>
			      <TELL-I-ASSUME .RM>
			      <PERFORM ,PRSA .RM ,PRSI>
			      <RTRUE>)>)>)>
	 <COND (<DOBJ? GLOBAL-HERE>
		<PERFORM ,V?LOOK>
		<RTRUE>)
	       (<AND <IN? ,PRSO ,ROOMS>	;<FSET? ,PRSO ,RLANDBIT>
		     <NOT <NOUN-USED? ,PRSO ,W?DOOR>>
		     <OR <GLOBAL-IN? ,PRSO ,HERE>
			 <SEE-INTO? ,PRSO <>>
			 ;<VISIBLE? ,PRSO>>>
		<ROOM-PEEK ,PRSO>)
	       (<V-LOOK-THROUGH T> <RTRUE>) ;"SWG swapped this & next 5/21/86"
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,SURFACEBIT>>
		<COND (<NOT <SEE-INSIDE? ,PRSO T>>
		       <FIRST-YOU "open" ,PRSO>)>
		<COND (<FIRST? ,PRSO>
		       <TELL "You can see">
		       <PRINT-CONTENTS ,PRSO>
		       ;<PRINT-CONT ,PRSO>
		       <COND (<FSET? ,PRSO ,SURFACEBIT> <TELL " on">)
			     (T <TELL " inside">)>
		       <TELL him ,PRSO "." CR>
		       <RTRUE>)
		      (<FSET? ,PRSO ,SURFACEBIT>
		       <TELL "There's nothing on" him ,PRSO>
		       <COND (<IN? ,PLAYER ,PRSO>
			      ;<EQUAL? ,PLAYER-SEATED ,PRSO <- 0 ,PRSO>>
			      <TELL " except you">)>
		       <TELL "." CR>)
		      (T <TOO-BAD-BUT ,PRSO "empty">)>)
	       (<==? .DIR ,P?IN> <YOU-CANT "look inside">)
	       (T ;<==? .DIR ,P?OUT> <YOU-CANT "look outside">)>>

<ROUTINE FIRST-YOU (STR "OPTIONAL" (OBJ 0) (OBJ2 0))
	<TELL !\(>
	<HE-SHE-IT ,WINNER T .STR>
	<COND (<T? .OBJ>
	       <TELL the ;him .OBJ>
	       <COND (<=? .STR "open">
		      <FSET .OBJ ,OPENBIT>)>
	       <COND (<T? .OBJ2>
		      <TELL " from" the ;him .OBJ2>)>)>
	<TELL " first.)" CR>>

<ROUTINE V-LOOK-THROUGH ("OPTIONAL" (INSIDE <>) "AUX" RM)
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<OR <FSET? ,PRSO ,OPENBIT>
			   <FSET? ,PRSO ,TRANSBIT>
			   ;<NOUN-USED? ,PRSO ,W?KEYHOLE>>
		       <COND (<SET RM <DOOR-ROOM ,HERE ,PRSO>>
			      <ROOM-PEEK .RM T>)
			     (T <NO-BEYOND>)>)
		      ;(<ZMEMQ ,PRSO ,CHAR-ROOM-TABLE>
		       <PERFORM ,PRSA ,KEYHOLE>
		       <RTRUE>)
		      (T
		       <TOO-BAD-BUT ,PRSO "closed">)>)
	       (<EQUAL? ,PRSO ,WINDOW>
		<COND ;(<SET RM <WINDOW-ROOM ,HERE ,PRSO>>
		       <ROOM-PEEK .RM T>)
		      (T <NO-BEYOND>)>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL "You forgot to bring your X-ray glasses." CR>)
	       (.INSIDE <RFALSE>)
	       (<FSET? ,PRSO ,TRANSBIT>
		<TELL "Everything looks bigger." CR>)
	       (T <YOU-CANT "look through">)>>

<ROUTINE NO-BEYOND () <TELL "You can't tell what's beyond" him ,PRSO "." CR>>

<ROUTINE ROOM-PEEK (RM "OPTIONAL" (SAFE <>) "AUX" (X <>) OHERE OLIT TXT)
	 <COND (<EQUAL? .RM ,HERE>
		<V-LOOK>
		<RTRUE>)
	       (<OR .SAFE <SEE-INTO? .RM>>
		<SET OHERE ,HERE>
		<SET OLIT ,LIT>
		<SETG HERE .RM>
		<MAKE-ALL-PEOPLE -12 ;"listening to you">
		<SETG LIT <LIT? ;,HERE>>
		<TELL "You peer ">
		<COND (<FSET? .RM ,SURFACEBIT> <TELL "at">) (T <TELL "into">)>
		<TELL him .RM !\: CR>
		<COND (<DESCRIBE-OBJECTS ;T> <SET X T>)
		      (<SET TXT <GETP .RM ,P?LDESC>>
		       <SET X T>
		       <TELL .TXT CR>)>
		;<COND (<CORRIDOR-LOOK> <SET X T>)>
		<COND (<ZERO? .X>
		       <TELL "You can't see anything suspicious." CR>)>
		<SETG HERE .OHERE>
		<SETG LIT .OLIT>
		<RTRUE>)>>

<ROUTINE SEE-INTO? (THERE "OPTIONAL" (TELL? T) (IGNORE-DOOR <>)"AUX" P L TBL O)
 ;<COND (<CORRIDOR-LOOK .THERE>
	<RTRUE>)>
 <SET P 0>
 <REPEAT ()
	 <COND (<OR <0? <SET P <NEXTP ,HERE .P>>>
		    <L? .P ,LOW-DIRECTION>>
		<COND (.TELL? <TELL-CANT-FIND>)>
		<RFALSE>)>
	 <SET TBL <GETPT ,HERE .P>>
	 <SET L <PTSIZE .TBL>>
	 <COND (<==? .L ,UEXIT>
		<COND (<==? <GET/B .TBL ,REXIT> .THERE>
		       <RTRUE>)>)
	       (<==? .L ,DEXIT>
		<COND (<==? <GET/B .TBL ,REXIT> .THERE>
		       <COND (<FSET? <GET/B .TBL ,DEXITOBJ> ,OPENBIT>
			      <RTRUE>)
			     (<WALK-THRU-DOOR? .TBL <GET/B .TBL ,DEXITOBJ> <>
								       ;.TELL?>
			      <RTRUE>)
			     (<T? .IGNORE-DOOR>
			      <RTRUE>)
			     (T
			      <COND (.TELL?
				     <SETG CLOCK-WAIT T>
				     <TELL
"(The door to that room is closed.)" CR>)>
			      <RFALSE ;RTRUE>)>)>)
	       (<==? .L ,CEXIT>
		<COND (<==? <GET/B .TBL ,REXIT> .THERE>
		       <COND (<VALUE <GETB .TBL ,CEXITFLAG>>
			      <RTRUE>)
			     (T
			      <COND (.TELL? <TELL-CANT-FIND>)>
			      <RFALSE>)>)>)>>>

<ROUTINE TELL-CANT-FIND ()
	<SETG CLOCK-WAIT T>
	<TELL "(That place isn't close enough.)"
	      ;"You can't seem to find that room." CR>>

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE>)
	       (T <TELL "There's no good surface on" him ,PRSO "." CR>)>>

<ROUTINE V-LOOK-OUTSIDE () <V-LOOK-INSIDE ,P?OUT>>

<ROUTINE PRE-LOOK-UNDER () <ROOM-CHECK>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<DOBJ? EYES HANDS HEAD EARS TEETH>
		<WONT-HELP>)
	       (<HELD? ,PRSO>
		<TELL "You're ">
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "wear">)
		      (T <TELL "hold">)>
		<TELL "ing" the ,PRSO "!" CR>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL "Nope. Nothing hiding under" him ,PRSO "." CR>)
	       (<EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS ;,GLOBAL-OBJECTS>
		<TELL "There's nothing there but dust." CR>)
	       (T
		<TELL "That's not a bit useful." CR>)>>

<ROUTINE V-LOOK-UP ("AUX" HR)
	 <COND (<T? ,PRSI>
		<TELL
"There's no information in" the ,PRSI " about" the ,PRSO "." CR>)
	       (<DOBJ? ROOMS>
		<COND (<OUTSIDE? ,HERE>
		       <PERFORM ,V?EXAMINE ,SKY>
		       <RTRUE>)
		      (T
		       <TELL
"The ceiling is decorated with swirly lines and patterns.">
		       <CRLF>)>)
	       (T <YOU-CANT "look up">)>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Juggling isn't one of your talents." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving" him ,PRSO " reveals nothing." CR>)
	       (T <YOU-CANT ;"move">)>>

<ROUTINE PRE-MOVE-DIR ()
 <COND (<NOT <IOBJ? INTDIR>>
	<DONT-UNDERSTAND>
	<RTRUE>)>>

<ROUTINE V-MOVE-DIR ()
	<TELL
"You can't move" him ,PRSO " in any particular " D ,INTDIR "." CR>>

<ROUTINE V-MUNG ()
	 <COND (<AND <FSET? ,PRSO ,DOORBIT> <ZERO? ,PRSI>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL
"You'd fly through the open door if you tried." CR>)
		      (<UNLOCK-DOOR? ,PRSO>
		       <TELL "Why don't you just open it instead?" CR>)
		      (T <IF-SPY>)>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<IF-SPY>)
	       (T <IKILL "hurt">)>>

<ROUTINE V-NOD ()
 <COND (<NOT <DOBJ? ROOMS>>
	<YOU-CANT>)
       (<T? ,AWAITING-REPLY>
	<PERFORM ,V?YES>
	<RTRUE>)
       (T
	<PERFORM ,V?HELLO ,ROOMS>
	<RTRUE>)>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <EQUAL? ,PRSO ,WINDOW>>>
		<IMPOSSIBLE> ;<YOU-CANT ;"open">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <EQUAL? ,PRSO ,WINDOW>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,LOCKED>
		       <COND (<UNLOCK-DOOR? ,PRSO>
			      <FCLEAR ,PRSO ,LOCKED>
			      <FIRST-YOU "unlock" ,PRSO>)
			     (T <TOO-BAD-BUT ,PRSO "locked"> <RTRUE>)>)>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY ,PRSO "open">)
		      ;(<FSET? ,PRSO ,MUNGBIT>
		       <TELL
"You can't open it. The latch is broken." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <FSET? ,PRSO ,DOORBIT>
				  <EQUAL? ,PRSO ,WINDOW>
				  <NOT <FIRST? ,PRSO>>
				  <FSET? ,PRSO ,TRANSBIT>>
			      <OKAY ,PRSO "open">)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "You open" him ,PRSO !\. CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "You open" him ,PRSO " and see">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <YOU-CANT ;"open">)>>

<ROUTINE V-PANIC ()
	 <TELL "Not surprised." CR>>

;<ROUTINE V-PASS () <PERFORM ,V?WALK-TO ,PRSO> <RTRUE>>

<ROUTINE V-PLAY ()
	 <SETG CLOCK-WAIT T>
	 <TELL
"[Speaking of playing, you'd enjoy Infocom's other fictions, too!]" CR>>

<ROUTINE V-POUR () <HAR-HAR>>

<ROUTINE V-PULL-TOGETHER () <DONT-UNDERSTAND>>

<ROUTINE V-PUSH () <HACK-HACK "Pushing">>

<ROUTINE V-SPUT-ON ()
	<PERFORM ,V?PUT ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE PRE-PUT ()
	 ;<COND (<WEAR-CHECK> <RTRUE>)>
	 <FCLEAR ,PRSO ,WORNBIT>
	 <COND (<DOBJ? HEAD HANDS>
		<WONT-HELP>
		<RTRUE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<IOBJ? FLOOR GLOBAL-HERE <> ;POCKET>
		<RFALSE>)
	       (<AND ;<T? ,PRSI>
		     <IN? ,PRSI ,GLOBAL-OBJECTS>>
		<NOT-HERE ,PRSI>
		<RTRUE>)
	       (<HELD? ,PRSI ,PRSO>
		<YOU-CANT "put" ,PRSI "in it">)>>

<ROUTINE V-PUT ()
	 <COND ;(<FSET? ,PRSI ,PERSONBIT>
		<SETG WINNER ,PRSI>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<COND (T ;<NOT <FSET? ,PRSI ,SURFACEBIT>>
		       <TELL "There's no good surface on" him ,PRSI "." CR>)>
		<RTRUE>)>
	 <PUT-ON-OR-IN>>

<ROUTINE TELL-FIND-NONE (STR "OPTIONAL" (OBJ <>))
	<TELL "You search for " .STR>
	<COND (<T? .OBJ> <TELL the .OBJ>)>
	<TELL " but find none." CR>>

<ROUTINE PRE-PUT-IN ()
 <COND ;(<EQUAL? <GET ,P-OFW 1> ,W?FRONT>
	<PERFORM ,V?DROP ,PRSO>
	<RTRUE>)
       (<IOBJ? PSEUDO-OBJECT>
	<RETURN <PRE-PUT>>)
       ;(<IOBJ? INKWELL MOONMIST>
	<YOU-SHOULDNT " in">
	<RFATAL>)
       (<IOBJ? EYES HANDS>
	<WONT-HELP>
	<RFATAL>)
       (<FSET? ,PRSI ,READBIT>
	<WONT-HELP>
	<RFATAL>)
       (<NOT <FSET? ,PRSI ,CONTBIT>>
	<TELL-FIND-NONE "an opening in" ,PRSI>
	<RFATAL>)>
 <COND (<NOT <FSET? ,PRSI ,OPENBIT>>
	<FIRST-YOU "open" ,PRSI>
	;<TOO-BAD-BUT ,PRSI "closed">)>
 <PRE-PUT>>

<ROUTINE V-PUT-IN ()
	 <COND (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<COND (<OR <FSET? ,PRSI ,CONTBIT>
			   <FSET? ,PRSI ,DOORBIT>>
		       <TOO-BAD-BUT ,PRSI "closed">)
		      (T <TELL "You can't open" him ,PRSI "." CR>)>
		<RTRUE>)>
	 <PUT-ON-OR-IN>>

<CONSTANT NOT-ENOUGH-ROOM "There's not enough room.|">

<ROUTINE PUT-ON-OR-IN ()
	 <COND (<ZERO? ,PRSI> <YOU-CANT ;"put">)
	       (<==? ,PRSI ,PRSO>
		<HAR-HAR>)
	       (<IN? ,PRSO ,PRSI>
		<TOO-BAD-BUT ,PRSO>
		<TELL " is already "
			<COND (<FSET? ,PRSI ,SURFACEBIT> "on") (T "in")>
			him ,PRSI "!" CR>)
	       ;(<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,OPENBIT>>>
		<TOO-BAD-BUT ,PRSI "closed">)
	       (<G? <+ <WEIGHT ,PRSI> <GETP ,PRSO ,P?SIZE>>
		    ;<- * <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL ,NOT-ENOUGH-ROOM>
		<RTRUE>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<COND (<AND <FSET? ,PRSI ,PERSONBIT>
			    <FSET? ,PRSO ,WEARBIT>>
		       <FSET ,PRSO ,WORNBIT>)>
		<TELL "Okay." CR>)>>

"WEIGHT:  Get sum of SIZEs of supplied object," ;" recursing to the nth level."

<ROUTINE WEIGHT (OBJ "AUX" CONT (WT 0))
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<COND ;(<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? .CONT ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"worn things shouldn't count"
			      ;(<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? <LOC .CONT> ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"things in worn things shouldn't count"
			      (T
			       <SET WT <+ .WT <GETP .CONT ,P?SIZE>>>)>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 .WT ;<+ .WT <GETP .OBJ ,P?SIZE>>>

<ROUTINE V-PUT-UNDER () <WONT-HELP>>

<ROUTINE PRE-SREAD () <PERFORM ,V?READ ,PRSI ,PRSO> <RTRUE>>
<ROUTINE V-SREAD () <V-FOO>>

<ROUTINE PRE-READ ("AUX" VAL)
	 <COND ;(<ZERO? ,LIT> <TOO-DARK> <RTRUE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>> <YOU-CANT ;"read">)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-REFUSE ()
	 <SETG PRSA ,V?TAKE>
	 <DONT-F>>

<ROUTINE V-RELAX ()
	 <TELL ,ZEN CR>>

<CONSTANT ZEN "A brave, Zen-like effort. It fails.">

<ROUTINE V-REMOVE ()
	 <COND (<FSET? ,PRSO ,WORNBIT>
		<PERFORM ,V?TAKE-OFF ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-RING () <YOU-CANT>>

<ROUTINE V-RUB ()
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>
		     <NOT <EQUAL? ,PRSO ,PLAYER>>>
		<FACE-RED>)
	       (T <HACK-HACK "Rubbing" ;"Fiddling with">)>>

<ROUTINE V-SAY ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?TELL ,QCONTEXT>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL-I-ASSUME .P " Say to">
	<PERFORM ,V?TELL .P>
	<RTRUE>)
       (T
	<NOT-CLEAR-WHOM>)>>

<ROUTINE PRE-SEARCH () <ROOM-CHECK>>

<ROUTINE V-SEARCH ("AUX" OBJ)
	 <COND (<IN? ,PRSO ,ROOMS>
		<PERFORM ,PRSA ,GLOBAL-HERE>
		<RTRUE>
		;<START-SEARCH>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <SET OBJ <FIRST? ,PRSO>>>
		<FSET .OBJ ,TAKEBIT>
		<FCLEAR .OBJ ,NDESCBIT>
		<FCLEAR .OBJ ,WORNBIT>
		<FCLEAR .OBJ ,SECRETBIT>
		<THIS-IS-IT .OBJ>
		<MOVE .OBJ ,PLAYER>
		;<COND (<EQUAL? .OBJ ,MUSTACHE>
		       <SETG WENDISH-BARE T>)>
		<TELL
"You find " a .OBJ " and take it. " !\Y ,OU-STOP-SEARCHING "." CR>)
	       ;(<AND <SET OBJ <FIND-IN ,PRSO ,SECRETBIT>>
		     ;<FSET? .OBJ ,NDESCBIT>>
		<DISCOVER .OBJ ,PRSO>)
	       (<FSET? ,PRSO ,DOORBIT>
		<NOTHING-SPECIAL>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,SURFACEBIT>>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)
	       (T <NOTHING-SPECIAL>
		;<TELL "You find nothing suspicious." CR>)>>

<CONSTANT OU-STOP-SEARCHING "ou stop searching">

<ROUTINE PRE-SSEARCH-FOR () <PERFORM ,V?SEARCH-FOR ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSEARCH-FOR () <V-FOO>>

<ROUTINE PRE-SEARCH-FOR ("AUX" OBJ)
 <COND (<ROOM-CHECK> <RTRUE>)
       ;(<AND <IN? ,PRSI ,PLAYER>
	     ;<GETP ,PRSI ,P?GENERIC>
	     <SET OBJ <APPLY <GETP ,PRSI ,P?GENERIC> ,PRSI>>>
	<SETG PRSI .OBJ>)>
 ;<COND (<DOBJ? ;GLOBAL-ROOM GLOBAL-HERE>
	<PERFORM ,PRSA ,HERE>
	<RTRUE>)>
 <RFALSE>>

<ROUTINE V-SEARCH-FOR ()
	 <COND (<IN? ,PRSO ,ROOMS>
		<PERFORM ,PRSA ,GLOBAL-HERE ,PRSI>
		<RTRUE>
		;<START-SEARCH>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL "Indeed," he+verb ,PRSO "has" him ,PRSI "." CR>)
		      (T
		       <TELL The ,PRSO " doesn't have">
		       <COND (<IN? ,PRSI ,GLOBAL-OBJECTS>
			      <TELL the ,PRSI "." CR>)
			     (<ZERO? ,PRSI>
			      <TELL " that." CR>)
			     (T
			      <TELL
the ,PRSI " hidden on" his ,PRSO " person." CR>)>)>
		<RTRUE>)
	       (<AND <FSET? ,PRSO ,CONTBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL "You'll have to open" him ,PRSO " first." CR>)
	       (<IN? ,PRSI ,PRSO>
		<COND ;(<FSET? ,PRSI ,SECRETBIT>
		       <DISCOVER ,PRSI>)
		      (T <TELL
"How observant you are! There" he+verb ,PRSI "is" "!" CR>)>)
	       (<ZERO? ,PRSI> <YOU-CANT ;"search">)
	       (T
		<TELL "You don't find">
		<COND (<FSET? ,PRSI ,SECRETBIT>
		       ;<==? <GET ,P-NAMW 1> ,W?EVIDENCE>
		       <TELL " it" ;" any evidence">)
		      (T <TELL him ,PRSI>)>
		<TELL " there." CR>)>>

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<FSET? ,PRSO ,PERSONBIT>
		<TELL "Be real." CR>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<SETG CLOCK-WAIT T>
		<TELL "(You can't shake it if you can't take it!)" CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL
"It sounds as if there is something inside" him ,PRSO "." CR>)
	       (<AND <FSET? ,PRSO ,OPENBIT> <SET X <FIRST? ,PRSO>>>
		<TELL "Right " <GROUND-DESC> " spill">
		<COND (<ZERO? <NEXT? .X>> <TELL !\s>)>
		<ROB ,PRSO ,HERE T>
	        <CRLF>)
	       (T <TELL "You hear nothing inside" him ,PRSO "." CR>)>>

<ROUTINE V-SHOOT ()
 <COND (<AND <OR <ZERO? ,PRSI>
		 <NOT <EQUAL? <LOC ,PRSI> ,WINNER ;,POCKET>>>
	     <NOT <FIND-IN ,WINNER ,WEAPONBIT>>
	     ;<NOT <FIND-IN ,POCKET ,WEAPONBIT>>>
	<TELL "You're not holding anything to shoot with." CR>)
       (T <IKILL "shoot">)>>

<ROUTINE PRE-SSHOOT () <PERFORM ,V?SHOOT ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSHOOT () <V-FOO>>

<ROUTINE V-SHOW ()
	 <COND (<==? ,PRSO ,PLAYER>
		<SETG WINNER ,PLAYER>
		<COND (<VISIBLE? ,PRSO> <PERFORM ,V?EXAMINE ,PRSI>)
		      (T <PERFORM ,V?FIND ,PRSI>)>
		<RTRUE>)
	       (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <FSET? ,PRSO ,MUNGBIT>>
		<TELL "Don't wait for" him ,PRSO " to applaud." CR>)
	       (T <WHO-CARES>)>>

<ROUTINE PRE-SSHOW ("AUX" P)
  <COND (<T? ,PRSI>
	 ;<SETG P-MERGED T>
	 <COND (<IN? ,PRSI ,ROOMS>	;"SHOW ME TO MY ROOM"
		<PERFORM ,V?TAKE-TO ,PRSO ,PRSI>
		<RTRUE>)>
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>)
	(<NOT <HELD? ,PRSO>>
	 <COND (<FSET? <LOC ,PRSO> ,PERSONBIT>
		<PERFORM ,V?TAKE ,PRSO>)
	       (T
		<TELL-I-ASSUME ,PRSO " Ask about">
		<PERFORM ,V?ASK-CONTEXT-ABOUT ,PRSO>)>
	 <RTRUE>)
	(<QCONTEXT-GOOD?>
	 <PERFORM ,V?SHOW ,QCONTEXT ,PRSO>
	 <RTRUE>)
	(<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	 <TELL-I-ASSUME .P " Show">
	 <PERFORM ,V?SHOW .P ,PRSO>
	 <RTRUE>)
	(T
	 <TELL-I-ASSUME ,PLAYER " Show">
	 <PERFORM ,V?SHOW ,PLAYER ,PRSO>
	 <RTRUE>)>>

<ROUTINE V-SSHOW () <V-FOO>>

<ROUTINE PRE-SIT () <ROOM-CHECK>>

<ROUTINE V-SIT ("OPTIONAL" (LIE? <>))
 <COND (<AND <==? ,WINNER ,PLAYER>
	     <OR <FSET? ,PRSO ,VEHBIT>
		 <AND <DOBJ? GLOBAL-HERE HERE FLOOR>
		      ;<FSET? ,HERE ,SURFACEBIT>>>>
	<TELL "You're now ">
	<COND (<ZERO? .LIE?>
	       ;<SETG PLAYER-SEATED ,PRSO>
	       <TELL "sitt">)
	      (T
	       ;<SETG PLAYER-SEATED <- 0 ,PRSO>>
	       <TELL "ly">)>
	<COND (<FSET? ,PRSO ,VEHBIT>
	       <MOVE ,PLAYER ,PRSO>)>
	<TELL "ing ">
	<COND (<FSET? ,PRSO ,SURFACEBIT> <TELL "on">) (T <TELL "in">)>
	<TELL the ;him ,PRSO "." CR>)
       (T <WONT-HELP>)>>

<ROUTINE V-SIT-AT () <V-SIT>>

<ROUTINE V-SLAP ()
 <COND (<IOBJ? ROOMS> <SETG PRSI <>>)>
 <COND ;(<AND ,PRSI <NOT-HOLDING? ,PRSI>>
	<RTRUE>)
       (<DOBJ? PLAYER>
	<TELL
"That sounds like a sign you could wear on your back." CR>)
       (<NOT <FSET? ,PRSO ,PERSONBIT>>
	<IF-SPY>)
       (<FSET? ,PRSO ,MUNGBIT>
	<TELL
"If" he ,PRSO " could," he ,PRSO " would slap you right back." CR>)
       (T <FACE-RED>)>>

<ROUTINE IF-SPY ()
	;<COND (<NOT <FSET? ,PRSO ,PERSONBIT>> <TELL "break">)
	      (T <TELL "drop">)>
	<COND (<ZERO? ,PRSI>
	       <TELL "You give" him ,PRSO " a swift ">
	       <COND (<==? ,P-PRSA-WORD ,W?KICK>
		      <TELL "kick">)
		     (T <TELL "hand chop">)>)
	      (T <TELL "You swing" him ,PRSI " at" him ,PRSO>)>
	<TELL ", but" he ,PRSO " seems indestructible." CR>>

<ROUTINE FACE-RED ("OPTIONAL" (P 0) "AUX" X)
	<COND (<ZERO? .P> <SET P ,PRSO>)>
	<UNSNOOZE .P>
	;<SET X <GETP .P ,P?LINE>>
	;<PUTP .P ,P?LINE <+ 1 .X>>
	<COND (<EQUAL? ,FOLLOWER .P>
	       <SETG FOLLOWER <>>)>
	<COND (<NOT <EQUAL? <GETP .P ,P?LDESC>
			    4 ;"looking at you with suspicion">>
	       ;<EQUAL? .P ,FRIEND>
	       <PUTP .P ,P?LDESC 20 ;"ignoring you">)>
	<TELL He .P>
	<COND ;(<ZERO? .X>
	       <TELL " looks at you as if you were insane." CR>)
	      (T <TELL " gives you a good slap. It hurts, too!"
		       ;" slaps you right back. Wow, is your face red!" CR>)>>

<ROUTINE V-SMELL ()
	<TELL He+verb ,PRSO "smell" " just like " a ,PRSO "!" CR>>

<ROUTINE V-SMILE () <TELL "How nice." CR>>

<ROUTINE V-SORRY ()
 <COND ;(<==? ,PRSO ,CONFESSED>
	<WONT-HELP-TO-TALK-TO ,PRSO>)
       (<NOT <GRAB-ATTENTION ,PRSO>>
	<RFATAL>)
       ;(<NOT <L? 0 <GETP ,PRSO ,P?LINE>>>
	<TELL "\"I'm not angry with" him ,WINNER " now.\"" CR>)
       (T
	;<PUTP ,PRSO ,P?LINE 0 ;<- <GETP ,PRSO ,P?LINE> 1>>
	<COND (T ;<EQUAL? ,PRSO ,FRIEND>
	       <PUTP ,PRSO ,P?LDESC 3 ;"watching you">)>
	<TELL "\"Apology accepted.\"" CR>)>>

<ROUTINE V-STAND ("AUX" P)
	 <COND (<FSET? <LOC ,WINNER> ,VEHBIT>
		<PERFORM ,V?DISEMBARK <LOC ,WINNER>>
		<RTRUE>)
	       (<AND ;<==? ,WINNER ,PLAYER>
		     <NOT <IN? ,WINNER ,HERE>>>
		<OWN-FEET>)
	       (<AND <T? ,PRSO>
		     <FSET? ,PRSO ,TAKEBIT>>
		<WONT-HELP>)
	       (T
		<ALREADY ,WINNER "standing up">)>>

<ROUTINE V-STOP ()
	<COND (<EQUAL? ,PRSO <> ,GLOBAL-HERE>
	       <TELL "Hey, no problem." CR>)
	      (<FSET? ,PRSO ,PERSONBIT>
	       <PERFORM ,V?$CALL ,PRSO>
	       <RTRUE>)
	      (T
	       <PERFORM ,V?LAMP-OFF ,PRSO>
	       <RTRUE>)>>

<ROUTINE V-SWIM ()
	 <SETG CLOCK-WAIT T>
	 <TELL "(" He ,WINNER " can't swim ">
	 <COND (<T? ,PRSO>
	        <TELL "in" him ,PRSO>)
	       (T
		<TELL <GROUND-DESC>>)>
	 <TELL ".)" CR>>

<ROUTINE PRE-TAKE ("AUX" L)
	 <COND (<DOBJ? ;NOW-WEARING FLOOR WALL ;KEYHOLE>
		<HAR-HAR>)
	       (<DOBJ? HANDS YOU>
		<RFALSE>)
	       (<==? <SET L <LOC ,PRSO>> ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<EQUAL? ,PRSO <LOC ,WINNER>>
		<TELL "You are in it!" CR>)
	       (<AND .L
		     <FSET? .L ,CONTBIT>
		     <NOT <FSET? .L ,OPENBIT>>>
		<TOO-BAD-BUT .L "closed">
		<RTRUE>)
	       (<T? ,PRSI>
		<COND (<EQUAL? ,PRSI ,WALL ;,POCKET .L>
		       <SETG PRSI <>>
		       <RFALSE>)
		      (<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
			    <NOT <FSET? ,PRSI ,OPENBIT>>
			    <NOT <FSET? ,PRSI ,PERSONBIT>>>
		       <TOO-BAD-BUT ,PRSI "closed">
		       <RTRUE>)
		      (<NOT <==? ,PRSI .L>>
		       <TELL He+verb ,PRSO "is" "n't ">
		       <COND (<AND <FSET? ,PRSI ,PERSONBIT>
				   ;<NOT <PRSI? ,NUTRIMAT ,SCREENING-DOOR>>>
			      <TELL "being held by">)
			     (<FSET? ,PRSI ,SURFACEBIT>
			      <TELL "on">)
			     (T
			      <TELL "in">)>
		       <TELL the ,PRSI "." CR>)>)
	       (T <PRE-TAKE-WITH>)>>

<ROUTINE PRE-TAKE-WITH ("AUX" X)
	 <COND (<DOBJ? YOU>
		<RFALSE>)
	       (<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
		<COND (<AND <NOT <HELD? ,PRSO>>
			    <NOT <FSET? ,PRSO ,PERSONBIT>>>
		       <NOT-HERE ,PRSO>)>)
	       (<IN? ,PRSO ,WINNER>
		<ALREADY ,PLAYER>
		<TELL "holding" the ,PRSO "!)" CR>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<YOU-CANT "reach">)
	       (<AND <IN? ,WINNER ,PRSO>
		     <NOT <NOUN-USED? ,PRSO ,W?DOOR ;,W?KEYHOLE>>>
		<SETG CLOCK-WAIT T>
		<TELL
!\( He+verb ,WINNER "is" " in" him ,PRSO ", nitwit!)" CR>)>>

<ROUTINE V-TAKE ()
 <COND (<==? <ITAKE> T>
	<TELL He+verb ,WINNER "is" " now holding" the ;him ,PRSO "." CR>)>>

<ROUTINE V-TAKE-OFF ()
	 <COND ;(<DOBJ? NOW-WEARING>
		<SETG PRSO <>>
		<V-WEAR>
		<RTRUE>)
	       ;(<WEAR-CHECK>
		<RTRUE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,WORNBIT>
		<TELL "Okay," he+verb <LOC ,PRSO> "is" " no longer wearing">
		<MOVE ,PRSO ,WINNER>
		<TELL him ,PRSO "." CR>)
	       (T
		<TELL He+verb <LOC ,PRSO> "is" "n't wearing" him ,PRSO "!" CR>)>>

<ROUTINE V-TAKE-TO ()	;"Parser should have ITAKEn PRSO."
	<PERFORM ,V?WALK-TO ,PRSI>
	<RTRUE>>

<ROUTINE V-DISEMBARK ()
	 <COND (<ROOM-CHECK>
		<RTRUE>)
	       (<DOBJ? ROOMS HERE GLOBAL-HERE ;GLOBAL-WATER>
		<COND (<AND <==? ,WINNER ,PLAYER>
			    <NOT <IN? ,PLAYER ,HERE>>
			    ;<T? ,PLAYER-SEATED>>
		       <OWN-FEET>)
		      (T
		       <DO-WALK ,P?OUT>
		       <RTRUE>)>)
	       ;(<DOBJ? NOW-WEARING>
		<V-TAKE-OFF>
		<RTRUE>)
	       (<==? <LOC ,PRSO> ,WINNER>
		<TELL
"You don't need to take" him ,PRSO " out to use" him ,PRSO "." CR>)
	       ;(<==? <LOC ,PRSO> ,POCKET>
		<MOVE ,PRSO ,WINNER>
		<TELL He+verb ,WINNER "is" " now holding" him ,PRSO "." CR>)
	       (<AND <NOT <==? <LOC ,WINNER> ,PRSO>>
		     <NOT <IN? ,PLAYER ,PRSO>>
		     ;<NOT <EQUAL? ,PLAYER-SEATED ,PRSO <- 0 ,PRSO>>>>
		<TELL "You're not ">
		<COND (<FSET? ,PRSO ,SURFACEBIT> <TELL "on">) (T <TELL "in">)>
		<TELL him ,PRSO "!|">
		<RFATAL>)
	       (T
		<OWN-FEET>)>>

<ROUTINE OWN-FEET ()
	 <MOVE ,WINNER ,HERE>
	 ;<COND (<==? ,WINNER ,PLAYER>
		<SETG PLAYER-SEATED <>>)>
	 <TELL He+verb ,WINNER "is" " on" his ,WINNER " own feet again." CR>
	 <RTRUE>>

<ROUTINE V-HOLD-UP ()
 <COND (<DOBJ? ROOMS>
	<PERFORM ,V?STAND>
	<RTRUE>)
       (T
	<WONT-HELP>
	;<TELL "That doesn't seem to help at all." CR>)>>

<ROUTINE V-TELL ("AUX" P)
	 <COND (<==? ,PRSO ,PLAYER>
		<COND (<NOT <==? ,WINNER ,PLAYER>>
		       <SET P ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .P>
		       <RTRUE>)
		      (<T? ,QCONTEXT>
		       <SETG QCONTEXT <>>
		       <COND (<T? ,P-CONT>
			      <SETG WINNER ,PLAYER>)
			     (T <TELL
"Okay, you're not talking to anyone else." CR>)>)
		      (T
		       <WONT-HELP-TO-TALK-TO ,PLAYER>
		       ;<SETG QUOTE-FLAG <>>
		       <SETG P-CONT <>>
		       <RFATAL>)>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<UNSNOOZE ,PRSO>
		<SETG QCONTEXT ,PRSO>
		<COND (<T? ,P-CONT>
		       <SETG CLOCK-WAIT T>
		       <SETG WINNER ,PRSO>
		       ;<SETG HERE <LOC ,WINNER>>
		       <RTRUE>)
		      (T
		       <TELL "Hmmm ...">
		       <TELL the ,PRSO>
		       <TELL
" looks at you expectantly, as if you seemed to be about to talk." CR>)>)
	       (T
		<WONT-HELP-TO-TALK-TO ,PRSO>
		;<YOU-CANT "talk to">
		;<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE PRE-STELL-ABOUT () <PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-STELL-ABOUT () <V-FOO>>

<ROUTINE PRE-TELL-ABOUT ("AUX" P)
 <COND (<DOBJ? PLAYER ;PLAYER-NAME>
	<COND (<QCONTEXT-GOOD?>
	       <PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSI>)
	      (<AND <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	       <TELL-I-ASSUME .P " Ask">
	       <PERFORM ,V?ASK-ABOUT .P ,PRSI>)
	      (T <ARENT-TALKING>)>
	<RTRUE>)
       (<AND <NOT <FSET? ,PRSI ,SEENBIT>>
	     <NOT <FSET? ,PRSI ,TOUCHBIT>>>
	<NOT-FOUND ,PRSI>
	<RTRUE>)
       ;(<OR <EQUAL? ,PRSI ,BRICKS ,COFFIN ,CRYPT>
	    <EQUAL? ,PRSI ,DUNGEON ,IRON-MAIDEN ,TOMB>
	    <EQUAL? ,PRSI ,WELL>>
	<TELL ,ANCIENT-SECRETS CR>)
       (T <PRE-ASK>)>>

<ROUTINE V-TELL-ABOUT ("AUX" P)
	<TELL "It doesn't look as if" the ,PRSO " is interested."
;"\"I'm afraid you'll have to show me instead of telling me.\"" CR>
	<RTRUE>>

<ROUTINE PRE-TALK-ABOUT ("AUX" P)
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<SET P ,WINNER>
	<SETG WINNER ,PLAYER>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)
       (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL-I-ASSUME .P " to">
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-TALK-ABOUT () <ARENT-TALKING>>

;<CONSTANT QUITE-WELCOME "\"You're quite welcome, I'm sure.\"|">

<ROUTINE V-THANK ("AUX" P)
  <COND (<T? ,PRSO>
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<TELL
"You do so, but" the ,PRSO " seems less than overjoyed." CR>
		<RTRUE>)
	       (T <HAR-HAR>)>)
	(T
	 <COND (<OR <SET P <QCONTEXT-GOOD?>>
		    <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
		<PERFORM ,V?THANK .P>
		<RTRUE>)
	       (T <TELL "You're more than welcome." CR>)>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-THROW-AT ()
	 <COND (<NOT <IDROP>>
		<RTRUE>)>
	 <COND ;(<AND <FSET? ,PRSI ,PERSONBIT>
		     <NOT <FSET? ,PRSI ,MUNGBIT>>>
		<TELL He+verb ,PRSI "duck">)
	       (T <TELL He+verb ,PRSI "do" "n't duck">)>
	 <TELL " as" he ,PRSO " flies by." CR>>

<ROUTINE V-THROW-IN-TOWEL ()
	 <COND (<DOBJ? TOWEL>
		<V-QUIT>)
	       (T
		<DONT-UNDERSTAND>)>>

<ROUTINE PRE-THROW-THROUGH ()
	<FCLEAR ,PRSO ,WORNBIT>
	<RFALSE>>

<ROUTINE V-THROW-THROUGH ()
	 <COND (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "Let's not resort to vandalism, please." CR>)
	       (T <V-THROW>)>>

<ROUTINE V-TURN ()
 <COND (<AND <FSET? ,PRSO ,DOORBIT> <FSET? ,PRSO ,OPENBIT>>
	<PERFORM ,V?CLOSE ,PRSO>
	<RTRUE>)
       (T <TELL "What do you want that to do?" CR>)>>

<ROUTINE V-UNLOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <AND <FSET? ,PRSO ,CONTBIT>
			 <NOT <ZERO? <GETP ,PRSO ,P?CAPACITY>>>>>
		<COND (<NOT <FSET? ,PRSO ,LOCKED>>
		       <ALREADY ,PRSO "unlocked">)
		      (<ZERO? <UNLOCK-DOOR? ,PRSO>>
		       <YOU-CANT>)
		      (T
		       ;<COND (<FSET? ,PRSO ,OPENBIT>
			      <FCLEAR ,PRSO ,OPENBIT>
			      <FIRST-YOU "close" ,PRSO>)>
		       <FCLEAR ,PRSO ,LOCKED>
		       <OKAY ,PRSO "unlocked">)>)
	       (T
		<SETG CLOCK-WAIT T>
		<TELL !\( He+verb ,PRSO "is" "n't locked!)" CR>)>>

<ROUTINE V-USE () <MORE-SPECIFIC>>

"V-WAIT has three modes, depending on the arguments:
1) If only one argument is given, it will wait for that many moves.
2) If a second argument is given, it will wait the least of the first
   argument number of moves and the time at which the second argument
   (an object) is in the room with the player.
3) If the third argument is given, the second should be FALSE.  It will
   wait <first argument> number of moves (or at least try to).  The
   third argument means that an 'internal wait' is happening (e.g. for
   a 'careful' search)."

;<GLOBAL WHO-WAIT:NUMBER 0>

<GLOBAL KEEP-WAITING <>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM -1) (WHO <>) (INT <>)
		 "AUX" (WHO-WAIT 0) VAL HR (RESULT T))
	 <COND (<==? -1 .NUM>
		<SET NUM 10>)>
	 <COND (<AND <ZERO? .INT>
		     <AND <NOT <FSET? ,PRSO ,PERSONBIT>>
			  <NOT <DOBJ? INTNUM TURN>>>>
		<TELL ,I-ASSUME " Wait " N .NUM " minute">
		<COND (<NOT <1? .NUM>>
		       <TELL !\s>)>
		<TELL ".]" CR>)>
	 <SET HR ,HERE>
	 <COND (<NOT .INT> <TELL "Time passes..." CR>)>
	 <DEC NUM>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0>
			<SETG KEEP-WAITING <>>
			<RETURN>)
		       (<SET VAL <CLOCKER>>
			<COND (<OR <==? .VAL ,M-FATAL>
				   <NOT <==? .HR ,HERE>>>
			       <SETG CLOCK-WAIT T>
			       <SET RESULT ,M-FATAL>
			       <RETURN>)
			      ;(<0? .NUM> <RETURN>)
			      (<AND .WHO <IN? .WHO ,HERE>>
			       <SETG CLOCK-WAIT T>
			       <NOT-IT .WHO>
			       <TELL The .WHO ", for wh">
			       <COND (<FSET? .WHO ,PERSONBIT>
				      <TELL "om">)
				     (T <TELL "ich">)>
			       <TELL " you're waiting, has arrived." CR>
			       <RETURN>)
			      (T
			       <SET WHO-WAIT <+ .WHO-WAIT 1>>
			       <COND (<T? ,KEEP-WAITING>
				      <VERSION? (ZIP <USL>)
						(T <UPDATE-STATUS-LINE>)>
				      <AGAIN>)>
			       <TELL "Do you want to keep ">
			       <SET VAL <VERB-PRINT T>>
			       <COND (<YES?>
				      <VERSION? (ZIP <USL>)
						(T <UPDATE-STATUS-LINE>)>)
				     (T
				      <SETG CLOCK-WAIT T>
				      <SET RESULT ,M-FATAL>
				      <RETURN>)>)>)
		       (<AND .WHO <G? <SET WHO-WAIT <+ .WHO-WAIT 1>> 30>>
			<SET VAL <START-SENTENCE .WHO>>
			<TELL
" still hasn't arrived. Do you want to keep waiting?">
			<COND (<NOT <YES?>> <RETURN>)>
			<SET WHO-WAIT 0>
			<VERSION? (ZIP <USL>)
				  (T <UPDATE-STATUS-LINE>)>)
		       (T
			<VERSION? (ZIP <USL>)
				  (T <UPDATE-STATUS-LINE>)>)>>
	 .RESULT>

<ROUTINE V-WAIT-FOR ("AUX" WHO)
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>>
		     <DOBJ? ROOMS TURN INTNUM>>
		<COND ;(<T? ,P-TIME>
		       <V-WAIT-UNTIL>)
		      (T <V-WAIT ,P-NUMBER>)>)
	       (<DOBJ? ROOMS TURN GLOBAL-HERE>
		<V-WAIT>)
	       (<DOBJ? PLAYER>
		<ALREADY ,PLAYER "here">)
	       (<OR <FSET? ,PRSO ,PERSONBIT>
		    ;<DOBJ? GHOST-NEW>>
		<COND (<==? <META-LOC ,PRSO> ,HERE>
		       <ALREADY ,PRSO "here">)
		      (T <V-WAIT 10000 ,PRSO>)>)
	       (T <TELL "Not a good idea. You might wait forever." CR>)>>

<ROUTINE V-WAIT-UNTIL ("AUX" N)
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>>
		     <DOBJ? ROOMS TURN INTNUM>>
		<SET N ,P-NUMBER>
		<COND ;(<G? .N ,PRESENT-TIME>
		       <V-WAIT <- .N ,PRESENT-TIME>>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "(It's already past that time!)" CR>)>)
	       (T <YOU-CANT "wait until">)>>

<ROUTINE V-ALARM ()
	 <COND (<==? ,PRSO ,ROOMS>
		<PERFORM ,V?ALARM ,WINNER>
		<RTRUE>)
	       (T
		<TOO-BAD-BUT ,PRSO "not asleep">)>>

<ROUTINE DO-WALK (DIR "AUX" P)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<ROUTINE V-WALK ("AUX" PT PTS STR RM)
	 <COND (<ZERO? ,P-WALK-DIR>
		<COND (<AND <==? ,PRSO ,P?IN>
			    <OR <IN? ,P-IT-OBJECT ,ROOMS>
				<FSET? ,P-IT-OBJECT ,VEHBIT>
				<FSET? ,P-IT-OBJECT ,CONTBIT>>>
		       <TELL-I-ASSUME ,P-IT-OBJECT ;" Go in">
		       <PERFORM ,V?THROUGH ,P-IT-OBJECT>
		       <RTRUE>)
		      (T
		       <V-WALK-AROUND>
		       <RFATAL>)>)>
	 <COND (<SET PT <GETPT <LOC ,WINNER> ,PRSO>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <COND (<GOTO <GET/B .PT ,REXIT>> <OKAY>)>
		       <RTRUE>)
		      (<==? .PTS ,NEXIT>
		       <SETG CLOCK-WAIT T>
		       <TELL !\( <GET .PT ,NEXITSTR> !\) CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <COND (<GOTO .RM> <OKAY>)>
			      <RTRUE>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <COND (<GOTO <GET/B .PT ,REXIT>> <OKAY>)>
			      <RTRUE>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <YOU-CANT "go">
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<WALK-THRU-DOOR? .PT>
			      <COND (<GOTO <GET/B .PT ,REXIT>> <OKAY>)>
			      <RTRUE>)
			     (T <RFATAL>)>)>)
	       (<EQUAL? ,PRSO ,P?IN ,P?OUT>
		<V-WALK-AROUND>)
	       (<EQUAL? ,PRSO ,P?UP>
		<PERFORM ,V?CLIMB-UP ,STAIRS>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,P?DOWN>
		<PERFORM ,V?CLIMB-DOWN ,STAIRS>
		<RTRUE>)
	       (T
		<YOU-CANT "go">
		<RFATAL>)>>

<ROUTINE UNLOCK-DOOR? (DR)
 <COND (<EQUAL? ,HERE .DR>
	<RTRUE>)
       ;(<EQUAL? ,HERE <GETP ,HERE ,P?STATION>>
	<RFALSE>)
       ;(<EQUAL? .DR ,SECRET-SITTING-DOOR ,FRONT-GATE>
	<RFALSE>)
       (T <RTRUE>)>>

<ROUTINE WALK-THRU-DOOR? (PT "OPTIONAL" (OBJ 0) (TELL? T)
			     "AUX" RM)
	<COND (<ZERO? .OBJ>
	       <SET OBJ <GET/B .PT ,DEXITOBJ>>)>
	;<SET RM <GET/B .PT ,REXIT>>
	<COND (<FSET? .OBJ ,OPENBIT>
	       <RTRUE>)
	      (<AND <FSET? .OBJ ,SECRETBIT>
		    <NOT <FSET? .OBJ ,TOUCHBIT ;,SEENBIT>>>
	       <COND (<EQUAL? <> .TELL? ,VERBOSITY>
		      <RFALSE>)
		     (<NOT <FSET? ,HERE ,SECRETBIT>>
		      <YOU-CANT "go">
		      <RFALSE>)
		     (<ZERO? ,LIT>
		      <NOT-FOUND .OBJ>
		      <RFALSE>)
		     (T
		      <COND (<NOT <VERB? WALK-TO>>
			     <OPEN-DOOR-AND-CLOSE-IT-AGAIN .OBJ>)>
		      <RTRUE>)>)
	      (<NOT <FSET? .OBJ ,LOCKED>>
	       <COND (<NOT <VERB? WALK-TO>>
		      <FCLEAR .OBJ ,SECRETBIT>
		      <FSET .OBJ ,SEENBIT ;,TOUCHBIT>
				;"Don't put TOUCHBIT on ROOM"
		      <COND (<NOT <EQUAL? <> .TELL? ,VERBOSITY>>
			     <OPEN-DOOR-AND-CLOSE-IT-AGAIN .OBJ>)>)>
	       <RTRUE>)
	      (<AND <T? .PT>
		    <SET RM <GET .PT ,DEXITSTR>>>
	       <COND (<T? .TELL?>
		      <TELL .RM CR>)>
	       <RFALSE>)
	      (T
	       <COND (<ZERO? .TELL?>
		      <RFALSE>)
		     (<T? <UNLOCK-DOOR? .OBJ>>
		      <COND (<AND <NOT <VERB? WALK-TO>>
				  <T? ,VERBOSITY>>
			     <OPEN-DOOR-AND-CLOSE-IT-AGAIN .OBJ>)>
		      <RTRUE>)
		     ;(<IN? .OBJ ,ROOMS>
		      ;<COND (<VERB? WALK-TO>
			     <TELL ", but t">)
			    (T )>
		      <TELL "The door is locked." CR>
		      ;<COND (<NOT <VERB? WALK-TO>>
			     )>)
		     (T <TOO-BAD-BUT .OBJ "locked">)>
	       <THIS-IS-IT .OBJ>
	       <RFALSE>)>>

<ROUTINE OPEN-DOOR-AND-CLOSE-IT-AGAIN (OBJ)
	<FSET .OBJ ,SEENBIT ;,TOUCHBIT>	;"Don't put TOUCHBIT on ROOM"
	<COND (<NOT <==? ,WINNER ,PLAYER>>
	       <RTRUE>)>
	<TELL "(You ">
	<COND (<FSET? .OBJ ,LOCKED>
	       <FCLEAR .OBJ ,LOCKED>
	       <TELL "unlock and ">)>
	<TELL "open the ">
	<COND ;(<EQUAL? .OBJ ,FRONT-GATE> <TELL "gate">)
	      (T <TELL "door">)>
	<COND (<FSET? .OBJ ,SECRETBIT>
	       <FSET .OBJ ,OPENBIT>)
	      (T <TELL " and close it again">)>
	<TELL ".)" CR>>

<ROUTINE V-WALK-AROUND ()
	 <SETG CLOCK-WAIT T>
	 <TELL !\[ ,WHICH-DIR "]|">
	 <RFATAL>>

<CONSTANT WHICH-DIR "Which direction do you want to go in?">

<ROUTINE WHO-KNOWS? (OBJ)
	<SETG CLOCK-WAIT T>
	<TELL "(You have no idea where" the ,PRSO " is.)" CR>>

<ROUTINE WALK-WITHIN-ROOM () <NO-NEED "move around within" ,HERE ;" a place">>

<ROUTINE V-WALK-TO ()
	 <COND (<OR <IN? ,PRSO ,HERE>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL He ,PRSO "'s here!" CR>)
	       (T
		<V-WALK-AROUND>)>>

<ROUTINE ENTER-ROOM ("AUX" VAL)
	<SETG LIT <LIT? ;,HERE>>
	;<COND (<FSET? ,HERE ,SECRETBIT>
	       <SETG WASHED <>>)>
	<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	<SET VAL <V-FIRST-LOOK>>
	<APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>
	.VAL>

;<ROUTINE V-WALK-UNDER () <YOU-CANT "go under">>

<ROUTINE V-RUN-OVER () <TELL "That doesn't make much sense." CR>>

;<CONSTANT NO-CHANGING
"Before you unfasten even the first button, you decide
that this isn't a good place to undress.|">

;<ROUTINE NO-CHANGING? ("AUX" X)
 ;<SET X <FIRST? ,HERE>>
 ;<REPEAT ()
	 <COND (<ZERO? .X> <RETURN>)
	       (<AND <FSET? .X ,PERSONBIT>
		     <NOT <FSET? .X ,MUNGBIT>>
		     <NOT <FSET? .X ,RMUNGBIT>>
		     <NOT <FSET? .X ,NDESCBIT>>
		     <NOT <EQUAL? .X ,WINNER>>>
		<RETURN>)
	       (T <SET X <NEXT? .X>>)>>
 <COND (<SET X <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<COND ;(<EQUAL? .X ,GHOST-NEW>
	       <TELL ,NO-CHANGING>
	       <RTRUE>)
	      (T <TELL
He .X " says, \"I wish you wouldn't change clothes while I'm here!\"" CR>
	       <RTRUE>)>)
       (T
	<TELL ,NO-CHANGING>
	<RTRUE>)>>

;<ROUTINE V-WEAR ("AUX" X)
	<COND (<NOT <ZERO? ,PRSO>>
	       <COND (<NOT <FSET? ,PRSO ,WEARBIT>>
		      <TELL He ,WINNER " can't wear" him ,PRSO>
		      ;<COND (<DOBJ? NECKLACE-OF-D>
			     <TELL ", because" ,CLASP-MUNGED>)>
		      <TELL "." CR>
		      <RTRUE>)
		     (<FSET? ,PRSO ,WORNBIT>
		      <ALREADY ,PRSO "being worn">
		      <RTRUE>)>)>
	<COND (T ;<NOT <DOBJ? NECKLACE ;NECKLACE-OF-D EARRING ;HEADDRESS
			   ;WIG LENS LENS-1 LENS-2>>
	       <COND (<NO-CHANGING?>
		      <RTRUE>)
		     (<NOT <ZERO? ,NOW-WEARING>>
		      ;<MOVE ,NOW-WEARING ,WINNER>
		      <COND (<T? ,PRSO>
			     <FIRST-YOU "remove" ,NOW-WEARING>)>
		      <FCLEAR ,NOW-WEARING ,WORNBIT>
		      ;<SETG NOW-WEARING <>>)>
	       <SETG NOW-WEARING ,PRSO>)>
	<COND (<NOT <ZERO? ,PRSO>>
	       <MOVE ,PRSO ,PLAYER ;,GLOBAL-OBJECTS>
	       <FSET ,PRSO ,WORNBIT>
	       <COND (<OR ;<DOBJ? NECKLACE ;NECKLACE-OF-D EARRING ;HEADDRESS
				 ;WIG LENS LENS-1 LENS-2>
			  <FSET? ,PRSO ,MUNGBIT>>
		      <TELL "Okay." CR>)
		     (T
		      <FSET ,PRSO ,MUNGBIT>
		      <TELL
"Ahhh! Nothing like a new outfit to change your whole outlook!" CR>)>
	       <RTRUE>)
	      (T
	       <TELL "Okay... ">
	       <COND ;(<ZERO? ,GENDER-KNOWN>
		      <TELL "You immediately wish for central heating!" CR>)
		     (T
		      <TELL "My, what a fine figure of a ">
		      <COND (<FSET? ,PLAYER ,FEMALEBIT> <TELL "wo">)>
		      <TELL "man!" CR>)>)>>

<ROUTINE V-YELL () <TELL "You begin to get a sore throat." CR>>

<ROUTINE V-YES ("OPTIONAL" (NO? <>) "AUX" PER)
 <COND (<OR <NOT <==? <SET PER ,WINNER> ,PLAYER>>
	    ;<AND <T? ,AWAITING-REPLY>
		 <SET PER <GETB ,QUESTIONERS ,AWAITING-REPLY>>>
	    <SET PER <QCONTEXT-GOOD?>>>
	<COND (<NOT <D-APPLY "Actor" <GETP .PER ,P?ACTION> ,M-WINNER>>
	       ;<TELL "\"I see...\"" CR>
	       <SETG CLOCK-WAIT T>
	       <TELL "(That was just a rhetorical question.)" CR>)>
	<RTRUE>)
       (T
	<TELL "You sound rather ">
	<COND (.NO? <TELL "neg">) (T <TELL "pos">)>
	<TELL "ative." CR>)>>

<ROUTINE V-NO () <V-YES T>>

<ROUTINE JIGS-UP ("OPT" DESC)
	 <COND (<ASSIGNED? DESC>
		<TELL .DESC>)>
	 <TELL "|
|
    ****  You have died  ****||">
	 <FINISH>>

<ROUTINE FINISH ("OPTIONAL" (REPEATING <>) VAL)
	 %<DEBUG-CODE <COND (<T? ,P-DBUG> <RTRUE>)>>
	 <CRLF>
	 <CRLF>
	 <COND (<NOT .REPEATING>
		<V-SCORE>
		<CRLF>)>
	 <TELL "Would you like to:|">
	 <COND (<T? ,P-CAN-UNDO>
		<TELL
"   UNDO your last action,|">)>
	 <TELL
"   RESTORE your place from where you saved it,|
   RESTART the story from the beginning, or|
   QUIT for now?" CR>
	<REPEAT ()
	 <TELL !\>>
	 ;<VERSION? (XZIP )>
	 <PUTB ,P-INBUF 1 0>
	 <READ ,P-INBUF ,P-LEXV>
	 <SET VAL <GET ,P-LEXV ,P-LEXSTART>>
	 <COND (<AND <NOT <0? .VAL>>
		     <SET VAL <WORD-VERB-STUFF .VAL>>
		     <L=? 0 <SET VAL <VERB-ZERO .VAL>>>>
		;<SET VAL <WT? .VAL ,PS?VERB ,P1?VERB>>
		<COND (<AND <T? ,P-CAN-UNDO>
			    <EQUAL? .VAL ,ACT?UNDO>>
		       <V-UNDO>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?RESTART>
		       <RESTART>
		       ;<TELL-FAILED>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?RESTORE>
		       <COND (<V-RESTORE> <RETURN>)>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?QUIT>
		       <QUIT>)>)>
	 <TELL "[Type ">
	 <COND (<T? ,P-CAN-UNDO>
		<TELL "UNDO, ">)>
	 <TELL "RESTORE, RESTART, or QUIT.] ">>>

<ROUTINE V-UNDO ()
 <COND (<T? ,P-CAN-UNDO>
	<SETG OLD-HERE <>>
	<COND (<ZERO? <IRESTORE>>
	       <TELL "[UNDO failed.]" CR>)
	      (T
	       <TELL "[UNDO is not available.]" CR>)>
	<RTRUE>)>>

;<ROUTINE DIVESTMENT? (OBJ)
	<AND <==? ,PRSO .OBJ>
	     <VERB? DISEMBARK DROP GIVE POUR PUT PUT-IN PUT-UNDER
		    REMOVE THROW-AT THROW-THROUGH>>>

<ROUTINE REMOTE-VERB? ()
 <COND (<VERB? ;ARREST ASK-ABOUT ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR ASK-FOR ;BUY
	       DISEMBARK ;DRESS FIND FOLLOW LEAVE LOOK-UP
	       ;MAKE SEARCH SEARCH-FOR SHOW SSHOW
	       TAKE-TO TALK-ABOUT TELL-ABOUT WAIT-FOR WAIT-UNTIL WALK-TO>
	<RTRUE>)>
 <RFALSE>>
