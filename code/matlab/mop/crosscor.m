function result = crosscor(ref,sound)
threshold = 1350;
result = false;
% TODO set real old_fs value from trial
old_fs = 35000;
global fs;

ref = freq_trans(ref, old_fs,fs);
ref = ref/max(abs(ref));
sound = sound/max(abs(sound));

cross = max(real(xcorr(ref,sound)));
if cross > threshold
    result = true;
end
end