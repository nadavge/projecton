function handle_event(raw_index)
	NO_EVENT = -1
	
	index = hex32dec(raw_index);

	if index == NO_EVENT,
		return
	end
	
	buffer1 = eval('buffer1');
	buffer2 = eval('buffer2');
	buffer3 = eval('buffer3');
	buffer4 = eval('buffer4');
	fs = eval('fs');
	
	master_of_puppets(buffer1, buffer2, buffer3, buffer4, fs);
end