function unbind_soldier( soldier_index )
%UNBIND_DISPLAYER Unbinds the soldier's connection to displayer
	global soldier_sockets;
	
	if ~socket_initialized( soldier_sockets, soldier_index ),
		return;
	end

	%TODO maybe send a close signal to the displayer
	fclose(soldier_sockets{ soldier_index });
	soldier_sockets{ soldier_index } = [];
end
