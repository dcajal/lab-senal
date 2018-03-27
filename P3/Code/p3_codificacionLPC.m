%% Analisis LPC

clear all;

[x,fs] = audioread('frase.wav');
[a,G,T0] = analisis_lpc(x);

y = sintesis_lpc(a,G,T0);
sound(y)
plot(y)