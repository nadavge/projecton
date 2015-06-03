function ReadDataFromTCP( t )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    [lat, lon, azimuth] = fscanf(t, '%.7f %.7f %d\n',25);
    plot_on_map(lat, lon, azimuth);


end

