function [ f0 ] = silent_frame_classification2(x, f0)

%this method works for noisy signals - find PSD of signal, and its spectral flatness
%the assumption is that silent frames have only noise and therefore a flat
%power spectrum

[psdw, w] = pwelch(x); 
%this method works in case the signal isn't noisy.
energy = 20*log10(sum(x.^2));% epa yepa, que es con 10 hamijo
%the spectral flatness method works only if signal is noisy
spectral_flatness = geomean(psdw)/mean(psdw);


norm_spec_flatness = spectral_flatness./max(spectral_flatness);
threshold = 0.9;
silent = norm_spec_flatness >= threshold | energy < -50;

if silent == 1
    f0 = 0;
end
% 
% figure;
% set(gca, 'fontsize', 14);
% hold on
% plot(spectral_flatness);grid on;
% xlabel('Frame number');
% ylabel('Spectral flatness');
% %print('/home/orchisama/Documents/MATLAB/pitch_tracking/DAFx 2017/dafx17/my_paper/spf','-deps');

%make sure that partially silent frames are taken into account

% for i = 2:nframes-1
%     %voiced frame preceded or followed by silent frame
%     if(silent(i) == 0 && silent(i-1) == 1) 
%         %returns signal indices with very low amplitude
%         ind = envelope_follower(x(i,:),1);
%         f0(i,ind) = zeros(1,length(ind));
%     elseif(silent(i) == 0 && silent(i+1) == 1)
%         ind = envelope_follower(x(i,:),0);
%         f0(i,ind) = zeros(1,length(ind)); 
%     end
% end
    
end
