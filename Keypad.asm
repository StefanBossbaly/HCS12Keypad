#include Reg9s12.h
#include IntVec.h

        ORG $2000       ;Start at memory address 2000
        LDX #$0000      ;Register base is 0x00
        BRA SETUP       ;GOTO main
        
;ADD(int num1, int num2)
;Adds two numbers together
ADD:    CLRA            ;Clear A
        CLRB            ;Clear B
SETUP:  LDAA #$0F
        STAA DDRB,x     ;Set 0x0F into DDRB this makes PB0-3 as output and 4-7 as inputs
INPUT:  ;LDAA #$01       ;Set 0x01 into Port B
        ;STAA PORTB,x    ;This sets PB0 as HIGH all other are LOW
        ;LDAA #$02       ;Set 0x02 into Port B
        ;STAA PORTB,x    ;This sets PB1 as HIGH all other are LOW
	LDAA #$01       ;Set 0x04 into Port B
	STAA PORTB,x    ;This sets PB3 as HIGH all other are LOW
	;LDAA #$08       ;Set 0x08 into Port B
        ;STAA PORTB,x    ;This sets PB4 as HIGH all other are LOW



	;LDAA PORTB,x    ;Load Port B into A
        ;ANDA #$80
        ;SWI