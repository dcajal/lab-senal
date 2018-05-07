%% Promediador

clear all
close all

fs = 1000;
load('ecgdet1.mat');
realizaciones = 500;
[ecg_noisy,~] = gensr(ecgdet1,10,realizaciones,0,0);

ecg_noise_mean = mean(ecg_noisy,2);
SNR = -10*log10(mean((ecgdet1-ecg_noise_mean).^2)); % SNR despues del promediador

%% Desalineamiento

clear all
close all

fs = 100;
load('ecgdet2.mat');
realizaciones = 500;
[ecg_desp,~] = gensr(ecgdet2,1,realizaciones,0,0);

ecg_desp_mean = mean(ecg_desp,2);
plot(ecg_desp_mean);

%% Promediador como filtro lineal

clear all
close all

fs = 1000;
ts = 1/fs;
load('ecgdet1.mat');
realizaciones = 500;
[ecg_noisy,~] = gensr(ecgdet1,10,realizaciones,0,0);
ecgdet = ecg_noisy(:);

% figure
% subplot(311)
% t = 0:ts:(length(ecgdet)-1)*ts;
% plot(t,ecgdet);
% xlabel('Tiempo (s)')
% ylabel('Amplitud')
% grid on
% subplot(312)
% ECGDET = fft(ecgdet);
% f = linspace(-0.5,0.5,length(ECGDET));
% F = f*fs;
% plot(F,fftshift(abs(ECGDET)));
% xlabel('Frecuencia (Hz)')
% ylabel('Modulo fft')
% grid on
% subplot(313)
% plot(F,fftshift(angle(ECGDET)));
% xlabel('Frecuencia (Hz)')
% ylabel('Fase fft')
% grid on

h = zeros(50*200,1);
for i = 1:200:length(h)
    h(i) = 1/length(h);
end

%ecg_filt = conv(h,ecgdet,'same');
ecg_filt = filter(h,1,ecgdet);

figure
subplot(311)
t = 0:ts:(length(ecg_filt)-1)*ts;
plot(t,ecg_filt)
xlabel('Tiempo (s)')
ylabel('Amplitud')
grid on
subplot(312)
ECGFILT = fft(ecg_filt);
f = linspace(-0.5,0.5,length(ECGFILT));
F = f*fs;
plot(F,fftshift(abs(ECGFILT)));
xlabel('Frecuencia (Hz)')
ylabel('Modulo fft')
grid on
subplot(313)
plot(F,fftshift(angle(ECGFILT)));
xlabel('Frecuencia (Hz)')
ylabel('Fase fft')
grid on

%% Estimacion adaptativa

clear all
close all

fs = 1000;
ts = 1/fs;
load('ecgdet1.mat');
L = length(ecgdet1);
realizaciones = 500;
[ecg_noisy,~] = gensr(ecgdet1,10,realizaciones,0,0);
ecgdet = ecg_noisy(:);

z = zeros(length(ecgdet),1);
for i = 1:L:length(z)
    z(i) = 1;
end

mu = 0.2;
[ecg_filtadap,~] = filtadapt(z,ecgdet,mu,L);

e2 = (ecgdet-ecg_filtadap).^2;
J = filter(1/L*ones(1,L),1,e2);

figure
subplot(211)
%t = 0:ts:(length(ecgdet)-1)*ts;
plot(ecg_filtadap);
%xlabel('Tiempo (s)')
ylabel('Amplitud')
grid on
subplot(212)
plot(J)
%xlabel('Tiempo (s)')
ylabel('J')
grid on

SNR = -10*log10(mean((ecg_filtadap(end-L+1:end)-ecgdet(end-L+1:end)).^2));

%% Estimacion adaptativa. Cambio brusco en la senal

clear all
close all

fs = 1000;
ts = 1/fs;
load('ecgdet1.mat');
load('ecgdet2.mat');
L = length(ecgdet1);
realizaciones = 100;
[ecg_noisy1,~] = gensr(ecgdet1,10,realizaciones,0,0);
[ecg_noisy2,~] = gensr(ecgdet2,10,realizaciones,0,0);
ecgdet1 = ecg_noisy1(:);
ecgdet2 = ecg_noisy2(:);
ecgdet = [ecgdet1; ecgdet2];

z = zeros(length(ecgdet),1);
for i = 1:L:length(z)
    z(i) = 1;
end

mu = 0.2;
[ecg_filtadap,h] = filtadapt(z,ecgdet,mu,L);

e2 = (ecgdet-ecg_filtadap).^2;
J = filter(1/L*ones(1,L),1,e2);

% figure
% subplot(211)
% % t = 0:ts:(length(ecgdet)-1)*ts;
% plot(ecg_filtadap);
% %xlabel('Tiempo (s)')
% ylabel('Amplitud')
% grid on
% subplot(212)
% plot(J)
% %xlabel('Tiempo (s)')
% ylabel('J')
% grid on

SNR = -10*log10(mean((ecg_filtadap(end-L+1:end)-ecgdet(end-L+1:end)).^2));

% figure
% hold on
% for i = 1:10
%     plot(h(i,:))
% end






