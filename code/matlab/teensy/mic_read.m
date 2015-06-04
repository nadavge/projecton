function mic_read(id, data)
%MIC_READ Read the buffer sent from the microphone into the suiting vector
%   id - the id of the microphone (1-4)
%	data - the data sent in hex encoding. Each read is a byte (2 digits)
	global s;
	global buffer;
	% The middle value of the sound, used for normalization (0 - 255)
	MIDDLE_VALUE = 127.5;
	
	values = zeros(1, length(data)/2);
	i = 1;
    j = 1;
	
	while i < length(data),
		curr_byte = data(i:i+1);
		values(j) = hex32dec(curr_byte);
		i = i + 2;
		j = j + 1;
	end
	
	buffer(id, :) = values - MIDDLE_VALUE;
    %buffer(id, :) = buffer(id, :) - mean(buffer(id, :));
end