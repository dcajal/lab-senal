% y = ADAI(x,u,L);
%
% Implementa el filtro adaptativo con la estructura lineal transversal.
% La entrada primaria es x (vector columna).
% La entrada de referencia es un tren de impulsos periódico.
%	1,0,...............,0,1,0,...............,0,1,0,...
%	(con repeticiones de L-1 ceros)
% u es el paso de adaptación del algoritmo LMS.
% L es la longitud del filtro transversal y el número de muestras en una
% recurrencia.
%

function [y]  = adai(x,u,L)

D1=size(x,1);
if D1/L ~= round(D1/L) ;
  disp('¡La entrada primaria NO tiene un numero entero de periodos!');
  return;
end;

y=zeros(size(x)); 
W=zeros(L,1);
k=2*u;

for i=1:D1
  ii=i-floor((i-1)/L)*L;
  y(i)=W(ii);
  W(ii)=W(ii)+k*(x(i)-y(i));
end

