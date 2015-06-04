function unbind_displayer( soldier_index )
%UNBIND_DISPLAYER Unbinds the displayer from the requested soldier
	global server_sockets;
	
	if ~socket_initialized( server_sockets, soldier_index ),
		return;
	end
	
	%TODO maybe send a close signal to the displayer
	fclose(server_sockets{ soldier_index });
	server_sockets{ soldier_index } = [];
end
