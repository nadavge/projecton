#include <EEPROM.h>

#define MIC_COUNT 4

const char helpMsg[] = 
"==================\n\n"
"Pins USABLE on ADC0\n"
" 0, 1, ..., 13\n\n"
"Pins USABLE on ADC1\n"
" 2, 3, 10, 12, 13\n\n"
"ACD0: Mics #2, #4\n"
"ADC1: Mics #1, #3\n\n"
"==================\n\n";

#define WAIT()\
	while (! Serial.available())\
	{\
		delay(250);\
	}

void setup()
{
	Serial.begin(115200);
}

void loop()
{
	unsigned char val = 0;
	
	Serial.println("What would you like to do?");
	Serial.println("o - overwrite");
	Serial.println("r - read");
	Serial.println("h - help");
	
	WAIT();
	
	switch (Serial.read())
	{
	case 'o':
		Serial.println("Enter the microphone pins in HEX");
		
		for (int i=0; i < MIC_COUNT;)
		{
			Serial.print("Mic #");
			Serial.print(i+1, DEC);
			Serial.println("...");
			
			WAIT();
			
			val = Serial.read();
			val = decodeHex(val);
			
			if (val == 255)
			{
				Serial.println("INVALID VALUE!");
				continue;
			}
			
			Serial.println(val,DEC);
			EEPROM.write(i, val);
			++i;
		}
		
		break;
		
	case 'r':
		Serial.println("The microphone pins are:");
		
		for (int i=0; i < MIC_COUNT; ++i)
		{
			Serial.print("Mic #");
			Serial.print(i+1, DEC);
			Serial.print(": ");
			Serial.println(EEPROM.read(i), DEC);
		}
		
		break;
		
	case 'h':
		Serial.println(helpMsg);
		break;
	}
	
	delay(250);
}

unsigned char decodeHex(const unsigned char ch)
{
	if ('0' <= ch && ch <= '9')
	{
		return ch - '0';
	}
	
	if ('a' <= ch && ch <= 'f')
	{
		return 10 + ch - 'a';
	}
	
	if ('A' <= ch && ch <= 'F')
	{
		return 10 + ch - 'A';
	}
	
	return 255;	
}