%% Conformado de haz. Generacion de senales. Multiples interferentes

clear all;

fs = 2000;
t = 1:1/fs:10;
N = length(t);
SNR = 40;
kd = pi;
M = 8;

% Senal deseada e interferentes
Ad = cos(2*pi*100.*t);
Ai1 = cos(2*pi*50.*t);
Ai2 = cos(2*pi*60.*t);
Ai3 = cos(2*pi*70.*t);
Ai4 = cos(2*pi*80.*t);

potA = sum(abs(Ad).^2)/(N);

% Generamos ruido incorrelado entre sensores
potv = potA/(10^(SNR/20));
vr = randn(M,N)*sqrt(potv);
vi = 1i*randn(M,N)*sqrt(potv);
v = vr + vi;

%% Conformador phased array independiente de los datos

D = zeros(M,181);
theta = -90:90;
j = 1;
for k = -90:90
    D(:,j) = generate_d(kd,M,k);
    j = j + 1;
end

% Direccion deseada
D25 = generate_d(kd,M,25);
w = D25; % Pesos del conformador

% Direcciones interferentes
D_30 = generate_d(kd,M,-30); 
D0 = generate_d(kd,M,0);
D20 = generate_d(kd,M,20);
D45 = generate_d(kd,M,45);

figure
F_ind = (w'*D)/M;
% polarplot(theta*pi/180,abs(F_ind)) % Factor de array
plot(theta,abs(F_ind))

% Senal deseada
xd = Ad.*D25; 

% Senales interferentes
xi1 = Ai1.*D_30;
xi2 = Ai2.*D0;
xi3 = Ai3.*D20;
xi4 = Ai4.*D45;

x = xd + xi1 + xi2 + xi3 + xi4 + v;
y = w'*x;

% Calculo de la relacion senal a interferente

% figure
% plot(abs(fftshift(fft(y)))) % Vemos que la interferente esta atenuada
Y = abs(fft(y));
peak = findpeaks(Y(1:ceil(end/2)),'SortStr','descend','NPeaks',2);
SI = 20*log10(max(peak)/min(peak)); % Relacion senal a interferente
fprintf('SIR independiente: %.2f dB\n', SI);

%% Referencia temporal

clear w y p Y SI peak;

R = (x*x')/N;
p = (x*Ad')/N;
w = R\p;

hold on
F_temp = w'*D;
% polarplot(theta*pi/180,abs(F_temp)) % Factor de array
plot(theta,abs(F_temp))

y = w'*x;

% Calculo de la relacion senal a interferente

% figure
% plot(abs(fftshift(fft(y)))) % Vemos que la interferente desaparece
Y = abs(fft(y));
peak = findpeaks(Y(1:ceil(end/2)),'SortStr','descend','NPeaks',2);
SI = 20*log10(max(peak)/min(peak)); % Relacion senal a interferente
fprintf('SIR temporal: %.2f dB\n', SI);


%% Referencia espacial

clear w y p Y SI peak;

num = R\D45;
den = D45'*num;
w = num/den;

hold on
F_esp = w'*D;
% polarplot(theta*pi/180,abs(F_esp)) % Factor de array
plot(theta,abs(F_esp))
legend('FA ind', 'FA tmp', 'FA esp')


y = w'*x;

% Calculo de la relacion senal a interferente

% figure
% plot(abs(fftshift(fft(y)))) % Vemos que la interferente desaparece
Y = abs(fft(y));
peak = findpeaks(Y(1:ceil(end/2)),'SortStr','descend','NPeaks',2);
SI = 20*log10(max(peak)/min(peak)); % Relacion senal a interferente
fprintf('SIR espacial: %.2f dB\n', SI);










