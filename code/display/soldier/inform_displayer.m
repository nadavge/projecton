function [  ] = inform_displayer( angle )

    global obj;
    global t;
    azimuth = obj.Orientation(1) - angle;
    lon = obj.Longitude;
    lat = obj.Latitude;
    
    fprintf(t, ['%.7f;%.7f;%d\n' 13], [lat, lon, azimuth]);

end

