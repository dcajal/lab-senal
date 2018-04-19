clear all

L = 10;
N = 10;
M = 50;

p = ones(1,N);
s = zeros(1,M*L);
n = 0:length(s)-1;

s(1:length(p)) = p;
for i = 1:L-1
    s(i*M + (0:(length(p)-1))) = p;
end

w1 = 2*pi/1000;
w2 = 2*pi/5;
f0 = 1e9;

% Velocidades [m/s]
v1 = -3e8*w1*180/pi/f0/2;
v2 = -3e8*w2*180/pi/f0/2;


% Desplazamiento Doppler
r1 = s.*exp(1i*w1*n);
r2 = s.*exp(1i*w2*n);

figure
subplot(211)
plot(n,real(r1))
title('Parte Real')
subplot(212)
plot(n,imag(r1))
title('Parte Imaginaria')

figure
subplot(211)
plot(n,real(r2))
title('Parte Real')
subplot(212)
plot(n,imag(r2))
title('Parte Imaginaria')


%% Calculo de la distancia y velocidad

clear all

f0 = 10e9;
Tp = 10e-6;
DF = 5e6;
fs = 6e6;
M = 80e-6;
L = 16;

% Ventana de recepcion
inicio = 20e-6;
fin = 70e-6;

% Resolucion en distancia [km]
res_d = 3e8*Tp/2/1000;

% Distancia minima y maxima detectable [km]
dmin = 3e8*inicio/2/1000;
dmax = 3e8*fin/2/1000;


% Cada columna de las 16 corresponde a un pulso.
load('radar.mat')


% Pulsos chirp
[s,~] = chirpenv(Tp,DF,fs);

% Filtro adaptado
mf = fliplr(conj(s));

y_mf = zeros(360,L);
for i = 1:L
    y_mf(:,i) = conv(y(:,i),mf);
end

y_diff = diff(y_mf,1,2);

y_mean = sum(abs(y_diff),2)/(L-1);

[peaks,locs] = findpeaks(abs(y_mean),1,'MinPeakHeight',20);
dlocs = locs - length(mf);

% Distancia de los blancos [km]
d = linspace(dmin,dmax,length(y_mean));
d(dlocs);


% Velocidad de los blancos
targets = zeros(length(locs),L-1);
for i = 1:length(locs)
    targets(i,:) = y_diff(locs(i),:);
end

spectre = abs(fftshift(fft(targets,1024,2)));
f = linspace(-0.5,0.5,length(spectre));

fd = zeros(1,length(locs));
for i = 1:length(locs)
    [~,fd(i)] = findpeaks(spectre(i,:),f,'SortStr','descend','NPeaks',1);
end
   
% La frecuencia de muestreo es ahora la inversa del periodo entre pulsos.
% Si el blanco se aleja, las frecuencias son negativas.
Fs = 1/M;
Fd = fd*Fs;


% Velocidades de los blancos [m/s]. Si el blanco se aleja la velocidad es
% positiva.
v = -3e8*Fd/f0/2;








