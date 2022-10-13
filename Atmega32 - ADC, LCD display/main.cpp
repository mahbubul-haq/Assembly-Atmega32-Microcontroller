#ifndef F_CPU
#define F_CPU 16000000UL // 16 MHz clock speed
#endif
#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h"

char intToChar(int x) {return x + '0';}

void doubleToString(double result, char *output, int fromIndex) {
	
	int x = (int) result;
	result = result - x;
	
	printf("%d\n", x);
	
	result *= 10;
	
	int y = (int) result;
	result -= y;
	
	result *= 10;
	
	int z = (int) result;
	
	output[fromIndex++] = intToChar(x);
	output[fromIndex++] = '.';
	output[fromIndex++] = intToChar(y);
	output[fromIndex++] = intToChar(z);
	
}

int main(void)
{
	DDRD = 0xFF;
	DDRC = 0xFF;
	Lcd4_Init();
	
	ADMUX = 0b01000101;
	ADCSRA = 0b10000110;
	
	unsigned char msb = 0, lsb = 0;
	unsigned int temp = 0;
	double result = 0, step = 5.0 / 1024;
	char output[5] = "";
	Lcd4_Set_Cursor(1,1);
	Lcd4_Write_String("Voltage: ");
	
	
	while(1)
	{
		ADCSRA |= (1 << ADSC);
		while (ADCSRA & (1 << ADSC)) {}
			
		lsb = ADCL;
		msb = ADCH;
		
		result = lsb;
		temp = msb;
		result = result + (temp << 8);
		
		result = result * step;
		
		doubleToString(result, output, 0);
		
		Lcd4_Set_Cursor(1,10);
		Lcd4_Write_String(output);
		
	}
}


/*Lcd4_Set_Cursor(1,1);
		Lcd4_Write_String("electroSome LCD Hello World");
		for(i=0;i<15;i++)
		{
			_delay_ms(10);
			Lcd4_Shift_Left();
		}
		for(i=0;i<15;i++)
		{
			_delay_ms(10);
			Lcd4_Shift_Right();
		}
		Lcd4_Clear();
		Lcd4_Set_Cursor(2,1);
		Lcd4_Write_Char('e');
		Lcd4_Write_Char('S');
		_delay_ms(200);*/