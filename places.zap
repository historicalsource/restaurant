

	.FUNCT	DOOR-ROOM:ANY:2:2,RM,DR,P,TBL
?PRG1:	NEXTP	RM,P >P
	ZERO?	P /FALSE
	LESS?	P,LOW-DIRECTION /FALSE
	GETPT	RM,P >TBL
	PTSIZE	TBL
	EQUAL?	DEXIT,STACK \?PRG1
	GET	TBL,DEXITOBJ
	EQUAL?	DR,STACK \?PRG1
	GET	TBL,REXIT
	RSTACK	


	.FUNCT	FIND-IN:ANY:2:3,RM,FLAG,EXCLUDED,O
	FIRST?	RM >O /?PRG2
?PRG2:	ZERO?	O /FALSE
	FSET?	O,FLAG \?CCL8
	FSET?	O,INVISIBLE /?CCL8
	EQUAL?	O,EXCLUDED /?CCL8
	RETURN	O
?CCL8:	NEXT?	O >O /?PRG2
	JUMP	?PRG2


	.FUNCT	FIND-FLAG-NOT:ANY:2:2,RM,FLAG,O
	FIRST?	RM >O /?PRG2
?PRG2:	ZERO?	O /FALSE
	FSET?	O,FLAG /?CCL8
	FSET?	O,INVISIBLE /?CCL8
	RETURN	O
?CCL8:	NEXT?	O >O /?PRG2
	JUMP	?PRG2


	.FUNCT	FIND-FLAG-LG:ANY:2:3,RM,FLAG,FLAG2,TBL,O,CNT,SIZE
	GETPT	RM,P?GLOBAL >TBL
	ZERO?	TBL /FALSE
	PTSIZE	TBL
	DIV	STACK,2
	SUB	STACK,1 >SIZE
?PRG4:	GET	TBL,CNT >O
	FSET?	O,FLAG \?CCL8
	FSET?	O,INVISIBLE /?CCL8
	ZERO?	FLAG2 /?CTR7
	FSET?	O,FLAG2 \?CCL8
?CTR7:	RETURN	O
?CCL8:	IGRTR?	'CNT,SIZE \?PRG4
	RFALSE	


	.FUNCT	FIND-FLAG-HERE:ANY:1:3,FLAG,NOT1,NOT2,O
	FIRST?	HERE >O /?PRG2
?PRG2:	ZERO?	O /FALSE
	FSET?	O,FLAG \?CCL8
	FSET?	O,INVISIBLE /?CCL8
	EQUAL?	O,NOT1,NOT2 /?CCL8
	RETURN	O
?CCL8:	NEXT?	O >O /?PRG2
	JUMP	?PRG2


	.FUNCT	FIND-FLAG-HERE-NOT:ANY:2:3,FLAG,NFLAG,NOT2,O
	FIRST?	HERE >O /?PRG2
?PRG2:	ZERO?	O /FALSE
	FSET?	O,FLAG \?CCL8
	FSET?	O,NFLAG /?CCL8
	FSET?	O,INVISIBLE /?CCL8
	EQUAL?	O,NOT2 /?CCL8
	RETURN	O
?CCL8:	NEXT?	O >O /?PRG2
	JUMP	?PRG2


	.FUNCT	UNIMPORTANT-THING-F:ANY:0:0
	EQUAL?	PRSA,V?ASK-ABOUT \?CCL3
	EQUAL?	PRSO,GUIDE /FALSE
?CCL3:	PRINTR	"That's not important; leave it alone."


	.FUNCT	WINDOW-F:ANY:0:0
	EQUAL?	PRSA,V?UNLOCK /?CTR2
	EQUAL?	PRSA,V?LOCK,V?CLOSE,V?OPEN \?CCL3
?CTR2:	EQUAL?	PRSA,V?OPEN \?CCL8
	PRINTR	"The night air is too damp and chilly."
?CCL8:	ICALL	ALREADY,WINDOW,STR?98
	RTRUE	
?CCL3:	EQUAL?	PRSA,V?THROUGH,V?LEAVE,V?DISEMBARK \?CCL10
	PRINTR	"It's closed tight against the mist."
?CCL10:	EQUAL?	PRSA,V?LOOK-OUTSIDE,V?LOOK-THROUGH,V?LOOK-INSIDE \FALSE
	PRINTR	"All you can see are grey shapes in the moonlight."


	.FUNCT	PUB-F:ANY:1:1,RARG
	EQUAL?	RARG,M-LOOK \FALSE
	PRINTR	"Milliways is pleasant and cheerful and full of pleasant and cheerful people who don't know they've got about twelve minutes to live and are therefore having a spot of lunch."


	.FUNCT	BEER-F:ANY:0:0
	EQUAL?	PRSA,V?TAKE,V?RUB,V?SMELL /?PRD5
	EQUAL?	PRSA,V?COUNT,V?ENJOY,V?DRINK \?CCL3
?PRD5:	FSET?	BEER,NDESCBIT \?CCL3
	PRINTR	"You'd better buy some first."
?CCL3:	EQUAL?	PRSA,V?COUNT \?CCL9
	PRINTR	"Lots."
?CCL9:	EQUAL?	PRSA,V?TAKE \?CCL11
	PRINTR	"Just drink it!"
?CCL11:	EQUAL?	PRSA,V?ENJOY,V?DRINK \?CCL14
	ADD	SCORE,5 >SCORE
	INC	'DRUNK-LEVEL
	EQUAL?	DRUNK-LEVEL,4 \?CCL17
	PRINTI	"You can hear the muffled noise of your home being demolished, and the taste of the beer sours in your mouth."
	CRLF	
	CRLF	
	RTRUE	
?CCL17:	EQUAL?	DRUNK-LEVEL,3 \?CCL19
	PRINTR	"There is a distant crash which Ford explains is nothing to worry about, probably just your house being knocked down."
?CCL19:	EQUAL?	DRUNK-LEVEL,2 \?CCL21
	PRINTR	"It is really very pleasant stuff, with a very good dry, nutty flavour, some light froth on top, and a deep colour. It is at exactly room temperature. You reflect that the world cannot be all bad when there are such pleasures in it.

Ford mentions that the world is going to end in about twelve minutes."
?CCL21:	EQUAL?	DRUNK-LEVEL,1 \FALSE
	PRINTR	"It's very good beer, brewed by a small local company. You particularly like its flavour, which is why you woke up feeling so wretched this morning. You were at somebody's birthday party here in the Pub last night.

You begin to relax and enjoy yourself, so when Ford mentions that he's from a small planet in the vicinity of Betelgeuse, not from Guildford as he usually claims, you take it in your stride, and say ""Oh yes, which part?"""
?CCL14:	EQUAL?	PRSA,V?BUY \FALSE
	PRINTD	FORD
	PRINTR	" has already bought an enormous quantity for you!"


	.FUNCT	SANDWICH-F:ANY:0:0
	EQUAL?	PRSA,V?BUY \?CCL3
	ZERO?	SANDWICH-BOUGHT \?CCL3
	MOVE	SANDWICH,PLAYER
	FSET	SANDWICH,TAKEBIT
	FCLEAR	SANDWICH,TRYTAKEBIT
	FCLEAR	SANDWICH,NDESCBIT
	SET	'SANDWICH-BOUGHT,TRUE-VALUE
	PRINTI	"The barman gives you a "
	PRINTD	SANDWICH
	PRINTR	". The bread is like the stuff that stereos come packed in, the cheese would be great for rubbing out spelling mistakes, and margarine and pickle have performed an unedifying chemical reaction to produce something that shouldn't be, but is, turquoise. Since it is clearly unfit for human consumption you are grateful to be charged only a pound for it."
?CCL3:	EQUAL?	PRSA,V?BUY \?CCL7
	PRINTR	"You already did."
?CCL7:	EQUAL?	PRSA,V?ENJOY,V?EAT,V?TAKE \?CCL9
	FSET?	SANDWICH,TRYTAKEBIT \?CCL9
	EQUAL?	HERE,PUB \?CCL9
	PRINT	HANDS-OFF
	CRLF	
	RTRUE	
?CCL9:	EQUAL?	PRSA,V?ENJOY,V?EAT \FALSE
	MOVE	SANDWICH,LOCAL-GLOBALS
	SUB	SCORE,30 >SCORE
	PRINTR	"It is one of the least rewarding taste experiences you can recall."

	.ENDI
