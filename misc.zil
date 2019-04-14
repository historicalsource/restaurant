"MISC for MILLIWAYS
Copyright (c) 1988 Infocom, Inc.  All rights reserved."

<GLOBAL SCREENWIDTH:NUMBER 0>

<ROUTINE GO ()
	<SETG SCREENWIDTH <LOWCORE SCRH>>
	<COND (<L? ,SCREENWIDTH 64>
	       <TELL "[The screen is too narrow.]" CR>
	       <QUIT>)>
	<CLEAR -1>
	<INIT-STATUS-LINE>
	<V-VERSION>
	<INTRO>
	<MAIN-LOOP>
	<AGAIN>>

<ROUTINE INTRO ()
	;<TELL "[LEN=" N <LOWCORE SCRV> " WID=" N ,SCREENWIDTH "]">
	<CRLF>>

<ROUTINE PRINT-THE (OBJ)	;"the"
	<COND (<AND <EQUAL? .OBJ ,TURN> <L? 1 ,P-NUMBER>>
	       <TELL !\  N ,P-NUMBER " minutes">)
	      (<EQUAL? .OBJ ,WINDOW>
	       <TELL " the window">)
	      ;(<AND <EQUAL? .OBJ ,P-IT-OBJECT>
		    <FSET? ,IT ,TOUCHBIT>>
	       <TELL " it">
	       <RTRUE>)
	      (T
	       <THE? .OBJ>
	       <TELL !\  D .OBJ>)>>

<ROUTINE THE? (OBJ)
	<COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
	       <COND (<OR ;<NOT <FSET? .OBJ ,PERSONBIT>>
			  <IN? .OBJ ,ROOMS>
			  <FSET? .OBJ ,SEENBIT>>
		      <TELL " the">)
		     (<FSET? .OBJ ,VOWELBIT>
		      <TELL " an">)
		     (T <TELL " a">)>)>
	<COND (T ;<FSET? .OBJ ,PERSONBIT>
	       <FSET .OBJ ,SEENBIT>)>>

<ROUTINE START-SENTENCE (OBJ)	;"The"
	<THIS-IS-IT .OBJ>
	<COND (<EQUAL? .OBJ ,PLAYER>	<TELL "You">		<RTRUE>)
	      (<EQUAL? .OBJ ,HANDS>	<TELL "Your hand">	<RTRUE>)
	      (<EQUAL? .OBJ ,HEAD>	<TELL "Your head">	<RTRUE>)
	      (<EQUAL? .OBJ ,EYES>	<TELL "Your eyes">	<RTRUE>)
	      (<EQUAL? .OBJ ,TEETH>	<TELL "Your teeth">	<RTRUE>)
	      (<EQUAL? .OBJ ,EARS>	<TELL "Your ears">	<RTRUE>)>
	<COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
	       <COND (<OR ;<NOT <FSET? .OBJ ,PERSONBIT>>
			  <FSET? .OBJ ,SEENBIT>>
		      <TELL "The ">)
		     (<FSET? .OBJ ,VOWELBIT>
		      <TELL "An ">)
		     (T <TELL "A ">)>)>
	<COND (T ;<FSET? .OBJ ,PERSONBIT>
	       <FSET .OBJ ,SEENBIT>)>
	<TELL D .OBJ>>

<ROUTINE PRINTA (O)	;"a"
	 <COND (<OR ;<FSET? .O ,PERSONBIT> <FSET? .O ,NARTICLEBIT>> T)
	       (<FSET? .O ,VOWELBIT> <TELL "an ">)
	       (T <TELL "a ">)>
	 <TELL D .O>>

<GLOBAL QCONTEXT:OBJECT FORD>
<GLOBAL LIT:OBJECT RAMP>
;<GLOBAL P-IT-WORDS <TABLE <VOC DRESSING ADJ> <VOC GOWN NOUN>>>
<GLOBAL P-IT-OBJECT:OBJECT GOWN>
<GLOBAL P-HER-OBJECT:OBJECT TRILLIAN>
<GLOBAL P-HIM-OBJECT:OBJECT FORD>
;<GLOBAL P-ONE-NOUN <VOC "FROB">>

<ROUTINE THIS-IS-IT (OBJ)
 <COND (<EQUAL? .OBJ <> ,NOT-HERE-OBJECT ,PLAYER>
	<RTRUE>)
       (<EQUAL? .OBJ ,INTDIR ,GLOBAL-HERE ,ROOMS>
	<RTRUE>)
       (<AND <DIR-VERB?> <==? .OBJ ,PRSO>>
	<RTRUE>)>
 <COND (<NOT <FSET? .OBJ ,PERSONBIT>>
	;<PUT ,P-IT-WORDS 0 <GET ,P-ADJW ,NOW-PRSI>>
	;<PUT ,P-IT-WORDS 1 <GET ,P-NAMW ,NOW-PRSI>>
	<FSET ,IT ,TOUCHBIT>	;"to cause pronoun 'it' in output"
	<SETG P-IT-OBJECT .OBJ>)
       (<FSET? .OBJ ,FEMALEBIT>
	<FSET ,HER ,TOUCHBIT>
	<SETG P-HER-OBJECT .OBJ>)
       (<FSET? .OBJ ,PLURALBIT>
	<FSET ,THEM ,TOUCHBIT>
	<SETG P-THEM-OBJECT .OBJ>)
       (T
	<FSET ,HIM ,TOUCHBIT>
	<SETG P-HIM-OBJECT .OBJ>)>
 <RTRUE>>

<ROUTINE NO-PRONOUN? (OBJ "OPTIONAL" (CAP 0))
	<COND (<EQUAL? .OBJ ,PLAYER>
	       <RFALSE>)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<AND <EQUAL? .OBJ ,P-IT-OBJECT>
			   <FSET? ,IT ,TOUCHBIT>>
		      <RFALSE>)>)
	      (<FSET? .OBJ ,FEMALEBIT>
	       <COND (<AND <EQUAL? .OBJ ,P-HER-OBJECT>
			   <FSET? ,HER ,TOUCHBIT>>
		      <RFALSE>)>)
	      (<FSET? .OBJ ,PLURALBIT>
	       <COND (<AND <EQUAL? .OBJ ,P-THEM-OBJECT>
			   <FSET? ,THEM ,TOUCHBIT>>
		      <RFALSE>)>)
	      (T
	       <COND (<AND <EQUAL? .OBJ ,P-HIM-OBJECT>
			   <FSET? ,HIM ,TOUCHBIT>>
		      <RFALSE>)>)>
	<COND (<ZERO? .CAP> <TELL the .OBJ>)
	      (<ONE? .CAP> <TELL The .OBJ>)>
	<THIS-IS-IT .OBJ>
	<RTRUE>>

<ROUTINE HE-SHE-IT (OBJ "OPTIONAL" (CAP 0) (VERB <>))	;"He/he/+verb"
	<COND (<NO-PRONOUN? .OBJ .CAP>
	       T)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<ZERO? .CAP> <TELL " it">)
		     (<ONE? .CAP> <TELL "It">)>)
	      (<==? .OBJ ,PLAYER>
	       <COND (<ZERO? .CAP> <TELL " you">)
		     (<ONE? .CAP> <TELL "You">)>)
	      (<FSET? .OBJ ,FEMALEBIT>
	       <COND (<ZERO? .CAP> <TELL " she">)
		     (<ONE? .CAP> <TELL "She">)>)
	      ;(<FSET? .OBJ ,PLURALBIT>
	       <COND (<ZERO? .CAP> <TELL " they">)
		     (<ONE? .CAP> <TELL "They">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " he">)
		     (<ONE? .CAP> <TELL "He">)>)>
	<COND (<NOT <ZERO? .VERB>>
	       <PRINTC 32>
	       <COND (<OR <EQUAL? .OBJ ,PLAYER>
			  ;<FSET? .OBJ ,PLURALBIT>>
		      <COND (<=? .VERB "is"> <TELL "are">)
			    (<=? .VERB "has"><TELL "have">)
			    (<=? .VERB "tri"><TELL "try">)
			    (<=? .VERB "empti"><TELL "empty">)
			    (T <TELL .VERB>)>)
		     (T
		      <TELL .VERB>
		      <COND (<OR <EQUAL? .VERB "do" "kiss" "push">
				 <EQUAL? .VERB "tri" "empti">>
			     <TELL !\e>)>
		      <COND (<NOT <EQUAL? .VERB "is" "has">>
			     <TELL !\s>)>)>)>>

<ROUTINE HIM-HER-IT (OBJ "OPTIONAL" (CAP 0) (POSSESS? <>))	;"His/his/him"
 <COND (<NO-PRONOUN? .OBJ .CAP>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL "'s">)>)
       (<NOT <FSET? .OBJ ,PERSONBIT>>
	<COND (<ZERO? .CAP> <TELL " it">) (T <TELL "It">)>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL !\s>)>)
       (<==? .OBJ ,PLAYER>
	<COND (<ZERO? .CAP> <TELL " you">) (T <TELL "You">)>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL !\r>)>)
       (<FSET? .OBJ ,PLURALBIT>
	<COND (<NOT <ZERO? .POSSESS?>>
	       <COND (<ZERO? .CAP> <TELL " their">)
		     (T <TELL "Their">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " them">)
		     (T <TELL "Them">)>)>)
       (<FSET? .OBJ ,FEMALEBIT>
	<COND (<ZERO? .CAP> <TELL " her">) (T <TELL "Her">)>)
       (T
	<COND (<NOT <ZERO? .POSSESS?>>
	       <COND (<ZERO? .CAP> <TELL " his">)
		     (T <TELL "His">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " him">)
		     (T <TELL "Him">)>)>)>
 <RTRUE>>

<OBJECT HER
	(LOC GLOBAL-OBJECTS)
	(SYNONYM ;SHE HER MADAM)
	(DESC "her")
	(FLAGS NARTICLEBIT)>

<OBJECT HIM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM ;HE HIM SIR)
	(DESC "him")
	(FLAGS NARTICLEBIT)>

<OBJECT THEM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM THEM)
	(DESC "them")
	(FLAGS NARTICLEBIT)>

<CONSTANT P-PROMPT-START 4>
<GLOBAL P-PROMPT:NUMBER 4>

<ROUTINE I-PROMPT ("OPTIONAL" (GARG <>))
 <COND (<EQUAL? .GARG ,G-DEBUG> <RFALSE>)>
 <SETG P-PROMPT <- ,P-PROMPT 1>>
 <RFALSE>>

<ROUTINE DONT-F ()
	 <COND (<VERB? PANIC>
		<COND (<1? <RANDOM 2>>
		       <TELL 
"Very clever. It looks as if there's a lot you should be panicking about." CR>)
		      (T
		       <TELL
"Why not? Your position appears quite hopeless." CR>)>)
	       ;(<VERB? LOOK>
		<SETG DONT-FLAG <>>
		<PERFORM ,V?CLOSE ,EYES>
		<RTRUE>)
	       (<VERB? WAIT-FOR WAIT-UNTIL>
		<TELL "Time doesn't pass..." CR>)
	       (<VERB? TAKE>
		<TELL "Not taken." CR>)
	       ;(<AND <VERB? LISTEN>
		     <VISIBLE? ,POETRY>>
		<SETG DONT-FLAG <>>
		<PERFORM ,V?LISTEN ,POETRY>
		<RTRUE>)
	       (T
		<TELL "Not done." CR>)>>

<ROUTINE NOT-FOUND (OBJ "AUX" (WT <>))
	<COND (<VERB? WALK-TO>
	       <SET WT T>)>
	<COND (<ZERO? .WT>
	       <SETG CLOCK-WAIT T>
	       <TELL "(Y">)
	      (T <TELL "But y">)>
	<TELL "ou haven't found" him .OBJ " yet!">
	<COND (<ZERO? .WT>
	       <TELL !\)>)>
	<CRLF>
	<RTRUE>>

<ROUTINE VERB-PRINT ("OPTIONAL" (GERUND <>) "AUX" TMP)
	<SET TMP <PARSE-VERB ,PARSE-RESULT>>
	<COND (<==? .TMP 0>
	       <COND (<ZERO? .GERUND> <TELL "tell"> <RTRUE>)
		     (T <TELL "walk">)>)
	      (<OR <T? .GERUND> ;<0? <GETB ,P-VTBL 2>>>
	       <SET TMP <GET .TMP 0>>
	       <COND (<==? .TMP ,W?L> <PRINTB ,W?LOOK>)
		     (<==? .TMP ,W?X> <PRINTB ,W?EXAMINE>)
		     (<==? .TMP ,W?Z> <PRINTB ,W?WAIT>)
		     (<T? .GERUND>
		      <COND (<==? .TMP ,W?BATHE> <TELL "bath">)
			    (<==? .TMP ,W?DIG> <TELL "digg">)
			    (<==? .TMP ,W?GET> <TELL "gett">)
			    (T <PRINTB .TMP>)>)
		     (T <PRINTB .TMP>)>)
	      (T
	       <WORD-PRINT .TMP>
	       ;<PUTB ,P-VTBL 2 0>)>
	<COND (<T? .GERUND> <TELL "ing?">)>>

<ROUTINE NOT-IT (WHO)
 <COND (<EQUAL? .WHO ,P-HER-OBJECT>
	<FCLEAR ,HER ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-HIM-OBJECT>
	<FCLEAR ,HIM ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-THEM-OBJECT>
	<FCLEAR ,THEM ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-IT-OBJECT>
	<FCLEAR ,IT  ,TOUCHBIT>)>>

<REPLACE-DEFINITION CAPITAL-NOUN?
 <ROUTINE CAPITAL-NOUN? (WRD)
    <OR <TITLE-NOUN? .WRD>
	<EQUAL? .WRD ,W?FORD ,W?ZAPHOD ,W?BEEBLEBROX>
	<EQUAL? .WRD ,W?TRILLIAN ,W?TRICIA ,W?MCMILLAN>
	<EQUAL? .WRD ,W?MARV ,W?MARVIN ,W?PREFECT>>>>

<ROUTINE TITLE-NOUN? (WRD)
    <OR <EQUAL? .WRD ,W?MR ,W?MS>
	<EQUAL? .WRD ,W?MISTER ,W?MISS ,W?SIR>
	;<EQUAL? .WRD ,W?MRS ,W?DR ,W?DOCTOR>>>

"CLOCK for MILLIWAYS
Copyright (C) 1988 Infocom, Inc.  All rights reserved."

"List of queued routines:
"

<GLOBAL SCORE:NUMBER 0>
<GLOBAL MOVES:NUMBER 0>
<GLOBAL HERE:OBJECT RAMP>
<GLOBAL OHERE:OBJECT <>>

<GLOBAL CLOCKER-RUNNING:NUMBER 0>

<CONSTANT C-TABLELEN 138>	;"and one for good measure"

<GLOBAL C-TABLE
 <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 I-REPLY
	1 1 I-PROMPT	;"last to run">>

<GLOBAL C-INTS:NUMBER <- 138 <* 1 6>>>
<CONSTANT C-INTLEN 6>
<CONSTANT C-ENABLED? 0>
<CONSTANT C-TICK 1>
<CONSTANT C-RTN 2>

<ROUTINE QUEUE (RTN TICK "AUX" CINT)
	 ;#DECL ((RTN) ATOM (TICK) FIX (CINT) <PRIMTYPE VECTOR>)
	 <PUT <SET CINT <INT .RTN>> ,C-TICK .TICK>
	 <PUT .CINT ,C-ENABLED? 1>
	 .CINT>

<ROUTINE INT (RTN "OPTIONAL" (DEMON <>) E C INT)
	 ;#DECL ((RTN) ATOM (DEMON) <OR ATOM FALSE> (E C INT) <PRIMTYPE
							      VECTOR>)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			;<AND .DEMON <SETG C-DEMONS <- ,C-DEMONS ,C-INTLEN>>>
			<SET INT <REST ,C-TABLE ,C-INTS>>
			<PUT .INT ,C-RTN .RTN>
			<RETURN .INT>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN> <RETURN .C>)>
		 <SET C <REST .C ,C-INTLEN>>>>

;<ROUTINE ENABLED? (RTN)
	<NOT <ZERO? <GET <INT .RTN> ,C-ENABLED?>>>>

;<ROUTINE QUEUED? (RTN "AUX" C)
	<SET C <INT .RTN>>
	<COND (<ZERO? <GET .C ,C-ENABLED?>> <RFALSE>)
	      (T <GET .C ,C-TICK>)>>

<GLOBAL CLOCK-WAIT:FLAG <>>

<ROUTINE CLOCKER ("AUX" C E TICK (FLG <>) VAL)
	 ;#DECL ((C E) <PRIMTYPE VECTOR> (TICK) FIX ;(FLG) ;<OR FALSE ATOM>)
	 <COND (,CLOCK-WAIT <SETG CLOCK-WAIT <>> <RFALSE>)>
	 <SETG MOVES <+ ,MOVES 1>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<RETURN .FLG>)
		       (<NOT <ZERO? <GET .C ,C-ENABLED?>>>
			<SET TICK <GET .C ,C-TICK>>
			<COND (<NOT <ZERO? .TICK>>
			       <PUT .C ,C-TICK <- .TICK 1>>
			       <COND (<AND <NOT <G? .TICK 1>>
				           <SET VAL <APPLY <GET .C ,C-RTN>>>>
				      <COND (<OR <ZERO? .FLG>
						 <==? .VAL ,M-FATAL>>
					     <SET FLG .VAL>)>)>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>
