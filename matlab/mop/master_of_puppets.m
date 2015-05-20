function [direction] = master_of_puppets(sounds, fs)
    close all;

    arcLength = 4;
%     fs = 44100;
    tdoa = [0 0 0 0];
    
    snd1 = sounds(1,:);
    snd2 = sounds(2,:);
    snd3 = sounds(3,:);
    snd4 = sounds(4,:);

    [isShot, tdoa(2)] = find_delay(snd2,snd1, fs);
    if (isShot == 0)
        direction = -1000;
        return
    end
    [isShot, tdoa(3)] = find_delay(snd3,snd1, fs);
    if (isShot == 0)
        direction = -1000;
        return
    end
    [isShot, tdoa(4)] = find_delay(snd4,snd1, fs);
    if (isShot == 0)
        direction = -1000;
        return
    end

%     % print the tdoa for debug:
    tdoa

    direction = Johnny(tdoa, arcLength);
end