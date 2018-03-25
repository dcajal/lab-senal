T0 = 10;
n = 1:100;
t = zeros(1,length(n));

for i = 1:length(n)
    if mod(i,T0) == 0
        t(i) = 1;
    end
end

r = xcorr(t);
stem(r)