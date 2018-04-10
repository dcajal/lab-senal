%% Estudio de la senal chirp

clear all;

fs = 4e6;
DF = 1e6;
Tp = 20e-6;

% Senal chirp
[x,t] = chirpenv(Tp,DF,fs);

figure
subplot(211)
plot(t,real(x))
title('Senal chirp')
hold on
plot(t,imag(x))
legend('Parte real','Parte imaginaria')
subplot(212)
plot(t,abs(x))
hold on
plot(t,unwrap(angle(x)))
legend('Modulo','Fase')

% Senal monofrecuencia
[xmono,tmono] = chirpenv(Tp,0,fs);

figure
subplot(211)
plot(tmono,real(xmono))
title('Senal mono')
hold on
plot(tmono,imag(xmono))
legend('Parte real','Parte imaginaria')
subplot(212)
plot(tmono,abs(xmono))
hold on
plot(tmono,unwrap(angle(xmono)))
legend('Modulo','Fase')


% Frecuencia instantanea senal chirp

Fi = diff(unwrap(angle(x)))*fs/(2*pi);
figure
plot(t(1:end-1),Fi)
title('Frecuencia instantanea senal chirp')
exc = max(Fi)-min(Fi); % Excursion frecuencial
fprintf('Excursion frecuencial: %i\n',exc)

% Transformada de Fourier de las senales

X = fft(x,512);
XMONO = fft(xmono,512);
f = linspace(-0.5,0.5,length(X));
F = f*fs;

figure
subplot(211)
plot(F, fftshift(10*log10(abs(X))))
title('TF de la senal chirp')
ylabel('dB')
xlabel('Frecuencia')
subplot(212)
plot(F, fftshift(10*log10(abs(XMONO))))
title('TF de la senal mono')
ylabel('dB')
xlabel('Frecuencia')


%% Estudio de parametros de la senal chirp. Barrido frecuencial

clear all;

fs = 4e6;
DF1 = 1e6;
DF2 = 0.5e6;
DF3 = 2e6;
Tp = 20e-6;


% Senales chirp
[x1,t1] = chirpenv(Tp,DF1,fs);
[x2,t2] = chirpenv(Tp,DF2,fs);
[x3,t3] = chirpenv(Tp,DF3,fs);


% Transformada de Fourier de las senales

X1 = fft(x1,512);
X2 = fft(x2,512);
X3 = fft(x3,512);
f = linspace(-0.5,0.5,length(X1));
F = f*fs;

figure
plot(F, fftshift(10*log10(abs(X1))))
hold on
plot(F, fftshift(10*log10(abs(X2))))
plot(F, fftshift(10*log10(abs(X3))))
legend('1MHz','0.5MHz','2MHz')
ylabel('dB')
xlabel('Frecuencia')


% Autocorrelacion de las senales

R_x1 = xcorr(x1);
R_x2 = xcorr(x2);
R_x3 = xcorr(x3);

t1_corr = linspace(2*t1(2),2*t1(end),length(R_x1))*1e6;
t2_corr = linspace(2*t2(2),2*t2(end),length(R_x2))*1e6;
t3_corr = linspace(2*t3(2),2*t3(end),length(R_x3))*1e6;

figure
subplot(311)
plot(t1_corr,real(R_x1))
title('1MHz')
xlabel('\mus')
subplot(312)
plot(t2_corr,real(R_x2))
title('0.5MHz')
xlabel('\mus')
subplot(313)
plot(t3_corr,real(R_x3))
title('2MHz')
xlabel('\mus')




%% Estudio de parametros de la senal chirp. Duracion del pulso.

clear all;

fs = 4e6;
DF = 1e6;
Tp1 = 20e-6;
Tp2 = 100e-6;
Tp3 = 512e-6;

% Senales chirp
[x1,t1] = chirpenv(Tp1,DF,fs);
[x2,t2] = chirpenv(Tp2,DF,fs);
[x3,t3] = chirpenv(Tp3,DF,fs);


% Transformada de Fourier de las senales

X1 = fft(x1,2048);
X2 = fft(x2,2048);
X3 = fft(x3,2048);
f = linspace(-0.5,0.5,length(X1));
F = f*fs;

figure
plot(F, fftshift(10*log10(abs(X1))))
hold on
plot(F, fftshift(10*log10(abs(X2))))
plot(F, fftshift(10*log10(abs(X3))))
legend('20us','100us','512us')
ylabel('dB')
xlabel('Frecuencia')


% Autocorrelacion de las senales

R_x1 = xcorr(x1);
R_x2 = xcorr(x2);
R_x3 = xcorr(x3);

t1_corr = linspace(2*t1(2),2*t1(end),length(R_x1))*1e6;
t2_corr = linspace(2*t2(2),2*t2(end),length(R_x2))*1e6;
t3_corr = linspace(2*t3(2),2*t3(end),length(R_x3))*1e6;

figure
subplot(311)
plot(t1_corr,real(R_x1))
title('20us')
xlabel('\mus')
xlim([-20,20])
subplot(312)
plot(t2_corr,real(R_x2))
title('100us')
xlabel('\mus')
xlim([-20,20])
subplot(313)
plot(t3_corr,real(R_x3))
title('512us')
xlabel('\mus')
xlim([-20,20])




%% Estudio de parametros de la senal monofrecuencia. Duracion del pulso.

clear var;

fs = 4e6;
DF = 0; % Monofrecuencia
Tp1 = 20e-6;
Tp2 = 100e-6;
Tp3 = 512e-6;

% Senales mono
[x1,t1] = chirpenv(Tp1,DF,fs);
[x2,t2] = chirpenv(Tp2,DF,fs);
[x3,t3] = chirpenv(Tp3,DF,fs);


% Transformada de Fourier de las senales

X1 = fft(x1,8182);
X2 = fft(x2,8182);
X3 = fft(x3,8182);
f = linspace(-0.5,0.5,length(X1));
F = f*fs;

figure
plot(F, fftshift(10*log10(abs(X1))))
hold on
plot(F, fftshift(10*log10(abs(X2))))
plot(F, fftshift(10*log10(abs(X3))))
legend('20us','100us','512us')
ylabel('dB')
xlabel('Frecuencia')


% Autocorrelacion de las senales

R_x1 = xcorr(x1);
R_x2 = xcorr(x2);
R_x3 = xcorr(x3);

t1_corr = linspace(2*t1(2),2*t1(end),length(R_x1))*1e6;
t2_corr = linspace(2*t2(2),2*t2(end),length(R_x2))*1e6;
t3_corr = linspace(2*t3(2),2*t3(end),length(R_x3))*1e6;

figure
subplot(311)
plot(t1_corr,real(R_x1))
title('20us')
xlabel('\mus')
subplot(312)
plot(t2_corr,real(R_x2))
title('100us')
xlabel('\mus')
subplot(313)
plot(t3_corr,real(R_x3))
title('512us')
xlabel('\mus')












