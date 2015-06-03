function result = crosscor(ref,sound)

old_fs = 37500;
global fs;

ref = freq_trans(ref, old_fs,fs);
ref = ref/max(abs(ref));
sound = sound/max(abs(sound));

result = max(real(xcorr(ref,sound)));
end