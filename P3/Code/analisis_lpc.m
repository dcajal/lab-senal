function [ a,G,T0 ] = analisis_lpc( x )

T = length(x);
Fs = 8000;
ts = 1/Fs;
p = 10;  % Orden del predictor LPC

% Enventanamos

N = Fs*30e-3; % Ventana de 30ms
M = Fs*20e-3; % Solape de 10ms

m = 1:M:T-N;
L = length(m); % Numero de ventanas
ind = (0:N-1)' * ones(1,L) + ones(N,1) * m;
X = x(ind);

[a,e] = lpc(X,p);
G = sqrt(e);

T0 = zeros(1,length(a));

for i = 1:length(a)
    res = filter(a(i,:),1,X(:,i));
    re = xcorr(res,'biased');
    re_nor = re/max(re);
    tcorr = 0:ts:(ts*(length(re)-1));
    [~, index] = findpeaks(re_nor,tcorr,'SortStr','descend','MinPeakHeight',0.3);

    if length(index) < 2
        T0(i) = 0;
    else 
        T0(i) = abs(index(2)-index(1));
    end
end

T0 = T0';

end

