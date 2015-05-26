function rotated_buffer = rotate_buffer(buffer, event_index, dest)
%ROTATE_BUFFER Rotate the buffer so the event is in dest (from 0 to 1)
	buff_size = size(buffer, 2);
	dest_index = floor(desired_location * buff_size);
	% Calc the distance between the destination and the current index
	shift = dest_index - event_index;
	
	% Shift the buffer in the desired direction
	rotated_buffer = circshift(buffer, [0 shift]);
end