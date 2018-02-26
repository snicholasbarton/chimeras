function freqvec = findFreqs(V,T)
N=size(V,2);
M=size(V,1); 

%%%%%%%%%%%%% find dominating frequencies %%%%%%%%%% 

Vc=V-mean(V); % center all the vegetation at the nodes
 
w=fft(Vc); % take fast fourier of Vc at all nodes in time

fshift=(-(M-1)/2:(M+1)/2-1)/range(T); % create frequency axis (horizontal)
yshift= abs(fftshift(w,1)); % shift fft vector 

% take only positive frequencies
yshift=yshift(fshift>0,:); 
fshift=fshift(fshift>0);

% create matrix of (N x maxpeak) that will contain the dominating
% frequencies

freqvec=zeros(N,1); % allocate 

for i = 1:N
    
    [pks,locs] = findpeaks(yshift(:,i)); %find the peaks (frequencies)

    freq=fshift(locs); %frequency at peaks
    
    % take maximum peak and find corresponding frequency 
    [pk,Ind]=max(pks);
    freq=freq(Ind);
    
    % take only maxpeak number of frequencies and store in freqvec
    
    freqvec(i)=freq;
        
end
end