function unbindTCP( )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('t', 'var'),
        fclose(t); 
    end

    if ~exist('ts', 'var'),
        fclose(ts); 
    end

    if ~exist('tc', 'var'),
        fclose(tc); 
    end


end

