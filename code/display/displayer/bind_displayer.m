function bind_displayer( soldier_index, ip, port )
%BIND_DISPLAYER Bind a displayer to a socket
%   Given the soldier to be connected at the other end,
%	the ip to listen on and the port, opens a communication tunnel
	global server_sockets;
	
	default_ip = '0.0.0.0';
	default_ports = [30001, 30002];
	
	if ~exist('ip', 'var'),
		ip = default_ip;
	end
	
	if ~exist('port', 'var'),
		port = default_ports( soldier_index ); 
	end

	server_sockets{ soldier_index } = tcpip(ip, port, 'NetworkRole', 'server');
	
	server_sockets{ soldier_index }.InputBufferSize = 64;
	server_sockets{ soldier_index }.Terminator = 13;
	server_sockets{ soldier_index }.BytesAvailableFcn = @(conn, event) displayer_callback(conn, event, soldier_index);

	fopen(server_sockets{ soldier_index });

end
