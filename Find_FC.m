function state = Find_FC(V,T,A,I)
% function that checks if there is sync or freq-chimera or neither in the
% non steady states

% NOTE: function can be run only after you check its not CD

% state 0: Neither    
% state 1: Sync       
% state 2: Freq-Chimera


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

%%%%%%%%%%%%% CLASSIFICATION %%%%%%%%%% 

state=0; % no state

% assuming it is not CD

if std(freqvec)<10^(-1) % if all nodes have the same frequencies
    state=1; % sync
else 
    [n, bin] = histc(freqvec, uniquetol(freqvec,1e-4));
    multiplevec = find(n > 1);
    for i =1:length(multiplevec)
        multiple=multiplevec(i);
        
        index2 = I(ismember(bin, multiple));
        
        logical=A(index2,index2);
        logical=logical(:);
        
        if any(logical)==1
            state=2; % frequency chimera
            break
        end
    end
end


end
