function result = compare(noise)
load('refNoise.mat')
result = crosscor(ref,noise);
end

