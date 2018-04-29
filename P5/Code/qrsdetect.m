function [ecgh qrspos] = qrsdetect(signal, Fs)
% [ecgh qrspos] = qrsdetect(signal, Fs)
% This function applies a high-pass filter for baseline wander removal 
% and a QRS detector.
% signal: the input ECG signal
% Fs: Sampling frequency, in Hz
% ecgh: baseline-filtered ECG signal
% qrspos: detected QRS positions (in samples)

%% baseline wander removal
[b,a]=butter(4, 2*0.5/Fs,'high');
ecgh=filtfilt(b,a,signal);

%% QRS detector
hlp=fir1(100,40/Fs*2);
w = hamming(0.1*Fs);
ecghd=diff(ecgh);
ecghdl=conv(ecghd,hlp','same');
y=conv(ecghdl.^2,w.^2,'same');
[~, qrspos]=pkpicker(y,4e5);