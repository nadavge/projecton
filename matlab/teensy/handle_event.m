function handle_event(raw_index)
%HANDLE_EVENT Handle the event of detection
%   Reads the index in which the event occured in hex encoding
	global buffer fs mop_enabled;
	NO_EVENT = -1;
	
	index = hex32dec(raw_index);

	% If no event occured do nothing 
	if index == NO_EVENT,
		return
	end
	
	% Else read the buffers, rotate them so the event is in the middle of buffer1
	% and handle it with master_of_puppets
	
	buff_end = size(buffer, 2);
	buff_mid = floor(buff_end/2);

	if index > buff_mid
		indexes_A = (index - buff_mid):buff_end;
		indexes_B = 1:(index - buff_mid - 1);
	else
		indexes_A = (buff_end - (buff_mid - index) + 1):buff_end;
		indexes_B = 1:(buff_end - (buff_mid - index));
	end
	
	toc
	
	buffer = cat(2, buffer(:, indexes_A), buffer(:, indexes_B));
	
	if mop_enabled,
		master_of_puppets(buffer(1, :), buffer(2, :), buffer(3, :), buffer(4, :), fs);
	end
	
end
