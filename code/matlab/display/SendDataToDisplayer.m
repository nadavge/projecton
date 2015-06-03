function [  ] = SendDataToDisplayer( angle )

    global obj;
    global t;
    azimuth = obj.Orientation(1) - angle;
    lon = obj.Longitude;
    lat = obj.Latitude;
    
    fprintf(t, '%.7f %.7f %d\n', lat, lon, azimuth);

end

