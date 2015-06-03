function bindTCPsoldier( soldier_index, ip, port )

    global soldier_sockets;
	
	default_ports = [30001, 30002];
    
    if ~exist('port', 'var'),
       port = default_ports( soldier_index ); 
    end
    
    soldier_sockets{ soldier_index } =  tcpip(ip, port, 'NetworkRole', 'client');

    fopen(soldier_sockets{ soldier_index });

end