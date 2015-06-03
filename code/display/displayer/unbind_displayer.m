function unbind_displayer( soldier_index )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
	global server_sockets;
	
    if length(server_sockets) < soldier_index,
        return
    end
	
	if isempty(server_sockets{ soldier_index }),
		return
	end
	
	% TODO maybe remove (quite redundant)
	%if ~strcmp(server_sockets{ soldier_index }.status, 'open'),
	%	return
	%end

	fclose(server_sockets{ soldier_index });
	server_sockets{ soldier_index } = [];
end