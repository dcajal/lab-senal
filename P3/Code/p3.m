%% Representacion de la senal de voz. Espectrograma

clear all;

[x,fs] = audioread('frase.wav');
N = length(x);
ts = 1/fs;
% t = linspace(1,N*ts,N);
% plot(t,s);

% figure
% subplot(121)
% spectrogram(x,hamming(40),20,1024,fs,'yaxis');
% axis xy
% subplot 122
% spectrogram(x,hamming(360),60,1024,fs,'yaxis');
% axis xy

%% Analisis y sintesis de fonemas aislados. Letra sonora

t1 = round(3.17/ts);
t2 = round(3.2/ts);
s = x(t1:t2); % Segmento correspondiente a una letra 'e'
% plot(3.17:ts:3.2,s);

% periodogram(s,[],[],fs)

% Obtenemos los coeficientes del predictor lineal y la potencia del residuo

p = 10;  % Orden del predictor LPC
[a,e] = lpc(s,p);
G = sqrt(e);
% figure
% freqz(1,a,[],fs)

r = roots(a);
r_an = angle(r);
r_freq = r_an/pi*fs/2; % Las frecuencias coinciden con las frecuencias de los picos

res = filter(a,1,s); % Si filtramos la senal con el filtro inverso tenemos un filtro blanqueador
RES = 20*log10(abs(fft(res)));
% plot(RES(1:ceil(end/2))) % Su espectro es aproximadamente plano

% Para obtener el pitch es mejor trabajar con la autocorrelacion del
% residuo que con la de la semal, puesto que tiene unos picos mas claros

% re = xcorr(res,'biased');
% rs = xcorr(s,'biased');
% re_nor = re/max(re);
% rs_nor = rs/max(rs);
% tcorr = 0:ts:(ts*(length(re)-1));
% 
% figure
% subplot(121)
% plot(tcorr,re_nor)
% subplot(122)
% plot(tcorr,rs_nor)
%[~, index] = findpeaks(re_nor,tcorr,'SortStr','descend','MinPeakHeight',0.3);

% Todo esto esta en la funcion pitch

T0 = pitch(s,0.3);

%% Fonemas sinteticos sonoros

clear t N;

deltas = zeros(1,fs);
deltas(1:T0*fs:end) = G/sqrt(T0);
t = 0:ts:(1-ts);
N = length(t);

sint = filter(1,a,deltas);
soundsc(sint)

%% Analisis y sintesis de fonemas aislados. Letra sorda.

clear t1 t2 s a e G

t1 = round(2.12/ts);
t2 = round(2.15/ts);
s = x(t1:t2);
% plot(2.12:ts:2.15,s);

% periodogram(s,[],[],fs)

% Obtenemos los coeficientes del predictor lineal y la potencia del residuo

p = 10;  % Orden del predictor LPC
[a,e] = lpc(s,p);
G = sqrt(e);
% figure
% freqz(1,a,[],fs)

r = roots(a);
r_an = angle(r);
r_freq = r_an/pi*fs/2; % Las frecuencias coinciden con las frecuencias de los picos

res = filter(a,1,s); % Si filtramos la senal con el filtro inverso tenemos un filtro blanqueador
RES = 20*log10(abs(fft(res)));
% plot(RES(1:ceil(end/2))) % Su espectro es aproximadamente plano

% Para obtener el pitch es mejor trabajar con la autocorrelacion del
% residuo que con la de la semal, puesto que tiene unos picos mas claros

% re = xcorr(res,'biased');
% rs = xcorr(s,'biased');
% re_nor = re/max(re);
% rs_nor = rs/max(rs);
% tcorr = 0:ts:(ts*(length(re)-1));

% figure
% subplot(121)
% plot(tcorr,re_nor)
% subplot(122)
% plot(tcorr,rs_nor)
%[~, index] = findpeaks(re_nor,tcorr,'SortStr','descend','MinPeakHeight',0.3);

% Todo esto esta en la funcion pitch

T0 = pitch(s,0.3);

%% Fonemas sinteticos sordos

clear t N;

noise = randn(1,fs)*G;
t = 0:ts:(1-ts);
N = length(t);

sint = filter(1,a,noise);
soundsc(sint)

