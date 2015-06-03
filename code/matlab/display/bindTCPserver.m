function bindTCPserver( ip, port )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    global ts;
    
	if ~exist('ip', 'var'),
       port = '0.0.0.0'; 
    end
	
    if ~exist('port', 'var'),
       port = 30001; 
    end

    ts = tcpip(ip, port, 'NetworkRole', 'server');
    
    ts.InputBufferSize = 64;
    ts.Terminator = 13;
    ts.BytesAvailableFcn = @ReadDataFromTCP;

    fopen(ts);

end