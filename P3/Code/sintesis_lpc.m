function [ y ] = sintesis_lpc( a,G,T0 )

fs = 8000;
ts = 1/fs;
L = length(T0);
N = round(20e-3*fs); % Muestras por frame

if T0(1) == 0
    noise = randn(1,N)*G(1);
    [aux,zf] = filter(1,a(1,:),noise);
else
    deltas = zeros(1,N);
    deltas(1:T0(1)*fs:end) = G(1)/sqrt(T0(1));
    [aux,zf] = filter(1,a(1,:),deltas);
end   

Y(1,:) = aux;

for i = 2:L
    if T0(i) == 0
        noise = randn(1,N)*G(i);
        [aux,zf] = filter(1,a(i,:),noise,zf);
    else
        deltas = zeros(1,N);
        deltas(1:T0(i)*fs:end) = G(i)/sqrt(T0(i));
        [aux,zf] = filter(1,a(i,:),deltas,zf);
    end    
    
    Y(i,:) = aux;
end

    y = reshape(Y',N*L,1);
    
end

