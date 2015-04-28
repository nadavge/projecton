//FOR 2 ADC
#include <ADC.h>
#include "Teensy31FastADC.h"

// Teensy 3.1 has the LED on pin 13
#define LEDPIN 13

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
#define SAMPLES_EVENT SAMPLES-(BUFFERSIZE/2)
#define NO_EVENT -1

const int channelA2 = ADC::channel2sc1aADC0[2];

byte THRESHOLD = 180;

byte buffer[BUFFERSIZE] = {0};

byte value1 = 0;
byte value2 = 0;

long startTime = 0;
long stopTime = 0;
long totalTime = 0;
int event = NO_EVENT;

// Data for time tracking
long loopTime = 0;
long loopStartTime = 0;
bool tookTime = false;

int i = 0;
int k = 0;


void loop() 
{
	startTime = micros();
	//START SAMPLING
	//Strange init in this for, but the compiler seems to optimize this code better, so we get faster sampling
	loopStartTime = micros();
	i = 0;
	k = 0;
	event = NO_EVENT;
	for(;i<SAMPLES;i++) 
	{
		//TAKE THE READINGS
		highSpeed8bitAnalogReadMacro(channelA2,channelA2,value1,value2);
		
		buffer[k] = value1;
		
		//CHECK FOR EVENTS
		if (value1 > THRESHOLD && event != NO_EVENT) 
		{
			event = k;
			// Set i to sample the amount set by the user
			i = SAMPLES_EVENT;
		}
		
		if (++k == BUFFERSIZE)
		{
			k = 0;
			loopTime = micros() - loopStartTime;
			loopStartTime = micros();
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
	if (Serial.available()) parseSerial();

}


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
	
	Serial.print("BUFFSIZE: ");
	Serial.print(BUFFERSIZE,DEC);
	Serial.print(" Event: ");
	Serial.println(event);
	serialWrite(buffer,BUFFERSIZE);
	Serial.flush();
	
}


//This should be optimized. Writing raw binary data seems to fail a lot of times
//and I ended up loosing bytes. Maybe some form of flow-control should be used.
void serialWrite(byte *buffer,int siz) 
{
	int kk;
	for (kk=0;kk<siz;kk++) 
	{
		Serial.print(buffer[kk],HEX);		
		Serial.print(" ");
	}
	Serial.println();
}

void printInfo() 
{
	totalTime = stopTime-startTime;
	double samplesPerSec = i*1000.0/totalTime;
	
	Serial.print("T: ");
	Serial.print(totalTime);
	Serial.print(" Samples: ");
	Serial.print(i,DEC);
	Serial.print(" Samples/uSec: ");
	Serial.print(samplesPerSec,7);
	Serial.print(" Threshold: ");
	Serial.println(THRESHOLD,DEC);
	Serial.print("Loop time: ");
	Serial.println(loopTime, DEC);
	Serial.flush();
}
