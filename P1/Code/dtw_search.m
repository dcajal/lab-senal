function [C,u] = dtw_search( D )

C = zeros(size(D));
C(1,2:length(D(1,:))) = 1000;
C(:,1) = D(:,1)

for i = 2:length(D(:,1))
    for j = 2:length(D(1,:))
        C(i,j) = D(i,j) + min( [ C(i-1,j), C(i,j-1), C(i-1,j-1) ] );
    end
end

u = C(end,end);

end
