#include Reg9s12.h
#include IntVec.h

        ORG $2000       ;Start at memory address 2000
        LDX #$0000      ;Register base is 0x00
        CLI             ;Enable interrupts
        BRA SETUP       ;GOTO main
        
LETTER: DS.W 1

;void BWAIT(void)
;Busy waits by counting down from 0xFFFF
BWAIT:  LDD #$FFFF      ;Load 0xFFFF into register D
BLP:    CPD #$0000      ;Compare it with 0x0000
        BEQ BEND        ;End the loop if they are equal
        SUBD #$0001     ;Decrement 1 from D
        BRA BLP         ;Loop
BEND:   RTS             ;Return to sub routine

;int CINPUT(int column)
;Sees if there is any input and returns it in the D register
;If there is no input then it returns 17
CINPUT:	LDAA PORTB,x    ;Load port b into
        ANDA #$F0       ;Get the upper nibble
        CMPA #$00       ;See if there is any input
        BEQ CNOIN       ;There is no input
        CMPA #$10       ;Compare to the bit pattern 0x10 (first row)
        BEQ  CINR0
        CMPA #$20       ;Compare to the bit pattern 0x20 (second row)
        BEQ  CINR1
        CMPA #$40       ;Compare to the bit pattern 0x40 (thrid row)
        BEQ  CINR2
        CMPA #$80       ;Compare to the bit pattern 0x80 (fourth row)
        BEQ  CINR3
        LDAA #$11        ;Should never get here
        RTS
CINR0:  LDAA #$00
        ADDA 2,SP
        RTS
CINR1:  LDAA #$04
        ADDA 2,SP
        RTS
CINR2:  LDAA #$08
        ADDA 2,SP
        RTS
CINR3:  LDAA #$0C
        ADDA 2,SP
        RTS
CNOIN:  LDAA #$11        ;Load 17 into A register
        RTS
        
SETUP:  LDAA #$0F
        STAA DDRB,x     ;Set 0x0F into DDRB this makes PB0-3 as output and 4-7 as inputs
        CLRA            ;Clear A
        CLRB            ;Clear B
INPUT0: LDAA #$08       ;Set 0x08 into Port B
        STAA PORTB,x    ;This sets PB4 as HIGH all other are LOW
        JSR BWAIT `     ;Wait a bit for the input to prop
        LDAA #$00       ;Load 0 into A
        PSHA            ;Push it onto the stack
        JSR CINPUT      ;Jump to the subroutine
        LEAS 1,SP       ;Put the stack back to normal
        CMPA #$11
        BNE HASIN
 	LDAA #$04       ;Set 0x04 into Port B
        STAA PORTB,x    ;This sets PB3 as HIGH all other are LOW
        JSR BWAIT
        LDAA #$01       ;Load 1 into A
        PSHA            ;Push it onto the stack
        JSR CINPUT      ;Jump to the subroutine
        LEAS 1,SP       ;Put the stack back to normal
        CMPA #$11
        BNE HASIN
        LDAA #$02       ;Set 0x02 into Port B
        STAA PORTB,x    ;This sets PB1 as HIGH all other are LOW
        JSR BWAIT
        LDAA #$02       ;Load 2 into A
        PSHA            ;Push it onto the stack
        JSR CINPUT      ;Jump to the subroutine
        LEAS 1,SP       ;Put the stack back to normal
        CMPA #$11
        BNE HASIN
        LDAA #$01       ;Set 0x01 into Port B
        STAA PORTB,x    ;This sets PB0 as HIGH all other are LOW
        JSR BWAIT
        LDAA #$03       ;Load 2 into A
        PSHA            ;Push it onto the stack
        JSR CINPUT      ;Jump to the subroutine
        LEAS 1,SP       ;Put the stack back to normal
        CMPA #$11
        BNE HASIN
HASIN:	SWI
        ;LDAA PORTB,x    ;Load Port B into A
        ;ANDA #$80
        ;SWI