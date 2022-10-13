/*
 * 1605051.c
 *
 * Created: 4/7/2021 10:54:42 AM
 * Author : mdmah
 */ 
#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>


unsigned char portd[] = {0xFF, 0x01, 0x01, 0b11101101, 0b11101101, 0b11101101, 0b11101101, 0xFF };
unsigned char portc[] = {1, 2, 4, 8, 16, 32, 64, 128};
unsigned char portd_temp[8];
unsigned char flag = 0;
	
ISR(INT2_vect) {
	flag ^= 1;
	_delay_ms(10);
}

int main(void)
{
    MCUCSR = (1 << JTD);
	MCUCSR = (1 << JTD);
	
	DDRD = 0xFF;
	DDRC = 0xFF;
	int i = 0, j = 0;
	
    while (1)
    {
		
		for (i = 0; i < 8; i++) {
			PORTC = portc[i];
			PORTD = portd[i];
			_delay_ms(3);
		}
		
		
		GICR |= (1 << INT2);
		MCUCSR |= (1 << ISC2);
		sei();
		
		if (flag == 1) {
			for (i = 0; i < 8; i++) portd_temp[i] = portd[i];
			
			for (i = 0; i < 8; i++) {
				unsigned char lsb = portd[i] & 128;
				portd[i] <<= 1;
				lsb >>= 7;
				portd[i] |= lsb;
				int k = 0;
				for (k = 0; k < 2; k++) {
				
					for (j = 0;j < 8; j++) {
						PORTC = portc[j];
						PORTD = portd_temp[j];
						_delay_ms(3);
					}
				}
				
			}
			
		}
	}
    
}

