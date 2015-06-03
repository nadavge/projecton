function [  ] = plot_on_map(lat, lon, azimuth)
% NEED FOR MenzaSat.PNG file to be in the same folder.

    dAngle = pi/32;
    plot_color = 'r';
    
    close all;
%   Because axis is from the top left corner
    angle = -azimuth*pi/180;
    sat = imread('MenzaSat.PNG');
    
    lats = [31.767400, lat, 31.771400];
    lons = [35.195500, lon, 35.201050];
    map_size = size(sat(:,:,1));
    
    lats = lats - lats(1);
    lons = lons - lons(1);
    
    lats = lats/lats(3)*map_size(1);
    lons = lons/lons(3)*map_size(2);
    
%   Because axis is from the top left corner
    x = lons(2);
    y = lats(3) - lats(2);
    
    imshow('MenzaSat.PNG')
    hold on
    
    plot(x,y,'.', 'color', plot_color , 'markerSize', 20);
    x = [x, x + 100*cos(angle+dAngle),  x + 100*cos(angle-dAngle)];
    y = [y, y + 100*sin(angle+dAngle),  y + 100*sin(angle-dAngle)];
    h2 = fill(x,y,plot_color,'EdgeColor','None');
    alpha(h2,0.5)
    pause(5)
    alpha(h2,0)
    pause(0.5)
    imshow('MenzaSat.PNG')
    
end

