function   [x,t] = chirpenv( T, DF, fs )
%CHIRPENV    genera la envolvente compleja de una señal chirp muestreada
%-----       exp(j*(DF/T)*pi*t^2)   -T/2 <= t < +T/2
%
%   Uso:   X = chirp( T, DF, <fs> )
%
%      X :  vector con N=pTW muestras de la señal chirp
%      T :  duration del pulso -T/2 to +T/2
%      DF :  barrido de frecuencia -W/2 to +W/2 
%
%      t : eje de tiempos de la señal devuelta
%
%   opcional (por defecto fs = DF, factor de sobremuestreo = 1)


if nargin < 3
   p = 1;   end    
J = sqrt(-1);
%--------------
delta_t = 1/fs; % Periodo de Muestreo
N = round(fs*T);   % Numero de Muestras
t=[-T/2:delta_t:T/2-delta_t]';
x = exp( J*pi*DF/T *t.^2 );
%fins=1/(2*pi)*diff(unwrap(angle(x)))/delta_t;
