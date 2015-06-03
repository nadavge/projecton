function unbind_soldier( soldier_index )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
	global soldier_sockets;
	
    if length(soldier_sockets) < soldier_index,
        return
    end
	
	if isempty(soldier_sockets{ soldier_index }),
		return
	end

	fclose(soldier_sockets{ soldier_index });
	server_sockets{ soldier_index } = [];
end