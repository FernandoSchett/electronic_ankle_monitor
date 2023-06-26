#include <msp430g2553.h>

#pragma vector=PORT1_VECTOR // Define o vetor de interrupção da porta 1.
__interrupt void ALTERA_LEDS(void){
    __delay_cycles(300000); // Gera um delay de 300.000 ciclos

    P1OUT ^= BIT6; // Realiza uma XOR para altera o estado do led VERDE
    P1OUT ^= BIT0; // Realiza uma XOR para altera o estado do led VERMELHO

    P1IFG = ~BIT3; // Limpa o flag da interrupção na porta 1.3.
}

void main(void){
    int loop = 0;
    WDTCTL = WDTPW + WDTHOLD; // Stop watchdog timer
    P1DIR = BIT0 | BIT6; // Habilita as portas dos leds como saida
    P1IE = BIT3; // Habilita o P1.3 para ativar interrupcoes
    P1OUT = BIT3; // Define o estado do botao para HIGH, ativando a interrupcao apenas quando for acionado
    P1REN = BIT3; // Habilita o resistor do pino do botao (P1.3) (Isso deve ser feito para evitar que o botao flutue entre high e low)

    P1OUT ^= BIT6; // Realiza uma XOR para ligar o led VERDE

    __enable_interrupt(); // Habilita interrupcoes
    while(1){ // Permanece no loop a espera de interrupcoes
        loop++;
    }
}
