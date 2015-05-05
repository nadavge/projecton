function freq_read(raw_freq)
	display(raw_freq);
	freq = hex32dec(raw_freq); % Comes as samples/msec = kHz
	freq = 1000*freq; % Transform to Hz
	assignin('base', 'fs', freq);
end