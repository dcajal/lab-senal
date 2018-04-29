% [y,s] = GENSR(x,SNR,N,INDEX,EST);
%
% Genera una se�al compuesta por la repetici�n de N recurrencias de 
% longitud la de la se�al "x" y formadas por la suma de la se�al "x" m�s un 
% ruido aleatorio con distribuci�n normal y una relaci�n se�al a ruido de 
% "SNR" dB.
% La salida es una matriz (o vector) donde en cada columna hay una 
% realizaci�n de se�al ruidosa.
%
% y:  	Matriz de salida de la se�al.
% s: 	   Desviaci�n est�ndar del ruido a�adido.
%  Si es estacionario (EST=0) s es un escalar correspondiente al SNR.
%	Si no es estacionario (EST distinto de 0) s es una matriz de dimensi�n 
%	2xN que contiene la desviaci�n est�ndar del ruido para cada realizaci�n 
%	en s(1,i) y este mismo valor en dB s(2,i).
% x:     Se�al determinista de entrada.
% SNR:	Relaci�n se�al a ruido en dB.
% N:     N�mero de realizaciones a contaminar.
% INDEX: 0 (salida en formato matriz), 1 (salida en formato vector)
% EST:   Varianza de la SNR en dB (0 es ruido estacionario, otro valor 
%	significa que cada realizaci�n tendr� una relaci�n se�al ruido de media 
%	SNR y con una varianza EST.

function [y,s]  = gensr(x,SNR,N,INDEX,EST)

L=size(x,1);
SNRL=10^(SNR/10);
 
Ps=x'*x/L; 		%Potencia de se�al
 
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
