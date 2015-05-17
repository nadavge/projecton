function handle_event(raw_index)
%HANDLE_EVENT Handle the event of detection
%   Reads the index in which the event occured in hex encoding
	global buffer1 buffer2 buffer3 buffer4 fs
	NO_EVENT = -1;
	
	index = hex32dec(raw_index);

	% If no event occured do nothing 
	if index == NO_EVENT,
		return
	end
	
	% Else read the buffers, rotate them so the event is in the middle of buffer1
	% and handle it with master_of_puppets
	
	buff_end = length(buffer1);
	buff_mid = floor(buff_end/2);

	if index > buff_mid,
		indexes_A = (index - buff_mid):buff_end;
		indexes_B = 1:(index - buff_mid - 1);
	else,
		indexes_A = (buff_end - (buff_mid - index) + 1):buff_end;
		indexes_B = 1:(buff_end - (buff_mid - index));
	end
	
	toc
	% buffer1 = [ buffer1(indexes_A) buffer1(indexes_B) ];
	% buffer2 = [ buffer2(indexes_A) buffer2(indexes_B) ];
	% buffer3 = [ buffer3(indexes_A) buffer3(indexes_B) ];
	% buffer4 = [ buffer4(indexes_A) buffer4(indexes_B) ];
	
	
	
	% master_of_puppets(buffer1, buffer2, buffer3, buffer4, fs);
end