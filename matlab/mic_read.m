function mic_read(id, data)
	values = zeros(1, length(data)/2);
	i = 1;
    j = 1;
	while i < length(data),
		curr_byte = data(i:i+1);
		values(j) = hex2dec(curr_byte);
		i = i + 2;
		j = j + 1;
	end
	
	assignin('base', strcat('buffer', num2str(id)), values);
end