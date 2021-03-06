function bind_puppet( ip, port )
%BIND_REMOTE connect to a puppet host

	global remote_socket;
	
	if ~isempty(remote_socket),
		printf(2, 'Already running a remote connection!\n');
		return;
	end
	
	default_port = 29124;
	
	if ~exist('port', 'var'),
		port = default_port; 
	end

	remote_socket = tcpip(ip, port, 'NetworkRole', 'client');

	fopen(remote_socket);

end
