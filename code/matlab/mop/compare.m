function result = compare(buffer)
threshold = 950;
load('refNoise.mat')

mic_com = zeros(1,4);
det_mic = 0;
for k = 1:4
    mic_com(k) = crosscor(ref,buffer(k,:));
    if mic_com(k) > threshold
        det_mic = det_mic + 1;
    end
end
mic_mean = mean(mic_com) > threshold;
mic_tot = det_mic >= 2;
result = mic_tot && mic_mean;
end

