function ReadDataFromTCP(t, event)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    [A, len] = fscanf(t, '%f %f %d');
	lat = A(1);
	lon = A(2);
	azimuth = A(3);

    plot_on_map(lat, lon, azimuth);

end

