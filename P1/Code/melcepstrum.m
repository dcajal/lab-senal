function [y] = melcepstrum( x , fb)

[M,N] = size(x);
x = x(1:M/2,:);
absx = abs(x);
mel = fb'*absx;
y = log10(mel);

end
