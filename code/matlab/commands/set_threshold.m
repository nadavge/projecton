function set_threshold(new_threshold)
    global s;
    
    if ~isempty(s),
		% TODO if convention changes, and we check threshold from both
		%	directions, we need to reconvert it to match the convention
		new_threshold = floor(new_threshold+127.5);
		if (new_threshold < 0 || 255 < new_threshold),
			error('Value provided not in range');
			return;
		end
		send_str = strcat('ct', num2str(new_threshold));
        fprintf(s, send_str);
    end
end