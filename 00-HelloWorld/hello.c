#include <stdint.h>
#include "reg.h"

#define USART_FLAG_TXE	((uint16_t) 0x0080) /* location of bit TXE at UARTn_SR */

int puts(const char *str)
{
	while (*str) { /* keep sending before reaching null-terminator */
		while (!(*(USART2_SR) & USART_FLAG_TXE)); /* send next byte after previous byte sent */
		*(USART2_DR) = *str++ & 0xFF;
	}
	return 0;
}

void main(void)
{
	/*
	 * APB2 and APB1 Configuration
	 * RCC_APB2ENR: Enable Alternate Function IO clock for APB2 (AFIOEN).
	 * RCC_APB2ENR: Enable clock of IO port A (IOPAEN).
	 * RCC_APB1ENR: Enable clock of USART2 (USART2EN).
	 */
	*(RCC_APB2ENR) |= (uint32_t) (0x00000001 | 0x00000004);
	*(RCC_APB1ENR) |= (uint32_t) (0x00020000);

	/*  
	 * USART2 I/O Configuration
	 * GPIOA_CRL: Pin config for USART's RX (PA3) and TX (PA2).
	 * GPIOA_CRH: Just keep it remains reset value.
	 */
	*(GPIOA_CRL) = 0x00004B00;
	*(GPIOA_CRH) = 0x44444444;

	/* 
	 * USART2 Configuration
	 * USART2_CR1: Enable RX and TX of USART2.
	 * USART2_CR1: Enable USART2.
	 */
	*(USART2_CR1) = 0x0000000C;
	*(USART2_CR1) |= 0x2000;

	puts("Hello World!\n");

	while (1); /* since the work has done, we hang here */
}
