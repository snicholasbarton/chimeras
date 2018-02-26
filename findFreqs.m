function freqvec = findFreqs(X,T)
%findFreqs Finds the frequencies at which the given nodes are oscillating
% INPUTS:
%   X: array of size (time x nodes) of the nodes
%   T: time at which each node is evaluated
% OUTPUTS:
%   freqvec: vector containing dominant frequency of each node
N = size(X,2);
M = size(X,1); 

Xc = X-mean(X); % center the nodes to mean zero
 
w = fft(Xc); % take fast fourier of Xc at all nodes in time

fshift = (-(M-1)/2:(M+1)/2-1)/range(T); % create frequency axis
yshift = abs(fftshift(w,1)); % shift fft vector 

% take only positive frequencies
yshift = yshift(fshift > eps,:); 
fshift = fshift(fshift > eps);

% create matrix of (N x maxpeak) that will contain the dominating
% frequencies
freqvec = zeros(N,1); % allocate 

for i = 1:N
    [pks,locs] = findpeaks(yshift(:,i)); %find the peaks (frequencies)

    freq = fshift(locs); %frequency at peaks
    
    % take maximum peak and find corresponding frequency 
    [~,Ind] = max(pks);
    freq = freq(Ind);
    
    % take only maxpeak number of frequencies and store in freqvec
    
    freqvec(i) = freq;
        
end
end