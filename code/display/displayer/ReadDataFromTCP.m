function ReadDataFromTCP( conn, ~, soldier_index)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
	
	% TODO maybe change data send format to allow auto unbind
    [A, len] = fscanf( conn, '%f %f %d');
	lat = A(1);
	lon = A(2);
	azimuth = A(3);

    plot_on_map(lat, lon, azimuth, soldier_index, is_shot);

end

