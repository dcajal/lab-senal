%% Estimacion angulo de llagada. Senales desconocidas.

clearvars;

load('snapapli.mat');
x = snap.';
N = size(x,2);

% fs = 8000;
% ts = 1/fs;
% t = linspace(0,ts*N,N);
% plot(t,x(1,:))

lambda = 3e8/1.5e9;
d = 0.1; % m
kd = (2*pi/lambda)*d;
M = 8;

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

clear DF DF_abs index num den w dfnum dfden aux;

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

