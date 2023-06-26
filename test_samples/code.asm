#include "msp430.h"                     ; #define controlled include file

        NAME    main                    ; module name

        PUBLIC  main                    ; make the main label vissible
                                        ; outside this module
        ORG     0FFFEh
        DC16    init                    ; set reset vector to 'init' label

        RSEG    CSTACK                  ; pre-declaration of segment
        RSEG    CODE                    ; place program in 'CODE' segment

init:   MOV     #SFE(CSTACK), SP        ; set up stack

main:   NOP                             ; main program
        MOV.W   #WDTPW+WDTHOLD,&WDTCTL  ; Stop watchdog timer

        MOV.W #0x0010,R4
        MOV.W #0x0008,R6
        XOR.W R4,R6
        
        BIC #1,SR
        
        DADD R4,R4
        DADD R4,R4
        DADD R6,R6
        DADD R6,R6
        
        CMP R4,R6 ; C = 0 N = 1 Z = 0
        CMP R6,R4 ; C = 1 N = 0 Z = 0
        CMP R6,R6 ; C = 1 N = 0 Z = 1

	MOV.W #0x0011,R5
        MOV.W #0x0007,R7
	MOV.W #0x0010,R8
        MOV.W #0x0008,R9

        SUB R9,R7 ; R7-R9=0xFFFF, C=0, N=1
        SUBC R8,R5 ; R5-R8=0x0000, C=1, Z=1

        
        
        END