%% ECG

clear all

fs = 250;
ts = 1/fs;
load('ecg1.mat')

t = 0:ts:(length(ecg1)-1)*ts;
% figure
% subplot(311)
% plot(t,ecg1(:,1));
% ylabel('Amplitud (\muV)')
% xlabel('Tiempo (segundos)')
% grid on
% subplot(312)
% plot(t,ecg1(:,2));
% ylabel('Amplitud (\muV)')
% xlabel('Tiempo (segundos)')
% grid on
% subplot(313) 
% plot(t,ecg1(:,3));
% ylabel('Amplitud (\muV)')
% xlabel('Tiempo (segundos)')
% grid on

% Eliminacion de la linea de base (filtrado paso alto)

[b,a]=butter(4, 2*0.5/fs,'high');
freqz(b,a); %visualizamos la función de transferencia 

ecgh = filtfilt(b,a,ecg1); % senal sin linea de base

% figure
% subplot(311)
% plot(t,ecgh(:,1));
% ylabel('Amplitud (\muV)')
% xlabel('Tiempo (segundos)')
% grid on
% subplot(312)
% plot(t,ecgh(:,2));
% ylabel('Amplitud (\muV)')
% xlabel('Tiempo (segundos)')
% grid on
% subplot(313) 
% plot(t,ecgh(:,3));
% ylabel('Amplitud (\muV)')
% xlabel('Tiempo (segundos)')
% grid on


%% Detector QRS 

% 1) Filtrado lineal: diferenciador + FIR paso bajo
ecgh_diff = diff(ecgh);
Fc = 40;
h = fir1(50,2*Fc/fs,'low');
ecghdl_ret = filter(h,1,ecgh_diff);
ecghdl = zeros(length(ecghdl_ret)-floor(length(h)/2)+1,3);

% Eliminamos el retardo introducido por el filtro
for i = 1:3
    ecghdl(:,i) = ecghdl_ret(floor(length(h)/2):end,i);
end

t = 0:ts:(length(ecghdl)-1)*ts;
% figure
% ax1 = subplot(311);
% plot(t,ecghdl(:,1));
% xlabel('Tiempo (segundos)')
% grid on
% ax2 = subplot(312);
% plot(t,ecghdl(:,2));
% xlabel('Tiempo (segundos)')
% grid on
% ax3 = subplot(313); 
% plot(t,ecghdl(:,3));
% xlabel('Tiempo (segundos)')
% grid on
% linkaxes([ax1,ax2,ax3],'xy')

% 2) Transformacion no lineal
w = hamming(0.1*fs);
eecg = ecghdl.^2;
ecgdet_ret = filter(w,1,eecg);
ecgdet = zeros(length(ecgdet_ret)-floor(length(w)/2)+1,3);

% Eliminamos el retardo introducido por el filtro
for i = 1:3
    ecgdet(:,i) = ecgdet_ret(floor(length(w)/2):end,i);
end

t = 0:ts:(length(ecgdet)-1)*ts;
% figure
% ax1 = subplot(311);
% plot(t,ecgdet(:,1));
% xlabel('Tiempo (segundos)')
% grid on
% ax2 = subplot(312);
% plot(t,ecgdet(:,2));
% xlabel('Tiempo (segundos)')
% grid on
% ax3 = subplot(313); 
% plot(t,ecgdet(:,3));
% xlabel('Tiempo (segundos)')
% grid on
% linkaxes([ax1,ax2,ax3],'xy')

% 3) Decision
th1 = 1.5e5;
th2 = 0.4e5;
th3 = 3.5e5;

[peaks1,qrslocs1] = findpeaks(ecgdet(:,1),'MinPeakHeight',th1);
[peaks2,qrslocs2] = findpeaks(ecgdet(:,2),'MinPeakHeight',th2);
[peaks3,qrslocs3] = findpeaks(ecgdet(:,3),'MinPeakHeight',th3);


figure
subplot(311);
rrseries1=diff(qrslocs1)/fs; 
qrstimes1 = qrslocs1/fs;
plot(qrstimes1(1:end-1),rrseries1);
xlabel('tiempo (s)')
ylabel('intervalo RR (s)') 
grid on
subplot(312);
rrseries2=diff(qrslocs2)/fs; 
qrstimes2 = qrslocs2/fs;
plot(qrstimes2(1:end-1),rrseries2);
xlabel('tiempo (s)')
ylabel('intervalo RR (s)') 
grid on
subplot(313); 
rrseries3=diff(qrslocs3)/fs; 
qrstimes3 = qrslocs3/fs;
plot(qrstimes3(1:end-1),rrseries3);
xlabel('tiempo (s)')
ylabel('intervalo RR (s)') 
grid on

figure
subplot(311);
plot(qrstimes1,peaks1);
xlabel('tiempo (s)')
ylabel('Amplitud de los picos') 
grid on
subplot(312);
plot(qrstimes2,peaks2);
xlabel('tiempo (s)')
ylabel('Amplitud de los picos') 
grid on
subplot(313); 
plot(qrstimes3,peaks3);
xlabel('tiempo (s)')
ylabel('Amplitud de los picos') 
grid on


load('qrsref.mat')


