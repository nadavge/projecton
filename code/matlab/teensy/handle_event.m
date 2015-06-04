function handle_event(raw_index)
%HANDLE_EVENT Handle the event of detection
%   Reads the index in which the event occurred in hex encoding
	global buffer fs mop_enabled;
	NO_EVENT = -1;
	
	event_index = hex32dec(raw_index);
	
	toc
	
	% If no event occurred do nothing
	if event_index == NO_EVENT,
		return
	end
	
	% Rotate the buffers so the event is in the desired location from 
	buffer = rotate_buffer(buffer, event_index, 0.5);
	
	if mop_enabled,
		master_of_puppets(buffer, fs);
	end
	
end
