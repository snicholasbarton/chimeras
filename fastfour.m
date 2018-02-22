clear
x=transpose(50:0.1:100);
y=zeros(size(x,1),2);
y(:,1)=sin(2*pi*x)+cos(3*pi*x);
y(:,2)=sin(3*pi*x)+cos(4*pi*x);
% w=fft(y);
w=fft(y);
n=length(w(:,2));
fshift = (-(n-1)/2:(n+1)/2-1)/range(x);
size(fshift)
yshift = abs(fftshift(w(:,2)));
size(yshift)
% yshift = abs(w(:,2));


%yshift=yshift(fshift>0);
%fshift=fshift(fshift>0);
%peak1=fshift(yshift==max(yshift));
%[pks,locs] = findpeaks(yshift);
%fshift(locs)
figure()
plot(fshift,yshift);
