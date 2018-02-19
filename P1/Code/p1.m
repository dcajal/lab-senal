%% 3.1.1
% Secuencias
s = [0 1 3 5 8 6 4];
t = [0 1 2 1 4 7 5 4 4];

% Matriz de distancias (D)
D = zeros(length(t),length(s));
D = distance(s,t)
figure
imagesc(D)
colormap(jet)

%Matriz de costes (C) y distancia minima
[C,u] = dtw2(D)

%% 3.1.2
clear all;
close all;

s = 'pirata'
t = 'pista'

D = distance_letters(s,t)
[C,u] = dtw2(D)


%% 3.3
clear all;
close all;

t = 'eszascojadjfidthbncasasdfhkcosafsdfjsdkhg'
s = 'cosa'

D = distance_letters(s,t)
[C,u] = dtw_search(D)

figure
imagesc(C(2:end,:))
figure
plot(C(2:end,end))

%% 3.4
clear all;
close all;

file = 'audio1_s.wav';
[x, Fs]=audioread(file);

N = Fs*30e-3; % Ventana de 30ms
M = Fs*10e-3; % Ventana de 10ms

T = length(x);
m = 1:M:T-N;
L = length(m); % Numero de ventanas
ind = (0:N-1)' * ones(1,L) + ones(N,1) * m;
X = x(ind);

w = hamming(N);
Xw = X.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a
XW = fft(Xw,512);
XW_mod = abs(XW);
imagesc(XW_mod(1:end/2,:))
axis xy


