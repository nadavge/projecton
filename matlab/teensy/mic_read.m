function mic_read(id, data)
%MIC_READ Read the buffer sent from the microphone into the suiting vector
%   id - the id of the microphone (1-4)
%	data - the data sent in hex encoding. Each read is a byte (2 digits)
	global s;
	values = zeros(1, length(data)/2);
	i = 1;
    j = 1;
	while i < length(data),
		curr_byte = data(i:i+1);
		values(j) = hex32dec(curr_byte);
		i = i + 2;
		j = j + 1;
	end
	
	assignin('base', strcat('buffer', num2str(id)), values);
end