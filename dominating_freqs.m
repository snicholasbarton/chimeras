function freqvec = dominating_freqs(X)
%dominating_freqs Finds the dominating frequencies in a set of nodes X
% INPUTS:
%   X: matrix of (time x nodes) for either V or H
% OUTPUTS:
%   freqvec: a sorted array of the dominant frquencies in X

% number of nodes
N = size(X,2);

% transients already discarded

Xc=X-mean(X); % center the `amplitude' of the nodes

maxpeak=3; % number of peaks to take into account
peakstol=0.01; % min height of peak to take into account 

M=size(Vc,1); 
w=fft(Vc); % take fast fourier of X at all nodes in time

fshift=(-(M-1)/2:(M+1)/2-1)/range(T); % create frequency axis (horizontal)
yshift= abs(fftshift(w,1)); % shift fft vector 

% take only positive frequencies
yshift=yshift(fshift>0,:); 
fshift=fshift(fshift>0);

% initialise array of dominating frequencies
freqvec=zeros(N,maxpeak);

for i = 1:N
    
    [pks,locs] = findpeaks(yshift(:,i)); %find the peaks (frequencies)
    
    % cancel noise / keep only high intensity peaks
    locs=locs(pks>peakstol); % index of peaks
    pks=pks(pks>peakstol); % intensity of peaks
    freqs=fshift(locs); %frequency at peaks
    
    % sort frequencies in order of intensity
    [pks,I] = sort(pks,'descend');
    freqs=freqs(I);
    
    % take only maxpeak number of frequencies and store in freqvec
    if length(freqs)>maxpeak-1
        freqvec(i,:)=freqs(1:maxpeak);
    else
        freqvec(i,1:length(freqs))=freqs(1:length(freqs));
    end
        
end

end

