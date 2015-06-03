function bindTCPclient( ip, port )

    global t;
    
    if ~exist('port', 'var'),
       port = 30001; 
    end
    
    t = tcpip(ip, port, 'NetworkRole', 'client');
    
    fopen(t);
    
    t.InputBufferSize(64);
    t.Terminator = 13;
    t.BytesAvailableFcn = @ReadDataFromTCP;


end

