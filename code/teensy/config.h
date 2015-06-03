#ifndef _CONFIG_H
#define _CONFIG_H

#define VERSION "0.3.0"
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

#endif //_CONFIG_H