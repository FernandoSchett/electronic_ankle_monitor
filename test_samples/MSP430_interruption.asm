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

      bis.b   #008h,&P1IE                              ; habilita interrupção no P1.3
      bis.b   #008h,&P1IES                             ; mudar estado de high para low
      bic.b   #008h,&P1IFG                             ; habilitar interrupção para o pino P1.3
	  bis.w   #GIE,SR                                  ; habilita o GIE (Global Enable Interruption)
      MOV.B  #1, P1DIR                                 ; configura Pl.O como saída
      CLR    R9                                        ; apaga o R9
loop:                                                  ; loop infinito a espera da interrupção
      INC R9
      JMP loop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
P1_ISR;     Toggle P1.0 Output
;-------------------------------------------------------------------------------

      PUSH   R9                                        ; salva o estado de R9 na pilha
      CLR    R9                                        ; apaga R9
      XOR.B  #1, &P1OUT                                ; inverte o estado do pino Pl.O

      MOV    #30000, R10                               ; mover um valor grande para dar um delay
loop2:                                                 ; loop para dar um delay entre desligado e ligado
	  SUB #2, R10
	  JNZ loop2

      XOR.B  #1, &P1OUT                                ; inverte o estado do pino Pl.O

      POP   R9                                         ; restaura o estado de R9 da pilha
      bic.b  #008h,&P1IFG                              ; sinaliza que a interrupção foi concluída
      RETI                                             ; retorna da interrupção
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .sect   ".int02"
            .short  P1_ISR
            
