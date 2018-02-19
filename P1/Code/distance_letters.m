function [out] = distance_letters( x,y )

auxy = y;
mx_y=repmat(auxy',1,length(x));
mx_x=repmat(x,length(auxy),1);
out1=mx_x-mx_y;
outz = zeros(size(out1))
out = out1 ~= outz

end
