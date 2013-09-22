#include Reg9s12.h
#include IntVec.h

        ORG $2000       ;Start at memory address 2000
        LDX #$0000      ;Register base is 0x00
        BRA SETUP       ;GOTO main

;void BWAIT(void)
;Busy waits by counting down from 0xFFFF
BWAIT:  LDD #$FFFF      ;Load 0xFFFF into register D
BLP:    CPD #$0000      ;Compare it with 0x0000
        BEQ BEND        ;End the loop if they are equal
        SUBD #$0001     ;Decrement 1 from D
        BRA BLP         ;Loop
BEND:   RTS             ;Return to sub routine
        
SETUP:  LDAA #$0F
        STAA DDRB,x     ;Set 0x0F into DDRB this makes PB0-3 as output and 4-7 as inputs
        CLRA            ;Clear A
        CLRB            ;Clear B
INPUT:  LDAA #$08       ;Set 0x08 into Port B
        STAA PORTB,x    ;This sets PB4 as HIGH all other are LOW
        JSR BWAIT
        LDAA #$04       ;Set 0x04 into Port B
        STAA PORTB,x    ;This sets PB3 as HIGH all other are LOW
        JSR BWAIT
        LDAA #$02       ;Set 0x02 into Port B
        STAA PORTB,x    ;This sets PB1 as HIGH all other are LOW
        JSR BWAIT
        LDAA #$01       ;Set 0x01 into Port B
        STAA PORTB,x    ;This sets PB0 as HIGH all other are LOW
        SWI
        ;LDAA PORTB,x    ;Load Port B into A
        ;ANDA #$80
        ;SWI