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
#define CODE_EVENT_INDEX "EI"
#define CODE_FREQUENCY "FS"
#define CODE_INFO "IN"
#define CODE_DEBUG "DB"
#define SEPERATOR " "

#define LED_ON() digitalWrite(LEDPIN,1)
#define LED_OFF() digitalWrite(LEDPIN,0)
#define WAIT_ACK() LED_ON(); while (! Serial.available()); Serial.read(); LED_OFF()

void setup() 
{
	pinMode(LEDPIN, OUTPUT);
	// Set the microphones
	pinMode(A2, INPUT);
	pinMode(A3, INPUT); 
	pinMode(A10, INPUT); 
	pinMode(A11, INPUT);
	highSpeed8bitADCSetup();

	Serial.begin(115200);
	//BLINK LED, WE ARE ALIVE
	LED_ON();
	delay(2000);
	LED_OFF();
	
	WAIT_ACK();
}

// Microphone buffer size
#define BUFFERSIZE 9000
// How many samples to read before checking for commands
#define SAMPLES BUFFERSIZE
// The amount of samples to take after the event was spotted
#define SAMPLES_EVENT (BUFFERSIZE/2)
#define NO_EVENT -1

const int channelA2 = ADC::channel2sc1aADC0[2];
const int channelA3 = ADC::channel2sc1aADC1[3];
const int channelA10 = ADC::channel2sc1aADC1[10];
const int channelA11 = ADC::channel2sc1aADC0[11];

// Threshold for noise detection - on surpassing send data after sampling more
byte threshold = 180;

byte buffer1[BUFFERSIZE] = {0};
byte buffer2[BUFFERSIZE] = {0};
byte buffer3[BUFFERSIZE] = {0};
byte buffer4[BUFFERSIZE] = {0};

byte value1 = 0;
byte value2 = 0;
byte value3 = 0;
byte value4 = 0;

// Totally sampled in current loop (used for time calculation)
int sampled = 0;
// Loop timing variables
long startTime = 0;
long stopTime = 0;
long totalTime = 0;
// Holds the location of the event detected
int event = NO_EVENT;

// Counts how many samples are left
int samplesLeft = 0;
// Holds the current write location in buffers
int k = 0;


void loop() 
{
	run();
}

// The loop of the teensy
void run() {
	while(true)
	{
		startTime = micros();
		event = NO_EVENT;
		for(samplesLeft=SAMPLES, sampled=0; samplesLeft--; ++sampled)
		{
			//TAKE THE READINGS
			highSpeed8bitAnalogReadMacro(channelA2,channelA3,value1,value2);
			highSpeed8bitAnalogReadMacro(channelA10,channelA11,value3,value4);
			
			buffer1[k] = value1;
			buffer2[k] = value2;
			buffer3[k] = value3;
			buffer4[k] = value4;
			
			//CHECK FOR EVENTS
			if (value1 > threshold && event == NO_EVENT) 
			{
				event = k;
				samplesLeft = SAMPLES_EVENT;
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
}

// Handle commands sent through the serial
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
		threshold += 5;
		break;						 
	case '-': 
		threshold -= 5;
		break;						 
	default:	
		break;
	}
}

// Print the microphone buffers and relevant information for interpretation
void printSamples()
{
	totalTime = stopTime - startTime;
	int frequency = sampled*1000 / totalTime;
	
	Serial.print(CODE_BUFFER_INFO SEPERATOR);
	Serial.println(BUFFERSIZE, HEX);
	
	Serial.print(CODE_FREQUENCY SEPERATOR);
	Serial.println(frequency, HEX);
	
	serialWrite(buffer1, BUFFERSIZE, 1);
	serialWrite(buffer2, BUFFERSIZE, 2);
	serialWrite(buffer3, BUFFERSIZE, 3);	
	serialWrite(buffer4, BUFFERSIZE, 4);
	
	Serial.print(CODE_EVENT_INDEX SEPERATOR);
	Serial.println(event, HEX);
	
	Serial.flush();
}

// Print a buffer of bytes with hex encoding to the serial
void serialWrite(byte *buffer,int siz, int id) 
{
	int kk;
	Serial.print(CODE_BUFFER);
	Serial.print(id, DEC);
	Serial.print(SEPERATOR);
	for (kk=0;kk<siz;kk++) 
	{
		Serial.print(buffer[kk],HEX);
		// Send without spaces
		//Serial.print(" ");
	}
	Serial.println();

	WAIT_ACK();
}

// Print general info about the system
void printInfo() 
{
	totalTime = stopTime-startTime;
	double samplesPerSec = sampled*1000.0/totalTime;
	Serial.print(CODE_INFO SEPERATOR);
	Serial.print("T: ");
	Serial.print(totalTime);
	Serial.print(" Sampled: ");
	Serial.print(sampled,DEC);
	Serial.print(" Samples/mSec: ");
	Serial.print(samplesPerSec,7);
	Serial.print(" threshold: ");
	Serial.println(threshold,DEC);
	Serial.flush();
}