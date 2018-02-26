function [ D ] = itakura_distance(X, Y, P)


[D1,N1]= size(X);
[D2,N2]= size(Y);
D = zeros(N1,N2);

for i = 1:N1
    for j = 1:N2
        x = X(:,i);
        y = Y(:,j);
        [~,Rx] = corrmtx(x,P);
        ax = levinson(Rx(1,:));
        [~,Ry] = corrmtx(y,P);
        ay = levinson(Ry(1,:));
        Ey = ay*Rx*ay';
        Ex = ax*Rx*ax';
        D(i,j) = log10(Ey/Ex);
    end
end



end
