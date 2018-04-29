% [y,h] = filtadapt(z,d,mu,L);
%
% Implementa un filtro adaptativo genérica con la estructura lineal transversal.
% La señal deseada es d (vector columna).
% La entrada de referencia es z (vector columna).
% mu es el paso de adaptación del algoritmo LMS.
% L es la longitud del filtro transversal 
%

function [y,h]  = filtadapt(z,d,mu,L)

if size(z,2)~=1, 
    error('z debe ser un vector columna');
end
if size(d,2)~=1, 
    error('d debe ser un vector columna');
end
if size(z,1)~=size(d,1)
    error('z y d deben tener la misma longitud');
end

z=[zeros(L,1); z];
d=[zeros(L,1); d];
e=zeros(size(z));
nsamp=size(z,1);
y = zeros(size(z));
h=zeros(L,nsamp);
k=2*mu;

for i=L+1:nsamp
  y(i)=h(:,i)'*z(i:-1:i-L+1);  %salida del filtro
  e(i)=d(i)-y(i);
  h(:,i+1)=h(:,i)+k*z(i:-1:i-L+1)*e(i);   %adaptación de pesos
end
y=y(L+1:end);
h=h(:,L+1:end);