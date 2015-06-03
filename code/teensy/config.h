#ifndef _CONFIG_H
#define _CONFIG_H

#define VERSION "0.2.0"
/*
 * The frequency is calculated by dividing the number of samples by the time it took
 * to sample them. Since the time is in micros, the frequency is in MHz. Therefore,
 * to get it to Hz we need to multiply by 10^6. Totally, we send here up to the 10 Hz
 * rounding, since we only get the 5 first digits above the dot.
 */
#define FREQ_FACTOR 100000

// The location of the event's location in the buffer, in the range [0,1]
#define EVENT_LOCATION 0.5f

// Microphone buffer size
#define BUFFERSIZE 12000

// How many samples to read before checking for commands
#define SAMPLES BUFFERSIZE

#define DEFAULT_THRESHOLD 180

//TODO determine real value with yoel
#define THRESHOLD_LIFE 1000
#define THRESHOLD_MICS 2

#define LO_SARUF 1 // [2,3,10,11] -> [1,2,3,4]
#define SARUF 2 // [2,3,12,11] -> [1,2,3,4]

#define TEENSY SARUF

/* Pins USABLE on ADC0
 * 0, 1, ..., 13
 * Pins USABLE on ADC1
 * 2, 3, 10, 12, 13
 *
 * Channel 11 must be on ADC0, since on ADC1 it is disabled (See ADC_Module == 31)
 * This requires consideration when using the fast read, since the ADC0 should go first
 */

#define PIN1 2
#define PIN2 3
#if TEENSY==LO_SARUF
	#define PIN3 10
#elif TEENSY==SARUF
	#define PIN3 12
#endif
#define PIN4 11

#endif //_CONFIG_H