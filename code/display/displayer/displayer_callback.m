function displayer_callback( conn, ~, soldier_index)
%DISPLAYER_CALLBACK A callback for the displayer TCP socket
%	handles all data coming in through the different sockets
	
	% TODO maybe change data send format to allow auto unbind
	[A, len] = fscanf( conn, '%f %f %f %d' );
	lat = A(1);
	lon = A(2);
	azimuth = A(3);
	is_shot = A(4);

	plot_on_map(lat, lon, azimuth, soldier_index, is_shot);

end
