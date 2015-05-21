function plotem
% PLOTEM Plot the buffer by color
%	Plots buffers by colors: red, green, blue, black
	global buffer
	colors = 'rgbk'

	figure
	hold on
	for i = 1:4,
		plot(buffer(i,:), colors(i))
	end
end
