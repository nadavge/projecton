function freq_read(raw_freq)
	global fs;
	display(raw_freq);
	freq = hex32dec(raw_freq); % Comes as samples/msec = kHz
	% TODO Change accuracy of this by multiplication
	freq = 1000*freq; % Transform to Hz
	
	fs = freq;
end