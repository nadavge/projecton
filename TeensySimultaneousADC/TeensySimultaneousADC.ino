#include <ADC.h>
#include "Teensy31FastADC.h"

//======================== DEFINITIONS =============================

// PINS
#define LEDPIN 13
#define PIN1 2
#define PIN2 3
#define PIN3 10
#define PIN4 11

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

#define WAIT_ACK() \
	LED_ON();\
	while (! Serial.available());\
	Serial.read();\
	LED_OFF()
	
#define CHECK_CMD() \
	if (Serial.available())\
	{\
		LED_OFF();\
		parseSerial();\
	}

// Microphone buffer size
#define BUFFERSIZE 9000
// How many samples to read before checking for commands
#define SAMPLES BUFFERSIZE
// The amount of samples to take after the event was spotted
#define SAMPLES_EVENT (BUFFERSIZE/2)
#define NO_EVENT -1

enum State
{
	UNBOUND,
	WAITING,
	RUNNING,
	ONCE
};

//======================== GLOBALS =================================

/* Pins USABLE on ADC0
 * 0, 1, ..., 13
 * Pins USABLE on ADC1
 * 2, 3, 10, 12, 13
 *
 * Channel 11 must be on ADC0, since on ADC1 it is disabled (See ADC_Module == 31)
 * This requires consideration when using the fast read, since the ADC0 should go first
 */
const int channel1 = ADC::channel2sc1aADC1[PIN1];
const int channel2 = ADC::channel2sc1aADC0[PIN2];
const int channel3 = ADC::channel2sc1aADC1[PIN3];
const int channel4 = ADC::channel2sc1aADC0[PIN4];

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

// The state of the code execution
State state = UNBOUND;

//======================== STATE CHANGERS ===========================

inline void state_bind()
{
	if (state == UNBOUND)
	{
		state = WAITING;
	}
}

inline void state_unbind()
{
	state = UNBOUND;
}

inline void state_wait()
{
	if (state != UNBOUND)
	{
		state = WAITING;
	}
}

inline void state_run()
{
	if (state != UNBOUND)
	{
		state = RUNNING;
	}
}

inline void state_once()
{
	if (state != UNBOUND)
	{
		state = ONCE;
	}
}

//======================== CONTROL CODE =============================

void setup() 
{
	pinMode(LEDPIN, OUTPUT);
	// Set the microphones
	pinMode(PIN1, INPUT);
	pinMode(PIN2, INPUT);
	pinMode(PIN3, INPUT);
	pinMode(PIN4, INPUT);
	highSpeed8bitADCSetup();

	Serial.begin(115200);
	//BLINK LED, WE ARE ALIVE
	LED_ON();
	delay(2000);
	LED_OFF();
}

void loop() 
{
	switch (state)
	{
	case UNBOUND:
		unbound();
		break;
	case WAITING:
		waiting();
		break;
	case RUNNING:
	case ONCE:
		running();
		break;
	}
}

void unbound()
{
	LED_ON();
	
	for (int i=0; i < 2; ++i)
	{
		CHECK_CMD();
		delay(100);
	}
	
	LED_OFF();
	
	for (int i=0; i < 16; ++i)
	{
		CHECK_CMD();
		delay(100);
	}
}

void waiting()
{
	LED_ON();
	for (int i=0; i < 2; ++i)
	{
		CHECK_CMD();
		delay(100);
	}
	
	LED_OFF();
	
	for (int i=0; i < 4; ++i)
	{
		CHECK_CMD();
		delay(100);
	}
}

void running()
{
	// Inner loop allows faster operation (no function switch overhead)
	while(state == RUNNING || state == ONCE)
	{
		startTime = micros();
		event = NO_EVENT;
		for(samplesLeft=SAMPLES, sampled=0; samplesLeft--; ++sampled)
		{
			//TAKE THE READINGS
			highSpeed8bitAnalogReadMacro(channel1,channel2,value1,value2);
			highSpeed8bitAnalogReadMacro(channel3,channel4,value3,value4);
			
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
			// If set to run once, change to waiting
			if (state == ONCE)
			{
				state = WAITING;
			}
			
			printInfo();
			printSamples(); 
		}
	
		//DID WE RECEIVE COMMANDS?
		// TODO Signal the user if an event was spotted early on the loop
		if (Serial.available()) parseSerial();
	}
}

// Handle commands sent through the serial
void parseSerial(char c)
{
	// If unbound, allow only bounding
	if (state == UNBOUND && c != 'b')
	{
		return;
	}
	
	switch (c) 
	{
	case 'p': 
		printInfo();
		break;
	case 's': 
		printSamples();
		break;
	case 'b':
		state_bind();
		break;
	case 'u':
		state_unbind();
		break;
	case 'w':
		state_wait();
		break;
	case 'r':
		state_run();
		break;
	case 'o':
		state_once();
		break;
	case 'f':
		fake_send();
		break;
	case '+': 
		threshold += 5;
		break;			 
	case '-':
		threshold -= 5;
		break;
	}
}

// Handle commands waiting in the serial
void parseSerial()
{
	char c = Serial.read();
	parseSerial(c);
}

// Print the microphone buffers and relevant information for interpretation
void printSamples()
{
	totalTime = stopTime - startTime;
	// TODO Change accuracy of this by multiplication
	int frequency = sampled*1000 / totalTime;
	
	Serial.print(CODE_BUFFER_INFO SEPERATOR);
	Serial.println(BUFFERSIZE, HEX);
	
	Serial.print(CODE_FREQUENCY SEPERATOR);
	Serial.println(frequency, HEX);
	WAIT_ACK();
	
	serialWrite(buffer1, BUFFERSIZE, 1);
	serialWrite(buffer2, BUFFERSIZE, 2);
	serialWrite(buffer3, BUFFERSIZE, 3);	
	serialWrite(buffer4, BUFFERSIZE, 4);
	
	Serial.print(CODE_EVENT_INDEX SEPERATOR);
	Serial.println(event, HEX);
	
	Serial.flush();
}

// Print fake info
void fake_send()
{
	int frequency = 182;
	
	Serial.print(CODE_BUFFER_INFO SEPERATOR);
	Serial.println(BUFFERSIZE, HEX);
	
	Serial.print(CODE_FREQUENCY SEPERATOR);
	Serial.println(frequency, HEX);
	WAIT_ACK();
	
	for (int bufferId=1; bufferId <= 4; ++bufferId)
	{
		Serial.print(CODE_BUFFER);
		Serial.print(bufferId, DEC);
		Serial.print(SEPERATOR);
		
		for (int kk=0;kk< BUFFERSIZE;kk++) 
		{
			if ((kk&255) < 0x10)
			{
				Serial.print('0');
			}
			Serial.print(kk&255, HEX);
		}
		
		Serial.println();

		WAIT_ACK();
	}
	
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
		if (buffer[kk] < 0x10)
		{
			Serial.print('0');
		}
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
