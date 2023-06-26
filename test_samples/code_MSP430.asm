;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:
        mov   #0x3FF,SP   ; inicializa o apontador da pilha
        mov   #WDTPW+WDTHOLD,&WDTCTL  ; Stop watchdog timer
        mov   #TASSEL_1+ID_3+MC_1+TAIE,TACTL  ;configura o timer
        mov   #0x0003,TACCR0   ; configura o módulo de contagem

        mov.b #1,P1DIR   ;configura P1.0 como saída
        EINT              ;habilita interrupções
        clr     R9       ;apaga o R9

loop    INC     R9       ;incrementa o contador
        br      #loop     ; loop infinito



trata:   ;RTI

      PUSH  R9     ;salva o estado de R9 na pilha
      clr   R9        ;apaga R9
      xor.b   #1,P1OUT        ;inverte o estado do pino P1.0
      POP     R9      ; restaura o estado de R9 da pilha
      reti            ;retorna da interrupção

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
            .sect ".int08"
            .short trata

