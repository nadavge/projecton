function [isShot, dt] = find_delay(data1, data2, fs)
    isShot = compare(data1);
%     if ~isShot
%         dt = 0;
%         return
%     end
    len = length(data1) - 1;
    t = (-len:len)/fs;
    corr = xcorr(data1,data2);
    [~, ind] = max(corr);
    dt=t(ind);
end

