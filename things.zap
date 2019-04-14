

	.FUNCT	RANDOM-PSEUDO:ANY:0:0
	EQUAL?	PRSA,V?TELL-ABOUT,V?LOOK-UNDER /FALSE
	EQUAL?	PRSA,V?LOOK-BEHIND,V?ASK-CONTEXT-ABOUT,V?ASK-ABOUT /FALSE
	EQUAL?	PRSA,V?SEARCH,V?LOOK-INSIDE,V?EXAMINE \?CCL7
	ICALL1	NOTHING-SPECIAL
	RTRUE	
?CCL7:	CALL1	WONT-HELP
	RSTACK	


	.FUNCT	TOOTHBRUSH-F:ANY:0:0
	EQUAL?	PRSA,V?TAKE \FALSE
	FSET?	TOOTHBRUSH,TOUCHBIT /FALSE
	MOVE	TOOTHBRUSH,PLAYER
	FSET	TOOTHBRUSH,TOUCHBIT
	FCLEAR	TOOTHBRUSH,TRYTAKEBIT
	PRINTI	"As you pick up the "
	PRINTD	TOOTHBRUSH
	PRINTR	" a tree outside the window collapses. There is no causal relationship between these two events."


	.FUNCT	GOWN-F:ANY:0:0
	EQUAL?	PRSA,V?CLOSE,V?OPEN \?CCL3
	FSET?	GOWN,WORNBIT /?CCL3
	PRINTR	"It's hard to open or close the pocket unless you're wearing the gown."
?CCL3:	EQUAL?	PRSA,V?EXAMINE \FALSE
	PRINTI	"The dressing gown is faded and battered, and is clearly a garment which has seen better decades. It has a pocket which is "
	FSET?	GOWN,OPENBIT \?CCL10
	PRINTI	"open"
	JUMP	?CND8
?CCL10:	PRINTI	"closed"
?CND8:	PRINTR	", and a small loop at the back of the collar."


	.FUNCT	SLEEVES-F:ANY:0:0
	CALL2	VISIBLE?,GOWN
	ZERO?	STACK \?CCL3
	CALL2	NOT-HERE,SLEEVES
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?TAKE \FALSE
	ICALL	PERFORM,PRSA,GOWN
	RTRUE	


	.FUNCT	THING-F:ANY:0:0
	EQUAL?	PRSA,V?EXAMINE \?CCL3
	PRINTI	"Apart from a label on the bottom saying ""Made in Ibiza"" it furnishes you with no clue as to its purpose, if indeed it has one. You are surprised to see it because you thought you'd thrown it away. Like most gifts from your aunt,"
	PRINT	GET-RID
	CRLF	
	RTRUE	
?CCL3:	EQUAL?	PRSA,V?DROP \?CCL5
	MOVE	THING,HERE
	PRINTR	"It falls to the ground with a light ""thunk."" It doesn't do anything else at all."
?CCL5:	EQUAL?	PRSA,V?CLOSE \FALSE
	PRINTR	"Come to think of it, you vaguely remember an instruction booklet with directions for that. You never read it and lost it months ago."


	.FUNCT	I-THING:ANY:0:0
	RANDOM	4
	ADD	4,STACK
	ICALL	QUEUE,I-THING,STACK
	CALL2	VISIBLE?,THING
	ZERO?	STACK \FALSE
	CALL2	HELD?,THING
	ZERO?	STACK \FALSE
	RANDOM	100
	LESS?	40,STACK /?CCL7
	MOVE	THING,HERE
	RFALSE	
?CCL7:	FSET?	GOWN,WORNBIT \?CCL9
	FSET?	GOWN,OPENBIT \?CCL9
	RANDOM	100
	LESS?	65,STACK /?CCL9
	MOVE	THING,GOWN
	RFALSE	
?CCL9:	MOVE	THING,PLAYER
	RFALSE	


	.FUNCT	GUIDE-DESCFCN:ANY:0:1,X
	PRINTI	"There is a copy of "
	PRINT	GUIDE-NAME
	PRINTR	" here."


	.FUNCT	GUIDE-F:ANY:0:0
	EQUAL?	PRSA,V?EXAMINE \?CCL3
	PRINTR	"The Guide is a Mark II model. Its only resemblance to the Mark IV pictured in the brochure in your game package is the large, friendly ""Don't Panic!"" on its cover.

The Guide is a Sub-Etha Relay. You can use it to tap information from a huge and distant data bank by consulting the Guide about some item or subject."
?CCL3:	EQUAL?	PRSA,V?ASK-ABOUT \FALSE
	EQUAL?	PRSO,GUIDE \FALSE
	FSET?	TOWEL,WORNBIT \?CND8
	PRINT	WITH-TOWEL
	CRLF	
	RTRUE	
?CND8:	PRINTI	"The Guide checks through its Sub-Etha-Net database and eventually comes up with the following entry:"
	CRLF	
	CRLF	
	EQUAL?	PRSI,GUIDE \?CCL12
	PRINTD	GUIDE
	PRINTI	" is a wholly remarkable product."
	PRINT	ALREADY-KNOW-THAT
	CRLF	
	RTRUE	
?CCL12:	EQUAL?	PRSI,HEART-OF-GOLD \?CCL14
	PRINTI	"There is absolutely no such spaceship as "
	PRINTD	HEART-OF-GOLD
	PRINTI	" and anything you've ever read in this spot to the contrary was just a prank.
   -- "
	PRINT	AGENCY
	CRLF	
	RTRUE	
?CCL14:	EQUAL?	PRSI,SCC \?CCL16
	PRINTI	"The "
	PRINT	SCC
	PRINTR	" incompetently produces a wide range of inefficient and unreliable high-tech machinery. However, thanks to SCC's ruthless marketing division, this junk accounts for over 95% of the high-tech machinery sold in the Galaxy. (SCC's marketing division will be the first against the wall when the revolution comes.)"
?CCL16:	EQUAL?	PRSI,MARVIN \?CCL18
	PRINT	GPP
	PRINTI	" are a misguided attempt by the "
	PRINT	SCC
	PRINTR	" to make their machines behave more like people. Among the more miserable failures: paranoid-depressive robots and over-protective computers."
?CCL18:	EQUAL?	PRSI,RAMP \?CCL20
	PRINTR	"According to legend, Magrathea was a planet that amassed incredible wealth by manufacturing other planets. The legends also mention it as the setting of the very eagerly awaited second Infocom Hitchhiker's game."
?CCL20:	EQUAL?	PRSI,ZAPHOD \?CCL22
	PRINTD	ZAPHOD
	PRINTI	" is the current"
	PRINT	PRESIDENT
	PRINTR	"."
?CCL22:	EQUAL?	PRSI,BABEL-FISH \?CCL25
	PRINTI	"A mind-bogglingly improbable creature. A "
	PRINTD	BABEL-FISH
	PRINTR	", when placed in one's ear, allows one to understand any language."
?CCL25:	EQUAL?	PRSI,TOWEL \?CCL27
	PRINTR	"A towel is the most useful thing (besides the Guide) a Galactic hitchhiker can have. Its uses include travel, combat, communications, protection from the elements, hand-drying and reassurance. Towels have great symbolic value, with many associated points of honour. Never mock the towel of another, even if it has little pink and blue flowers on it. Never do something to somebody else's towel that you would not want them to do to yours. And, if you borrow the towel of another, you MUST return it before leaving their world."
?CCL27:	EQUAL?	PRSI,GARGLE-BLASTER \?CCL29
	PRINTR	"The best drink in existence; somewhat like having your brains smashed out by a slice of lemon wrapped around a large gold brick."
?CCL29:	EQUAL?	PRSI,THIRD-PLANET \?CCL31
	PRINTR	"Mostly harmless."
?CCL31:	FSET?	PRSI,TOOLBIT \?CCL33
	PRINTR	"The editor responsible for entries under this heading has been out to lunch for a couple of years but is expected back soon, at which point there will be rapid updates. Until then, don't panic, unless your situation is really a life or death one, in which case, sure, go ahead, panic."
?CCL33:	PRINTR	"That is one of the Great Unanswered Questions. For a list of the others, consult the Guide."


	.FUNCT	BABEL-FISH-F:ANY:0:0
	EQUAL?	PRSA,V?REMOVE,V?TAKE \FALSE
	PRINTI	"That would be foolish. Having a "
	PRINTD	BABEL-FISH
	PRINTR	" in your ear is terribly useful."


	.FUNCT	TOWEL-F:ANY:0:0
	EQUAL?	PRSA,V?MOVE,V?TAKE \?CCL3
	EQUAL?	PRSO,TOWEL \?CCL3
	FSET?	TOWEL,SURFACEBIT \?CCL3
	FCLEAR	TOWEL,TRYTAKEBIT
	FCLEAR	TOWEL,SURFACEBIT
	ICALL	ROB,TOWEL,HERE
	FCLEAR	TOWEL,CONTBIT
	FCLEAR	TOWEL,OPENBIT
	FCLEAR	TOWEL,NDESCBIT
	EQUAL?	PRSA,V?MOVE \FALSE
	PRINTR	"Okay, it's no longer covering the drain."
?CCL3:	EQUAL?	PRSA,V?PUT \?CCL11
	EQUAL?	PRSI,EYES,HEAD \?CCL11
	FSET?	TOWEL,WORNBIT \?CCL16
	PRINTR	"It already is."
?CCL16:	PRINTR	"There's no need for that. It's not as if there's a Bugblatter Beast around, or something."
?CCL11:	EQUAL?	PRSA,V?EXAMINE \FALSE
	PRINTR	"It's covered with little pink and blue flowers."


	.FUNCT	SATCHEL-DESCFCN:ANY:0:1,X
	PRINTI	"There is a satchel here."
	ICALL1	ITEM-ON-SATCHEL-DESCRIPTION
	CRLF	
	RTRUE	


	.FUNCT	ITEM-ON-SATCHEL-DESCRIPTION:ANY:0:0
	ZERO?	ITEM-ON-SATCHEL /FALSE
	PRINTI	" Sitting on top of it is "
	ICALL2	PRINTA,ITEM-ON-SATCHEL
	PRINTC	46
	RTRUE	


	.FUNCT	SATCHEL-F:ANY:0:0
	EQUAL?	PRSA,V?OPEN \?CCL3
	CALL2	PRIVATE,STR?168
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?PUT \?CCL6
	EQUAL?	SATCHEL,PRSI \?CCL6
	CALL2	HELD?,SATCHEL
	ZERO?	STACK /?CCL11
	PRINTR	"Put down the satchel first."
?CCL11:	ZERO?	ITEM-ON-SATCHEL /?CCL13
	PRINTI	"But"
	ICALL2	PRINT-THE,ITEM-ON-SATCHEL
	PRINTR	" is already on the satchel."
?CCL13:	SET	'ITEM-ON-SATCHEL,PRSO
	MOVE	PRSO,HERE
	FSET	PRSO,NDESCBIT
	FSET	PRSO,TRYTAKEBIT
	PRINTI	"Okay,"
	ICALL2	PRINT-THE,PRSO
	PRINTR	" is now sitting on the satchel."
?CCL6:	EQUAL?	PRSA,V?EXAMINE \?CCL15
	PRINTI	"The satchel, which is "
	FSET?	SATCHEL,OPENBIT \?CCL18
	PRINTI	"open"
	JUMP	?CND16
?CCL18:	PRINTI	"closed"
?CND16:	PRINTI	", is fairly bulky."
	ICALL1	ITEM-ON-SATCHEL-DESCRIPTION
	CRLF	
	RTRUE	
?CCL15:	EQUAL?	PRSA,V?TAKE \FALSE
	IN?	SATCHEL,FORD \FALSE
	PRINTI	"Ford says, ""Hey, Arthur, keep "
	PRINTD	HANDS
	PRINTR	"s off my satchel!"""


	.FUNCT	PRIVATE:ANY:1:1,STRING
	PRINTI	"You can't. It's not yours. It's "
	PRINT	STRING
	PRINTR	"'s and it's private."


	.FUNCT	GAME-F:ANY:0:0
	EQUAL?	PRSA,V?THROUGH,V?READ,V?PLAY /?CCL3
	EQUAL?	PRSA,V?LAMP-ON,V?FIND,V?EXAMINE \FALSE
?CCL3:	SET	'CLOCK-WAIT,TRUE-VALUE
	PRINTR	"[You're playing it now!]"


	.FUNCT	DINNER-D:ANY:1:1,ARG,L
	LOC	DINNER >L
	PRINTI	"An appetizing aroma wafts from an array of covered dishes"
	PRINTR	"."


	.FUNCT	DINNER-F:ANY:0:0,I,L
	LOC	DINNER >L
	EQUAL?	PRSA,V?EAT \?CCL3
	PRINTR	"You take a bite and find it delicious."
?CCL3:	EQUAL?	PRSA,V?EXAMINE \FALSE
	PRINTI	"A lovely assortment of fish, fowl, greens, and sweets fills the "
	PRINTR	"plate."

	.ENDI
