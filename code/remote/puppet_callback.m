function puppet_callback( conn, ~ )
%PUPPET_CALLBACK A callback for the puppet TCP socket

	commands = {'once', 'run', 'wait'};
	command = fscanf(conn, '%s');
	
	if any(ismember(commands, command)),
		eval(command);
	else
		display(command);
	end

end
