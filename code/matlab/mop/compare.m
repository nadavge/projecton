function result = compare(noise)
load('refNoise.mat')
global ref_noise2
result = crosscor(ref_noise2,noise);
end

