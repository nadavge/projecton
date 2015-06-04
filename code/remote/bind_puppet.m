function bind_puppet( ip, port )
%BIND_PUPPET bind the server to be controlled

	global puppet_socket;
	
	if ~isempty(puppet_socket),
		printf(2, 'Already running a remote connection!\n');
		return;
	end
	
	default_ip = '0.0.0.0';
	default_port = 29124;
	
	if ~exist('ip', 'var'),
		ip = default_ip;
	end
	
	if ~exist('port', 'var'),
		port = default_port; 
	end

	puppet_socket = tcpip(ip, port, 'NetworkRole', 'server');
	
	puppet_socket.InputBufferSize = 64;
	puppet_socket.Terminator = 13;
	puppet_socket.BytesAvailableFcn = @puppet_callback;

	fopen(puppet_socket);

end
