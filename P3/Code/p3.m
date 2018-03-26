T0 = 10;
n = 1:100;
t = zeros(1,length(n));

for i = 1:length(n)
    if mod(i,T0) == 0
        t(i) = 1;
    end
end
x=t;

r = xcorr(t);
stem(r)

%% prueba del pitch

clear all;

fs = 8000;
ts = 1/fs;

x = ts:ts:500*ts;
x = cos(100*2*pi*x);

%% Representacion de la senal de voz

clear all;

[x,fs] = audioread('frase.wav');
N = length(x);
ts = 1/fs;
t = linspace(1,N*ts,N);
% plot(t,s);

% figure
% subplot(121)
% spectrogram(x,hamming(40),20,1024,fs,'yaxis');
% axis xy
% subplot 122
% spectrogram(x,hamming(360),60,1024,fs,'yaxis');
% axis xy

%% Analisis y sintesis de fonemas aislados

t1 = round(3.17/ts);
t2 = round(3.2/ts);
s = x(t1:t2);
% plot(3.17:ts:3.2,s);

% periodogram(s,[],[],fs)

p = 10;  % Orden del predictor LPC
[a,e] = lpc(s,p);
% figure
% freqz(1,a,[],fs)

r = roots(a);
r_an = angle(r);
r_freq = r_an/pi*fs/2; % Las frecuencias coinciden con las frecuencias de los picos

res = filter(a,1,s); % Si filtramos la senal con el filtro inverso tenemos un filtro blanqueador
RES = 20*log10(abs(fft(res)));
% plot(RES(1:ceil(end/2))) % Su espectro es aproximadamente plano

re = xcorr(res);
rs = xcorr(s);
re_nor = re/max(re);
rs_nor = rs/max(rs);
tcorr = 0:ts:(ts*(length(re)-1));

% figure
% subplot(121)
% plot(tcorr,re_nor)
% subplot(122)
% plot(tcorr,rs_nor)

[~, index] = findpeaks(re_nor,tcorr,'SortStr','descend','MinPeakHeight',0.3)


s=randn(1,100)
pitch(s,0.3)

