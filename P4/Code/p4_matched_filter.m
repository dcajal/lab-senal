clear all;

fs = 4e6;
ts = 1/fs;
DF = 1e6;
Tp = 1e-3;

% Senal chirp
[s,~] = chirpenv(Tp,DF,fs);

x = zeros(10e-3*fs,1);
t = ts:ts:length(x)*ts;
n0 = 100e-6*fs;
x(n0+(0:length(s)-1)) = s;

mf = fliplr(conj(s));
y = conv(x,mf);
figure
plot(abs(y))

% Autocorrelacion del filtro

R = xcorr(mf);
figure
plot(real(R))


%% Filtro en presencia de ruido

clear all;

fs = 4e6;
ts = 1/fs;
DF = 1e6;
Tp = 1e-3;

% Senal chirp
[s,~] = chirpenv(Tp,DF,fs);

x = zeros(10e-3*fs,1);
n0 = 100e-6*fs;
x(n0+(0:length(s)-1)) = s;

mf = fliplr(conj(s));

% Sumamos ruido
Ps = sum(s.*conj(s))/length(s);
Pv = Ps/10;

vre = randn(1,length(x))*sqrt(Pv/2);
vim = randn(1,length(x))*sqrt(Pv/2);
v = vre + 1i*vim;

x = x + v';

y = conv(x,mf);
figure
subplot(211)
plot(real(x))
title('Entrada del filtro')
subplot(212)
plot(real(y))
title('Salida del filtro')

% El pico está desplazado la longitud del filtro adaptado!!!

%% Filtro en presencia de ruido. dos blancos.

clear all;

fs = 4e6;
ts = 1/fs;
DF = 1e6;
Tp = 1e-3;

% Senal chirp
[s,~] = chirpenv(Tp,DF,fs);

x = zeros(10e-3*fs,1);
n0 = 100e-6*fs;
n1 = n0 + 5e-6*fs;
x(n0+(0:length(s)-1)) = s;
x(n1+(0:length(s)-1)) = s;

mf = fliplr(conj(s));


% Sumamos ruido
Ps = sum(s.*conj(s))/length(s);
Pv = Ps/10;

vre = randn(1,length(x))*sqrt(Pv/2);
vim = randn(1,length(x))*sqrt(Pv/2);
v = vre + 1i*vim;

x = x + v';

y = conv(x,mf);
figure
subplot(211)
plot(real(x))
title('Entrada del filtro')
subplot(212)
plot(real(y))
title('Salida del filtro')

% No resuelve los dos blancos.


















