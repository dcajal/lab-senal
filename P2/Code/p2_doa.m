%% Estimacion angulo de llagada. Generacion de senales

clearvars;

fs = 2000;
t = 1:1/fs:10;
N = length(t);
SNR = 20;
kd = pi;
M = 8;

% Conjunto de senales. En este caso no hay deseada.
A1 = cos(2*pi*50.*t);
A2 = cos(2*pi*60.*t);
A3 = cos(2*pi*70.*t);
A4 = cos(2*pi*80.*t);
A5 = cos(2*pi*110.*t);

potA = sum(abs(A1).^2)/(N);

% Generamos ruido incorrelado entre sensores (complejo)
potv = potA/(10^(SNR/20));
vr = randn(M,N)*sqrt(potv);
vi = 1i*randn(M,N)*sqrt(potv);
v = vr + vi;

% Direcciones interferentes
D_30 = generate_d(kd,M,-30); 
D0 = generate_d(kd,M,0);
D20 = generate_d(kd,M,20);
D25 = generate_d(kd,M,25);
D45 = generate_d(kd,M,45);

% Senales direccionales
x1 = A1.*D_30;
x2 = A2.*D0;
x3 = A3.*D20;
x4 = A4.*D25;
x5 = A5.*D45;

x = x1 + x2 + x3 + x4 + x5 + v;

% Creamos los distintos conformadores

angres = 0.5; % Resolucion en grados
theta = -90:angres:90;
tlength = length(theta);
D = zeros(M,tlength);
j = 1;
for k = -90:angres:90
    D(:,j) = generate_d(kd,M,k);
    j = j + 1;
end

R = (x*x')/N;

%% Metodo de exploracion con phased arrays (periodograma espacial). 

DF = zeros(1,tlength);
for k = 1:tlength
    DF(:,k) = (D(:,k)'*R*D(:,k))/M;
end

DF_abs = abs(DF);
% plot(theta, DF_abs)
[~, index] = findpeaks(DF_abs,theta,'MinPeakHeight',2);

if isempty(index)
    fprintf('No signal detected\n');
else 
    fprintf('Signal(s) detected at: ');
    fprintf('%3.1f, ', index);
    fprintf('\n');
end

%% Metodo de exploracion con optimizacion espacial. 3 grados de resolucion para M = 8.

clear DF DF_abs index;

DF = zeros(1,tlength);
for k = 1:tlength
    num = R\D(:,k);
    den = D(:,k)'*num;
    w = num/den;
    aux = R*w;
    dfnum = w'*aux;
    dfden = w'*w;
    DF(:,k) = dfnum/dfden;
end


DF_abs = abs(DF);
% plot(theta, DF_abs)
[~, index] = findpeaks(DF_abs,theta,'MinPeakHeight',0.15);

if isempty(index)
    fprintf('No signal detected\n');
else 
    fprintf('Signal(s) detected at: ');
    fprintf('%3.1f, ', index);
    fprintf('\n');
end

%% Metodo de anulacion

clear DF DF_abs index w num den;

r1 = zeros(M,1);
% r1(ceil(M/2),1) = 1;
r1(3,1) = 1;

num = R\r1;
den = r1'*num;
w = num/den;

F = w'*D;
F_abs = abs(F);
% plot(theta,F_abs) % Pone minimos en la direccion de las senales

DF = 1./(F_abs.^2);
% plot(theta,DF) % Pone maximos en la direccion de las senales
[~, index] = findpeaks(DF,theta,'MinPeakHeight',40);

if isempty(index)
    fprintf('No signal detected\n');
else 
    fprintf('Signal(s) detected at: ');
    fprintf('%3.1f, ', index);
    fprintf('\n');
end




