function [s,binned,kernel] = spikeDensityEstimate(ts,trialLength,sigma)
% ts = timestamps in seconds
% trialLength = trial length in seconds (max(ts) is a rough estimate)
% sigma = std deviations for kernel edges
% modified from: MATLAB for Neuroscientists, p.319-320

trialLength = round(trialLength,3); % round to ms
binned = hist(ts,[0:.001:trialLength]); % bin data
% sigma = .05; % kernel std, 50ms
edges = [-3*sigma:.001:3*sigma]; % time ranges
kernel = normpdf(edges,0,sigma); % eval guassian kernel
kernel = kernel*.001; % multiply by bin width
s = conv(binned,kernel); % convolve
center = ceil(length(edges)/2); % index of kernel center
s = s(center:trialLength*1000 + center);

if false
    figure;
    t = linspace(0,trialLength,length(s));
    plot(t,s)
    hold on;
    spikeIdx = find(binned == 1);
    plot(t(spikeIdx),zeros(length(spikeIdx),1),'+'); % plotted as seconds
end

% hold on; plot(t(spansUpper),[upperThresh upperThresh])
% hold on; plot(t(spansLower),[lowerThresh lowerThresh])
% hold on; plot(t(spansMiddle),[lowerThresh upperThresh])