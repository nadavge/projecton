function bindTCPserver( ip, port )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    global t;
    
    if ~exist('port', 'var'),
       port = 30001; 
    end

    t = tcpip(ip, port, 'NetworkRole', 'server');
    
    t.InputBufferSize = 64;
    t.Terminator = 13;
    t.BytesAvailableFcn = @ReadDataFromTCP;

    fopen(t);

end