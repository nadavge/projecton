function bindTCPsoldier( ip, port )

    global tc;
    
    if ~exist('port', 'var'),
       port = 30001; 
    end
    
    tc = tcpip(ip, port, 'NetworkRole', 'client');
        
    fopen(tc);

end