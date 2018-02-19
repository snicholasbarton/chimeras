function [fV, fH] = freq_fft(X,mask,nodeIndex)

n = size(X,2)/2;

if nargin < 3
    yV = sum(X(mask,1:n),2);
    yH = sum(X(mask,(n+1):end),2);
else
    yV = X(mask,nodeIndex);
    yH = X(mask,nodeIndex+100);
end

% plot V and H on a specific node or sum of all nodes
figure
subplot(2,2,1)
plot(yV);
subplot(2,2,2)
plot(yH);

% fft
yV = fft(yV);
yH = fft(yH);
n = length(yV);
yVshift = abs(fftshift(yV));
yHshift = abs(fftshift(yH));
fshift = (-n/2+1/2:n/2-1/2)/range(mask);

% positive half of the plot
yVshift = yVshift(fshift>=0);
yHshift = yHshift(fshift>=0);
fshift = fshift(fshift>=0);

% identify the peaks
[~,locsV] = findpeaks(yVshift,'MinPeakHeight',mean(yVshift));
[~,locsH] = findpeaks(yHshift,'MinPeakHeight',mean(yHshift));
fV = fshift(locsV);
fH = fshift(locsH);

% plot the fft of V and H
subplot(2,2,3)
plot(fshift, yVshift);
subplot(2,2,4)
plot(fshift, yHshift);