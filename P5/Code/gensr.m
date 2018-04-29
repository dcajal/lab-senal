% [y,s] = GENSR(x,SNR,N,INDEX,EST);
%
% Genera una señal compuesta por la repetición de N recurrencias de 
% longitud la de la señal "x" y formadas por la suma de la señal "x" más un 
% ruido aleatorio con distribución normal y una relación señal a ruido de 
% "SNR" dB.
% La salida es una matriz (o vector) donde en cada columna hay una 
% realización de señal ruidosa.
%
% y:  	Matriz de salida de la señal.
% s: 	   Desviación estándar del ruido añadido.
%  Si es estacionario (EST=0) s es un escalar correspondiente al SNR.
%	Si no es estacionario (EST distinto de 0) s es una matriz de dimensión 
%	2xN que contiene la desviación estándar del ruido para cada realización 
%	en s(1,i) y este mismo valor en dB s(2,i).
% x:     Señal determinista de entrada.
% SNR:	Relación señal a ruido en dB.
% N:     Número de realizaciones a contaminar.
% INDEX: 0 (salida en formato matriz), 1 (salida en formato vector)
% EST:   Varianza de la SNR en dB (0 es ruido estacionario, otro valor 
%	significa que cada realización tendrá una relación señal ruido de media 
%	SNR y con una varianza EST.

function [y,s]  = gensr(x,SNR,N,INDEX,EST)

L=size(x,1);
SNRL=10^(SNR/10);
 
Ps=x'*x/L; 		%Potencia de señal
 
if INDEX == 0 
  y=zeros(L,N);
  if EST == 0
   s=sqrt(Ps/SNRL);
   for i=1:N 
    y(:,i)=x+randn(L,1)*s; 
   end
  else
   s=zeros(2,N);
   for i=1:N 
    s(2,i)=SNR+EST*randn(1);
    s(1,i)=sqrt(Ps/(10^(s(2,i)/10)));
    y(:,i)=x+randn(L,1)*s(1,i); 
   end
  end
else
  y=zeros(L*N,1);
  if EST == 0
   s=sqrt(Ps/SNRL);
   for i=1:N 
    y(L*(i-1)+1:L*i)=x+randn(L,1)*s;
   end
  else
   s=zeros(2,N);
   for i=1:N 
    s(2,i)=SNR+EST*randn(1);
    s(1,i)=sqrt(Ps/(10^(s(2,i)/10)));
    y(L*(i-1)+1:L*i)=x+randn(L,1)*s(1,i);
   end
  end  
end
