h = 0.1;
x = 0:h:100;

figure
plot(X(mask,1))
y = X(mask,1);

% f=@(x)sin(2*pi*x)+cos(x);
% y = f(x);
y = fft(y);
n = length(y);
fshift = (-n/2+1/2:n/2-1/2)/range(x);
yshift = abs(fftshift(y));

% positive half of the plot
yshift = yshift(fshift>=0);
fshift = fshift(fshift>=0);

[pks,locs] = findpeaks(yshift,'MinPeakHeight',mean(yshift));
fshift(locs)

figure
plot(fshift, yshift);