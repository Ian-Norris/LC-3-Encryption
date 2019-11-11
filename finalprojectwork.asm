; Name: Ian Norris

; Date: 5/3/2019

; Assignment: Final Project

;

; Description:

; Take an input of multiple characters and either encrypt or decrypt them with a key value.

; Assumptions: The user can properly hit E or D. The user inputs the key 0-9

;

; Registers:

; The registers purpose change throughout. They have comments next to them with their current use.





.ORIG x3000

;Prompt for input
LEA R0, PROMPT PUTS
GETC
OUT

;Store letter into x3100
STI R0, LETTERLOCATION	;Stores letter into x3100

 
;Getting encryption key
LEA R0, KEYPROMPT PUTS
GETC
OUT
;Strip ASCII from number
LD R1, NASCII
ADD R1, R0, R1   ;convert from ascii to int
STI R1, KEYLOCATION	;Stores in x3101

;Prompting user for string
LEA R0, PROMPTMESSAGE PUTS	;Prompting user to input string
LD R1, STRINGLOCATION	;Storing x3102 into R1 to incriment

;Starting loop for asking for characters
CHARLOOP
LD R3, ISENTERKEY	;Loading -10 to check if enter was pressed
GETC
OUT
ADD R3, R0, R3	;Checks if enter key was pressed
BRz ENTERKEY
ADD R5, R5, #1	;Incriments R5 for how many characters were inputed
STR R0, R1, #0	;Stores in memory location
ADD R1, R1, #1	;Incriments memory location to be stored
LD R6, TWENTYCHARACTERS	;Load -20 into r6 to check for 20 characters
ADD R6, R5, R6	;checking if twenty characters have been inputed
BRN CHARLOOP
ENTERKEY	;ENTER was pressed and we are done asking for characters
AND R6, R6, #0	;Clearing R6
AND R3, R3, #0	;Clearing R3

;Check if user wanted to encrypt or decrypt
LDI R1, LETTERLOCATION	;Gets value from x3100
LD R2, EORD	;Load -69
ADD R2, R2, R1	;Adding -69 to see if letter is E or D
BRZ ENCRYPT 
BRN DECRYPT

;Encryption
ENCRYPT
LEA R0, ENCRYPTMESSAGE PUTS
LDI R2, KEYLOCATION	;Gets Key stored in x3101
LD R3, STRINGLOCATION	;Stores memory location into R3 for incrimentation
LD R4, NEWSTRINGLOCATION ;Stores where we are going to be putting the encrypted value
ADD R6, R5, #0	;Stores how many letters were inputed into R6 to keep track of for this loop
MOREENC
LDR R0, R3, #0	;Gets letter stored in memory location of R3
ADD R0, R0, R2	;Adds key and letter
OUT
STR R0, R4, #0	;Stores encrypted letter back
ADD R3, R3, #1	;Incriments R3
ADD R4, R4, #1	;Incriments R4
ADD R6, R6, #-1	;Decriments how many times ive ran this encryption
BRP MOREENC
BR END

;Decryption
DECRYPT
LEA R0, DECRYPTMESSAGE PUTS
LDI R2, KEYLOCATION	;Gets Key stored in x3101
NOT R2, R2	;Negating the key to subtract
ADD R2, R2, #1	;Adding 1 to balance the R2
LD R3, STRINGLOCATION	;Stores memory location into R3 for incrimentation
LD R4, NEWSTRINGLOCATION
ADD R6, R5, #0	;Stores how many letters were inputed into R6 to keep track of for this loop
MOREDEC
LDR R0, R3, #0	;Gets letter stored in memory location of R3
ADD R0, R0, R2	;Adds key and letter
OUT
STR R0, R4, #0	;Stores encrypted letter back
ADD R3, R3, #1	;Incriments R3
ADD R4, R4, #1	;Incriments R4
ADD R6, R6, #-1	;Decriments how many times ive ran this encryption
BRP MOREDEC

END

HALT

;DATA
NASCII .FILL x-30
ASCII .FILL x30
PROMPT .STRINGZ "\n(E)ncrypt/(D)ecrypt: "
KEYPROMPT .STRINGZ "\nEncryption Key: "
PROMPTMESSAGE .STRINGZ "\nINPUT A MESSAGE OF NO MORE THAN 20 CHARACTERS. WHEN DONE, PRESS <ENTER> "
ENCRYPTMESSAGE .STRINGZ "\nEncrypted Message: "
DECRYPTMESSAGE .STRINGZ "\nDecrypted Message: "
EORD .FILL #-69
ISENTERKEY .FILL #-10
TWENTYCHARACTERS .FILL #-20
LETTERLOCATION .FILL x3100
KEYLOCATION .FILL x3101
STRINGLOCATION .FILL x3102
NEWSTRINGLOCATION .FIll x3116


.END