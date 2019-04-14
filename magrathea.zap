

	.FUNCT	HATCH-F:ANY:0:0
	EQUAL?	HERE,HATCHWAY,RAMP /?CCL3
	EQUAL?	PRSA,V?RUB /?CTR2
	EQUAL?	PRSA,V?EXAMINE,V?CLOSE,V?OPEN \?CCL3
?CTR2:	CALL2	NOT-HERE,HATCH
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?THROUGH,V?OPEN \FALSE
	FSET?	HATCH,OPENBIT /FALSE
	PRINTR	"The hatch appears to be jammed shut."


	.FUNCT	FALL-OFF-RAMP:ANY:0:0
	PRINTI	"You fall off the edge of the ramp onto the surface of Magrathea.It's not a long way down and the ground breaks your fall, but nevertheless you die."
	LESS?	MOVES,10 \?CCL3
	PRINTI	"  This is something which is going to happen to you quite a lot, so you might as well get used to it."
	JUMP	?CND1
?CCL3:	PRINTI	"  You might not think it's very fair, but nobody said the Galaxy was a very fair place anyway."
?CND1:	ICALL1	JIGS-UP
	RFALSE	


	.FUNCT	WANDER-AROUND:ANY:0:0
	PRINTI	"You wander gloomily around for a while, ruining your shoes, becoming thoroughly depressed, and ending up where you started."
	CRLF	
	RFALSE	


	.FUNCT	DEATH-BY-BLUBBER:ANY:0:0
	PRINTI	"You fall into the new-ish, nasty-ish crater, where the blubber and blood liberally spattered around break your fall. Unfortunately, however, on becoming aware of your surroundings, you die of disgust."
	CRLF	
	ICALL1	JIGS-UP
	RFALSE	


	.FUNCT	SLOPE-SCRAMBLE:ANY:0:0
	PRINTI	"You plunge recklessly over the edge of the "
	PRINTD	HERE
	PRINTI	", ruining your shoes in your desperate scrabble for a foothold. Fortunately for you, you regain your footing and scramble breathlessly back to level ground again."
	CRLF	
	RFALSE	


	.FUNCT	DOWN-TO-CRATER:ANY:0:0
	PRINTI	"You hop over the teeth and scramble down to the crater floor"
	MOVE	WINNER,WHALE-CRATER
	RTRUE	

	.ENDI
