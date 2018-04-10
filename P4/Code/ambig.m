function [A,n,f]=ambig(x)
% AMBIG   genera la funcion de ambiguedad de una señal radar
% [A,n,f] = ambig(x)
% A(distancia,frec. doppler):        funcion de ambiguedad radar. 
% n: eje de tiempos de los retardos (en muestras)
% f: eje de frecuencias doppler discretas (en ciclos / muestra)
% x: señal radar

fo=2; %oversampling
pt=1;
T=length(x);
pf=fo*2*T;
A=zeros(2*T/pt,pf);
xx=flipud(x);
x=[zeros(T,1); x; zeros(T,1)];
xx=[xx;zeros(2*T,1)];
p=1;
f=zeros(1,pt+1);
f(pt+1)=1;
for t=-T:pt:T,
 u=x.*conj(xx);
 xx=filter(f,1,xx);
 A(p,:)=fftshift(fft(u,pf))';
 p=p+1;
end
n=[-T:T];
f=-0.5+1/pf:1/pf:0.5;