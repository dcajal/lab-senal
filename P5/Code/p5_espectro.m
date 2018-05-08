clear all
close all

Fs = 1000;
ts = 1/Fs;
load('ecg2.mat')
[ecgh1, qrspos1] = qrsdetect(ecgs1, Fs);
[ecgh2, qrspos2] = qrsdetect(ecgs2, Fs); 
[ecgh3, qrspos3] = qrsdetect(ecgs3, Fs); 
[ecgh4, qrspos4] = qrsdetect(ecgs4, Fs); 

% ECG en tiempo (limpio)

% figure
% subplot(411)
% t1 = 0:ts:(length(ecgh1)-1)*ts;
% plot(t1,ecgh1)
% xlabel('Tiempo (s)')
% grid on
% subplot(412)
% t2 = 0:ts:(length(ecgh2)-1)*ts;
% plot(t2,ecgh2)
% xlabel('Tiempo (s)')
% grid on
% subplot(413)
% t3 = 0:ts:(length(ecgh3)-1)*ts;
% plot(t3,ecgh3)
% xlabel('Tiempo (s)')
% grid on
% subplot(414)
% t4 = 0:ts:(length(ecgh4)-1)*ts;
% plot(t4,ecgh4)
% xlabel('Tiempo (s)')
% grid on

% Intervalos RR
rrseries1=diff(qrspos1)/Fs; 
rrseries2=diff(qrspos2)/Fs; 
rrseries3=diff(qrspos3)/Fs; 
rrseries4=diff(qrspos4)/Fs; 

qrstimes1 = qrspos1(1:end-1)/Fs;
qrstimes2 = qrspos2(1:end-1)/Fs;
qrstimes3 = qrspos3(1:end-1)/Fs;
qrstimes4 = qrspos4(1:end-1)/Fs;

% figure
% subplot(411);
% qrstimes1 = qrspos1/Fs;
% plot(qrstimes1(1:end-1),rrseries1);
% xlabel('tiempo (s)')
% ylabel('intervalo RR (s)') 
% grid on
% subplot(412);
% plot(qrstimes2(1:end-1),rrseries2);
% xlabel('tiempo (s)')
% ylabel('intervalo RR (s)') 
% grid on
% subplot(413); 
% plot(qrstimes3(1:end-1),rrseries3);
% xlabel('tiempo (s)')
% ylabel('intervalo RR (s)') 
% grid on
% subplot(414); 
% plot(qrstimes4(1:end-1),rrseries4);
% xlabel('tiempo (s)')
% ylabel('intervalo RR (s)') 
% grid on

% Interpolacion intervalo RR

Fs = 4;
ts= 1/Fs;
t1 = 0:0.25:ceil(qrstimes1(end));
t2 = 0:0.25:ceil(qrstimes2(end)); 
t3 = 0:0.25:ceil(qrstimes3(end)); 
t4 = 0:0.25:ceil(qrstimes4(end)); 

rrseries1_inter = interp1(qrstimes1,rrseries1,t1,'spline','extrap');
rrseries2_inter = interp1(qrstimes2,rrseries2,t2,'spline','extrap');
rrseries3_inter = interp1(qrstimes3,rrseries3,t3,'spline','extrap');
rrseries4_inter = interp1(qrstimes4,rrseries4,t4,'spline','extrap');

[b,a]=butter(4, 2*0.025/4,'high');
rri1h = filtfilt(b,a,rrseries1_inter);
rri2h = filtfilt(b,a,rrseries2_inter);
rri3h = filtfilt(b,a,rrseries3_inter);
rri4h = filtfilt(b,a,rrseries4_inter);


% FFT

% NFFT = 2^16;
% figure
% subplot(411)
% RR1 = fft(rri1h,NFFT);
% f1 = linspace(-0.5,0.5,length(RR1));
% F1 = f1*Fs;
% plot(F1,fftshift(abs(RR1)))
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% subplot(412)
% RR2 = fft(rri2h,NFFT);
% f2 = linspace(-0.5,0.5,length(RR2));
% F2 = f2*Fs;
% plot(F2,fftshift(abs(RR2)))
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% subplot(413)
% RR3 = fft(rri3h,NFFT);
% f3 = linspace(-0.5,0.5,length(RR3));
% F3 = f3*Fs;
% plot(F3,fftshift(abs(RR3)))
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% subplot(414)
% RR4 = fft(rri4h,NFFT);
% f4 = linspace(-0.5,0.5,length(RR4));
% F4 = f4*Fs;
% plot(F4,fftshift(abs(RR4)))
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on


% Pwelch

% WINDOW = 300;
% NOVERLAP = 200;
% NFFT = 2^16;
% 
% figure
% ax1 = subplot(411);
% [RR1,F1] = pwelch(rri1h,WINDOW,NOVERLAP,NFFT,Fs,'centered');
% plot(F1,RR1)
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% ax2 = subplot(412);
% [RR2,F2] = pwelch(rri2h,WINDOW,NOVERLAP,NFFT,Fs,'centered');
% plot(F2,RR2)
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% ax3 = subplot(413);
% [RR3,F3] = pwelch(rri3h,WINDOW,NOVERLAP,NFFT,Fs,'centered');
% plot(F3,RR3)
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% ax4 = subplot(414);
% [RR4,F4] = pwelch(rri4h,WINDOW,NOVERLAP,NFFT,Fs,'centered');
% plot(F4,RR4)
% xlim([0 1])
% xlabel('Frecuencia (Hz)')
% grid on
% linkaxes([ax1,ax2,ax3,ax4],'x')


% Aryule

A1 = aryule(rri1h,16);
[H1,W1] = freqz(1,A1);
A2 = aryule(rri2h,16);
[H2,W2] = freqz(1,A2);
A3 = aryule(rri3h,16);
[H3,W3] = freqz(1,A3);
A4 = aryule(rri4h,16);
[H4,W4] = freqz(1,A4);

figure
subplot(411)
plot(W1/2/pi*Fs,abs(H1))
xlabel('Frecuencia (Hz)')
grid on
subplot(412)
plot(W1/2/pi*Fs,abs(H2))
xlabel('Frecuencia (Hz)')
grid on
subplot(413)
plot(W3/2/pi*Fs,abs(H3))
xlabel('Frecuencia (Hz)')
grid on
subplot(414)
plot(W4/2/pi*Fs,abs(H4))
xlabel('Frecuencia (Hz)')
grid on



