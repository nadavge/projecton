function result = compare(noise)
load('refNoise.mat')
result = crosscor(ref_sound2,noise);
end

