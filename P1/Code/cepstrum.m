function [y] = cepstrum( x )

logx = log10(x);
ifftx = ifft(logx);
y = real(ifftx);

end
