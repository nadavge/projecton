#Robokof
The projecton of Berko-team, or Italy-team.
A gunfire locator using:
- Teensy 3.1
- 4 Microphones
- A computer with matlab

##Commands
The commands are seperated into categories:

###State Changers
A list of commands used to change states in the teensy operation scheme

####bind(port=3)
Bind the teensy to the provided port (if not provided, use port 3).

####wait
Tells the teensy to wait

####run
Tells the teensy to run sampling.

By default, the MOP is not run unless told to.

####once
Tells the teensy to run sampling, but once spotted a gunfire - stop.

By default, the MOP is not run unless told to.

####unbind
Unbinds the teensy

###Parameters

####enable_mop
Enables MOP execution on gunfire detection by the teensy.

####disable_mop
Disables MOP execution on gunfire detection by the teensy.

####set_arc(length)
Set the arc_length used by MOP *in meters*.

####set_threshold(theshold)
Set the threshold for detection on the teensy (0-127.5).

###General Purpose

####plotem
Plots the microphone readings in the following color order:

1. red
2. green
3. blue
4. black

####hard_reset
Require matlab to reset all com_ports used