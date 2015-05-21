function [direction] = master_of_puppets(sounds, fs)
    close all;
    
    arcLength = 4;
    tdoa = [0 0 0 0];
    
    for i = 2:4
        [isShot, tdoa(i)] = find_delay(sounds(i,:),sounds(1,:), fs);
%         if (~isShot)
%             direction = -1000;
%             return
%         end
    end
    
    % print the tdoa for debug:
    tdoa

    direction = Johnny(tdoa, arcLength);
end