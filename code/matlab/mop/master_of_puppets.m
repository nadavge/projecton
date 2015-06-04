function [direction] = master_of_puppets(sounds, fs)
% MASTER_OF_PUPPETS Find the location of a gunfire based on sound
%	sounds - a 4xBUFFERSIZE matrix of microphone recordings (each row is a mic)
%	fs - the sample frequency of the microphones
%	Using the sounds, use different sound analysis algorithms to receive
%	the direction of the gunfire
	global arc_length;
    close all;
    
    tdoa = [0 0 0 0];
    
	% Find the tdoa of each microphone relative to microphone no. 1
    for i = 2:4
        tdoa(i) = find_delay(sounds(i,:), sounds(1,:), fs);
    end
    
    is_shot = compare(sounds);
    % print the tdoa for debug:
    tdoa

    direction = Johnny(tdoa, arc_length);
    SendDataToDisplayer( direction, is_shot )
end
