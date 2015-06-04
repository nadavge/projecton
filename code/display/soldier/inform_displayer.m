function inform_displayer( angle, is_shot )

	global obj;
	global t;
	azimuth = obj.Orientation(1) - angle;
	lon = obj.Longitude;
	lat = obj.Latitude;
	
	fprintf(t, ['%.7f %.7f %d %d' 13], [lat, lon, azimuth, is_shot]);

end
