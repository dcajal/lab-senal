%	[y] = GENSd(x,sa,N,INDEX,DIS)
%
% Genera una señal compuesta por la repeticion de N recurrecias de 
% longitud la de la señal "x" y formadas por   la señal "x" decalada 
% una cantidad aleatoria con desviacion estandar "sa" muestras
% La salida es una matriz (o vector) "y" donde en cada columna hay una 
% realizacion de señal sin ruido
%
% y:	Matriz de salida de la señal
% x:	Señal determinista de entrada
% sa: 	Desviacion estandar del decalage si es distribucion Gaussiana
%       limite de la distribucion si esta es uniforme entre (-sa, sa) muestras
% N:	numero de realizaciones a decalar
% INDEX:  0  (salida en formato matrix),  1 (salida en formato vector)
% DIS:    0  (Distribucion Gaussiana del decalage), 1 (Distribucion uniforme del decalage)
% 
% La entrada x debe ser un vector columna
%
function [y]  = gensd(x,sa,N,INDEX,DIS)

 
 
L=size(x,1);	% L numero de muestras en cada realizacion

if INDEX == 0
   y=zeros(L,N);

   for i=1:N
    if DIS == 0 
        d=sa*randn(1);
    else
        d=(sa+0.5)*2*(rand(1)-0.5);
    end
    d = round(d);
    for j=1:L 
      if (j+d>=1) & (j+d<=L) 
       y(j,i)=x(j+d);
      end
    end 
   end
  
else
 y=zeros(L*N,1);
  for i=1:N
    if DIS == 0 
        d=sa*randn(1);
    else
        d=(sa+0.5)*2*(rand(1)-0.5);
    end
    d = round(d);
    for j=1:L 
      if (j+d>=1) & (j+d<=L) 
       y((i-1)*L+j)=x(j+d);
      end
    end 
  end 
end
 
