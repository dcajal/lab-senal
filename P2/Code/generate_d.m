function [ D ] = generate_d( kd, M, theta )

D = zeros(1,M);
m = 0:M-1;
D = exp(-1i*kd*m*sind(theta)).';

end

