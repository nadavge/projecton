function [isShot dt] = find_delay(data1,data2, fs)
%     fs = 44100;
    trash_hold = 100;
    len = length(data1) - 1;
    t = (-len:len)/fs;
    clean1=mop_filter(data1);
%     plot(clean1)
    clean2=mop_filter(data2);
%     hold on
%     plot(clean2,'r')
%     figure
    isShot = length(find(clean1 > trash_hold)) & ...
        length(find(clean2 > trash_hold));
    if (isShot == 0)
        dt = 0;
        return
    end
    correlation=xcorr(clean1,clean2);
%     correlation=xcorr(data1,data2);
    
    % plot for checking:
%     plot(t,correlation);
%     figure;

    [~, ind] = max(correlation);
    dt=t(ind);
end

