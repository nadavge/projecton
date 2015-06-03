function bindTCPsoldier( ip, port )

    global tc;
    global figure_handler
    
    if ~exist('port', 'var'),
       port = 30001; 
    end
    
    tc = tcpip(ip, port, 'NetworkRole', 'client');
        
    fopen(tc);
    
    if isempty(figure_handler)
        figure_handler = figure;
        hold on
        imshow('MenzaSat.PNG');
    end
    
end