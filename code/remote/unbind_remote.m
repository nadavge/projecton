function unbind_remote
%UNBIND_REMOTE Unbinds the remote from the host puppet
	global remote_socket;
	
	if isempty( remote_socket ),
		return;
	end
	
	%TODO maybe send a close signal to the displayer
	fclose(remote_socket);
	remote_socket = [];
end
