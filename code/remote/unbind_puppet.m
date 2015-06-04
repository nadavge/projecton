function unbind_puppet
%UNBIND_PUPPET Unbinds the displayer from the requested soldier
	global puppet_socket;
	
	if isempty( puppet_socket ),
		return;
	end
	
	%TODO maybe send a close signal to the displayer
	fclose(puppet_socket);
	puppet_socket = [];
end
