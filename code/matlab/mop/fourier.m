function [ sig_ft freq] = fourier (sig,fs)
sig_ft=fftshift(fft(sig));
len=numel(sig_ft);
freq=(-len/2+1:len/2)*(fs/len);
plot(freq,abs(sig_ft))
end