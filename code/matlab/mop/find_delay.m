function [ dt ] = find_delay(data1, data2, fs)
    len = length(data1) - 1;
    t = (-len:len)/fs;
    corr = xcorr(data1,data2);
    [~, ind] = max(corr);
    dt=t(ind);
end

