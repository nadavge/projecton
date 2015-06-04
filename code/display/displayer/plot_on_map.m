function plot_on_map(lat, lon, azimuth, soldier_index, is_shot)
% NEED FOR MenzaSat.PNG file to be in the same folder.

	global to_delete;
	soldiers_colors = ['r', 'b', 'g', 'yellow', 'm', 'c', 'w', 'k'];
	dAngle = 4*pi/180;  % half of the angle-range
	triangle_color = [is_shot 0 ~is_shot];
	
%   Because axis is from the top left corner
	angle = (-90 + azimuth)*pi/180;
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
	
	hold on;
	h1 = plot(x,y,'.', 'color', soldiers_colors(soldier_index) , 'markerSize', 20);
	x = [x, x + 100*cos(angle+dAngle),  x + 100*cos(angle-dAngle)];
	y = [y, y + 100*sin(angle+dAngle),  y + 100*sin(angle-dAngle)];
	h2 = fill(x,y,triangle_color,'EdgeColor','None');
	alpha(h2,0.5)

	to_delete{end+1} = h1;
	to_delete{end+1} = h2;
	
	t = timer;
	t.TimerFcn = @delete_shot;
	t.StartDelay = 5;
	
	start(t);
end
