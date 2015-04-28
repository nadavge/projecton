//FOR 2 ADC
#include <ADC.h>
#include "Teensy31FastADC.h"

// Teensy 3.1 has the LED on pin 13
#define LEDPIN 13

/*
 * Used for communication. Each data sent starts with 3 bytes stating
 * what type of data is transmitted. This is the code of the data.
 */
#define CODE_BUFFER "B"
#define CODE_BUFFER_INFO "BI"
#define CODE_INFO "IN"
#define SEPERATOR " "

void setup() 
{

	pinMode(LEDPIN, OUTPUT);
	pinMode(A2, INPUT); 
	highSpeed8bitADCSetup();

	Serial.begin(115200);
	//BLINK LED, WE ARE ALIVE
	digitalWrite(LEDPIN,1);
	delay(2000);
	digitalWrite(LEDPIN,0);
}

#define BUFFERSIZE 2048
#define SAMPLES BUFFERSIZE
// The amount of samples to take after the event was spotted
#define SAMPLES_EVENT (BUFFERSIZE/2)
#define NO_EVENT -1

const int channelA2 = ADC::channel2sc1aADC0[2];

byte THRESHOLD = 180;

byte buffer[BUFFERSIZE] = {0};

byte value1 = 0;
byte value2 = 0;

int sampled = 0;
long startTime = 0;
long stopTime = 0;
long totalTime = 0;
int event = NO_EVENT;

int i = 0;
int k = 0;


void loop() 
{
	run();
}

void run() {
	while(true)
	{
		startTime = micros();
		event = NO_EVENT;
		for(i=SAMPLES, sampled=0; i--; ++sampled)
		{
			//TAKE THE READINGS
			highSpeed8bitAnalogReadMacro(channelA2,channelA2,value1,value2);
			
			buffer[k] = value1;
			
			//CHECK FOR EVENTS
			if (value1 > THRESHOLD && event != NO_EVENT) 
			{
				event = k;
				i = SAMPLES_EVENT;
			}
			
			if (++k == BUFFERSIZE)
			{
				k = 0;
			}
		}
		stopTime = micros();
		
		//WAS AN EVENT BEEN DETECTED?
		if (event != NO_EVENT) 
		{
			printInfo();
			printSamples(); 
		}
	
		//DID WE RECEIVE COMMANDS?
		// TODO Signal the user if an event was spotted early on the loop
		if (Serial.available()) parseSerial();
	}
} // Ends while


void parseSerial() 
{
	char c = Serial.read();

	switch (c) 
	{
	case 'p': 
		printInfo();
		break;
	case 's': 
		printSamples();
		break;
	case '+': 
		THRESHOLD += 5;
		break;						 
	case '-': 
		THRESHOLD -= 5;
		break;						 
	default:	
		break;
	}
}


void printSamples() 
{
	Serial.print(CODE_BUFFER_INFO SEPERATOR);
	Serial.print("BUFFSIZE: ");
	Serial.print(BUFFERSIZE,DEC);
	Serial.print(" Event: ");
	Serial.println(event);
	serialWrite(buffer,BUFFERSIZE, 1);	
}


//This should be optimized. Writing raw binary data seems to fail a lot of times
//and I ended up loosing bytes. Maybe some form of flow-control should be used.
void serialWrite(byte *buffer,int siz, int id) 
{
	int kk;
	Serial.print(CODE_BUFFER);
	Serial.print(id, HEX);
	Serial.print(SEPERATOR);
	for (kk=0;kk<siz;kk++) 
	{
		Serial.print(buffer[kk],HEX);
		// Send without spaces
		//Serial.print(" ");
	}
	Serial.println();
	Serial.flush();
}

void printInfo() 
{
	totalTime = stopTime-startTime;
	double samplesPerSec = sampled*1000.0/totalTime;
	Serial.print(CODE_INFO SEPERATOR);
	Serial.print("T: ");
	Serial.print(totalTime);
	Serial.print(" Sampled: ");
	Serial.print(sampled,DEC);
	Serial.print(" Samples/uSec: ");
	Serial.print(samplesPerSec,7);
	Serial.print(" Threshold: ");
	Serial.println(THRESHOLD,DEC);
	Serial.flush();
}
