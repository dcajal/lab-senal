function [out2] = distance( x,y )

xlen = length(x);
ylen = length(y);
auxy = zeros(ylen);
mx_y = zeros(ylen,xlen);
mx_x = zeros(ylen,xlen);

% auxy = y(end:-1:1); Si la queremos con el minimo abajo a la izquierda
auxy = y;
mx_y = repmat(auxy', 1, xlen);
mx_x = repmat(x, ylen, 1);
out1 = mx_x - mx_y;
out2 = out1.^2;

end
