function [X] = enventanado( x,Fs,N,M )

T = length(x);
m = 1:M:T-N;
L = length(m); % Numero de ventanas
ind = (0:N-1)' * ones(1,L) + ones(N,1) * m;
X = x(ind);

end
