%% 3.1.1
% Secuencias
s = [0 1 3 5 8 6 4];
t = [0 1 2 1 4 7 5 4 4];

% Matriz de distancias euclideas (D)
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

%% 3.4 Cepstrum señal principal
clear all;
close all;

file = 'audio4_s1.wav';
[x, Fs]=audioread(file);

% Ventana rectangular
N = Fs*30e-3; % Ventana de 30ms
M = Fs*10e-3; % Ventana de 10ms
X = enventanado(x,Fs,N,M);

% Ventana de hamming
w = hamming(N);
Xw = X.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a

% FFT localizada
XW = fft(Xw,512);
XW_mod = abs(XW);
figure
imagesc(XW_mod(1:end/2,:))
axis xy

% Cepstrum localizado
cep = cepstrum(XW_mod);
figure
imagesc(cep(2:end/2,:))
axis xy

cep_f = cep(2:20,:);

%% 3.4 Cepstrum señales a comparar

file_t1 = 'audio4_t1.wav';
[t1, Fs_t1]=audioread(file_t1);
file_t2 = 'audio4_t2.wav';
[t2, Fs_t2]=audioread(file_t2);

% Ventana rectangular
X_t1 = enventanado(t1,Fs_t1,N,M);
X_t2 = enventanado(t2,Fs_t2,N,M);

% Ventana de hamming
Xw_t1 = X_t1.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a
Xw_t2 = X_t2.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a

% FFT localizada
XW_t1 = fft(Xw_t1,512);
XW_t2 = fft(Xw_t2,512);
XW_t1_mod = abs(XW_t1);
XW_t2_mod = abs(XW_t2);

% Cepstrum localizado
cep_t1 = cepstrum(XW_t1_mod);
cep_t2 = cepstrum(XW_t2_mod);
cep_t1_f = cep_t1(2:20,:);
cep_t2_f = cep_t2(2:20,:);

% Restamos la media para disminuir efecto del canal
cep_t1_clean = cep_t1_f - mean(cep_t1_f,1);
cep_t2_clean = cep_t2_f - mean(cep_t2_f,1);


%% 3.4 Distancias cepstrum

D_t1 = distance_matrix(cep_f,cep_t1_clean);
%dtw_seg(D_t1);

[C1,u] = dtw_search(D_t1);

D_t2 = distance_matrix(cep_f,cep_t2_clean);
%dtw_seg(D_t2);

[C2,u] = dtw_search(D_t2);
%% Mel-cepstrum señal principal

clear all;
close all;

file = 'audio4_s1.wav';
[x, Fs]=audioread(file);

% Ventana rectangular
N = Fs*30e-3; % Ventana de 30ms
M = Fs*10e-3; % Ventana de 10ms
X = enventanado(x,Fs,N,M);

% Ventana de hamming
w = hamming(N);
Xw = X.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a

% FFT localizada
XW = fft(Xw,512);

% Mel-Cepstrum localizado
fb = f_banco_filtros_mel(256,24,Fs);
XW_mel = melcepstrum(XW,fb);
b = f_base_dct(24);
MFCC = b'*XW_mel;

figure
imagesc(MFCC(2:13,:))
axis xy

%% Mel-cepstrum señales a comparar

file_t1 = 'audio4_t1.wav';
[t1, Fs_t1]=audioread(file_t1);
file_t2 = 'audio4_t2.wav';
[t2, Fs_t2]=audioread(file_t2);

% Ventana rectangular
X_t1 = enventanado(t1,Fs_t1,N,M);
X_t2 = enventanado(t2,Fs_t2,N,M);

% Ventana de hamming
Xw_t1 = X_t1.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a
Xw_t2 = X_t2.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a

% FFT localizada
XW_t1 = fft(Xw_t1,512);
XW_t2 = fft(Xw_t2,512);

% Mel-Cepstrum localizado
XW_t1_mel = melcepstrum(XW_t1,fb);
XW_t2_mel = melcepstrum(XW_t2,fb);
MFCC_t1 = b'*XW_t1_mel;
MFCC_t2 = b'*XW_t2_mel;

MFCC_t1 = MFCC_t1(2:13,:);
MFCC_t2 = MFCC_t2(2:13,:);


%% 3.4 Distancias Mel-Cepstrum
MFCC = MFCC(2:13,:);

D_t1 = distance_matrix(MFCC,MFCC_t1);
%dtw_seg(D_t1);

[C1,u] = dtw_search(D_t1);

D_t2 = distance_matrix(MFCC,MFCC_t2);
%dtw_seg(D_t2);

[C2,u] = dtw_search(D_t2);

%% Itakura-LPC señal principal

clear all;
close all;

file = 'audio1_s.wav';
[x, Fs]=audioread(file);

% Ventana rectangular
N = Fs*30e-3; % Ventana de 30ms
M = Fs*10e-3; % Ventana de 10ms
X = enventanado(x,Fs,N,M);

% Ventana de hamming
w = hamming(N);
Xw = X.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a


%% Itakura-LPC señales a comparar

file_t1 = 'audio1_t1.wav';
[t1, Fs_t1]=audioread(file_t1);
file_t2 = 'audio1_t2.wav';
[t2, Fs_t2]=audioread(file_t2);

% Ventana rectangular
X_t1 = enventanado(t1,Fs_t1,N,M);
X_t2 = enventanado(t2,Fs_t2,N,M);

% Ventana de hamming
Xw_t1 = X_t1.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a
Xw_t2 = X_t2.*w; % CUIDADO ESTO NO FUNCIONA EN MATLAB<2017a


%% 3.4 Distancias Itakura

P = 8; % Orden del filtro predictor
D_t1 = itakura_distance(Xw, Xw_t1, P);
dtw_seg(D_t1)

D_t2 = itakura_distance(Xw, Xw_t2, P);
dtw_seg(D_t2)

