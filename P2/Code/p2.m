%% Conformado de haz. Generacion de senales

clear all;
close all;

fs = 2000;
t = 1:1/fs:10;
N = length(t);
SNR = 20;
kd = pi;
M = 8;

% Senal deseada e interferente
Ad = cos(2*pi*100.*t);
Ai = cos(2*pi*50.*t);

potA = sum(abs(Ad).^2)/(N);

% Generamos ruido incorrelado entre sensores
potv = potA/(10^(SNR/20));
vr = randn(M,N)*sqrt(potv);
vi = 1i*randn(M,N)*sqrt(potv);
v = vr + vi;

%% Conformador phased array

theta = -90:90;
j = 1;
for k = -90:90
D(:,j) = generate_d(kd,M,k);
j = j + 1;
end

D45 = generate_d(kd,M,45); % Direccion deseada
D30 = generate_d(kd,M,30); % Direccion interferente
w = D45; % Pesos del conformador

F = w'*D;
polarplot(theta*pi/180,abs(F)) % Factor de array

xd = Ad.*D45; % Senal deseada
xi = Ai.*D30; % Senal interferente

x = xd + xi + v;
y = w'*x;

% figure
% plot(abs(fftshift(fft(y)))) % Vemos que la interferente está atenuada
