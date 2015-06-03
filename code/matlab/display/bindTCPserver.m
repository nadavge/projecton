function bindTCPserver( ip, port )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    global t;
    
    if ~exist('port', 'var'),
       port = 30001; 
    end

    t = tcpip(ip, port, 'NetworkRole', 'server');
    fopen(t);

end