function [time, f0] = yin_estimator2(x, fs)

%function that implements YIN algorithm for
%fundamental pitch tracking
%x - input audio signal
%fs - sampling rate
%time,f0 - time vector and associated fundamental frequencies estimated

W = ceil(length(x)/2);
%step 1 - calculate difference function 
d = zeros(1,W);
for tau = 0:W-1
    for j = 1:W  
         d(tau+1) = d(tau+1) + (x(j) - x(j+tau)).^2;         
    end
end


%step 2 - cumulative mean normalised difference function
d_norm = zeros(1,W);
d_norm(1) = 1;

for tau = 1:W-1
    d_norm(tau+1) = d(tau+1)/((1/tau) * sum(d(1:tau+1)));
end

% figure(1);
% subplot(211);
% plot(d);grid on;
% xlabel('Lags');
% ylabel('Difference function');
% subplot(212);
% plot(d_norm);grid on;
% xlabel('Lags');
% ylabel('Cumulative mean difference function');

%step 3 - absolute thresholding
th = 0.125;
l = find(d_norm < th,1);
if(isempty(l) == 1)
    [v,l] = min(d_norm);
end
lag = l;


%step 4 - parabolic interpolation
if(lag > 1 && lag < W)
    alpha = d_norm(lag-1);
    beta = d_norm(lag);
    gamma = d_norm(lag+1);
    peak = 0.5*(alpha - gamma)/(alpha - 2*beta + gamma);
    %ordinate needs to be calculated from d and not d_norm - see paper
    %ordinate = d(i,lag(i)) - 0.25*(d(i,lag(i)-1) - d(i,lag(i)+1))*peak;
else
    peak = 0;
end
%1 needs to be subtracted from 1 due to matlab's indexing nature
period = (lag-1) + peak;
f0 = fs/period;
time = (0:W-1)/fs;


%for silent frames estimated frequency should be 0Hz
[f0] = silent_frame_classification2(x, f0);

end


