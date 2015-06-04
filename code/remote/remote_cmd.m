function remote_cmd( command )
%REMOTE_CMD send a command to the puppet

	global remote_socket;
	
	if isempty(remote_socket),
		printf(2, 'No available connection.\n');
		return;
	end
	
	fprintf(remote_socket, [command 13]);

end
