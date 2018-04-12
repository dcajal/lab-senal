clear all
close all

fs = 44100;

x = csvread('audio - Copy.csv');
x = x(1:end-1); % La ultima muestra siempre es cero porque queda una coma suelta
diff = csvread('diff - Copy.csv');
diff = diff(1:end-1);
cum = csvread('cum - Copy.csv');
cum = cum(1:end-1);

%%
%[t,f0] = yin_estimator2(x, fs);

figure
subplot(311)
plot(x)
title('Senal de audio Android')
grid on
subplot(312)
plot(diff)
title('Funcion diff Android')
grid on
subplot(313)
plot(cum)
title('Funcion cum Android')
grid on


