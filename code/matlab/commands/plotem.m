function plotem(which)
% PLOTEM Plot the buffer by color
%	Plots buffers by colors: red, green, blue, black
	global buffer
	colors = 'rgbk';

    if ~exist('which', 'var'),
        which = 1:4;
    end
    
	figure
	hold on
	for i = which,
		plot(buffer(i,:), colors(i))
	end
end
