function [ T0 ] = pitch( s, umbral )

fs = 8000;
ts = 1/fs;
p = 10;  % Orden del predictor LPC

a = lpc(s,p);
res = filter(a,1,s);
re = xcorr(res,'biased');
re_nor = re/max(re);
tcorr = 0:ts:(ts*(length(re)-1));
[~, index] = findpeaks(re_nor,tcorr,'SortStr','descend','MinPeakHeight',umbral);

if length(index) < 2
    T0 = 0;
else 
    T0 = abs(index(2)-index(1));
end

end

