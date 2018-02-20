function [D] = distance_matrix( X,Y )

[D1,N1]= size(X);
[D2,N2]= size(Y);
D = zeros(N1,N2);

for i = 1:N1
    for j = 1:N2
        x = X(:,i);
        y = Y(:,j);
        D(i,j) = (x - y)'*(x - y);
    end
end

end