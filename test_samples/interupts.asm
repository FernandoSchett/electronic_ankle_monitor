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

      MOV    #0x3FF,SP                                 ; inicializa o apontador da pilha
      MOV    #WDTPW+WDTHOLD,WDTCTL                     ; desliga o watchdog
      bis.b   #008h,&P1IE
      bis.b   #008h,&P1IES
      bic.b   #008h,&P1IFG
	  bis.w   #GIE,SR
      MOV.B  #0,P1DIR                                  ; configura Pl.O como saída
      MOV.B  #1,P1DIR                                  ; configura Pl.O como saída                                            ; habilita interrupções
      CLR    R9                                        ; apaga o R9
      CLR    R8
      INC R9
      INC R9
      INC R9
      CLR    R12

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
P1_ISR;     Toggle P1.0 Output
;-------------------------------------------------------------------------------

      PUSH   R9                                        ; Salva o estado de R9 na pilha
      MOV    &0x03F8, R8
      CLR    R9                                        ; apaga R9
      INC    R12
      XOR.B  #1, P1DIR                                 ; inverte o estado do pino Pl.O
      ;POP    R9
      CLR    R12
      ;POP    R9                                        ; restaura o estado de R9 da pilha
      ;MOV    @SP+, R9
      bic.b   #008h,&P1IFG
      RETI                                             ; retorna da interrupção
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .sect   ".int02"
            .short  P1_ISR
            
