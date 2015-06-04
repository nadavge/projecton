function inform_displayer( soldier_index, angle, is_shot )

	global obj;
	global soldier_sockets;
	azimuth = obj.Orientation(1) - angle;
	lon = obj.Longitude;
	lat = obj.Latitude;
	
	if ~socket_initialized( soldier_sockets, soldier_index ),
		fprintf(2, ['Soldier ' num2str(soldier_index) ' socket is not initialized\n']);
		return;
	end
	
	fprintf(soldier_sockets{ soldier_index }, ['%.7f %.7f %d %d' 13], [lat, lon, azimuth, is_shot]);

end
