%% Senal chirp

clear all;

fs = 4e6;
DF = 1e6;
Tp = 200e-6;

% Senal chirp
[s,~] = chirpenv(Tp,DF,fs);

[A,n,f] = ambig(s);
%mesh(n,f,abs(A'))

figure
subplot(211)
plot(n,abs(A(:,end/2)))
title('\omega=0')
subplot(212)
plot(f,abs(A((end+1)/2,:)))
title('\tau=0')



%% Senal monofrecuencia

clear all;

fs = 4e6;
DF = 0;
Tp = 200e-6;

% Senal chirp
[s,~] = chirpenv(Tp,DF,fs);

[A,n,f] = ambig(s);
mesh(n,f,abs(A'))

figure
subplot(211)
plot(n,abs(A(:,end/2)))
title('\omega=0')
subplot(212)
plot(f,abs(A((end+1)/2,:)))
title('\tau=0')
