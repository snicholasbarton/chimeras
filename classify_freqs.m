function freq_state_flag = classify_freqs(freqvec, A, I)
%classify_freqs Classifies sync, frequency chimera or total a-sync
% INPUTS:
%   freqvec: vector output of dominating_freqs.m
%   A: adjacency matrix of our topology
% OUTPUTS:
%   freq_state_flag: flag determining what state we have with 0 = a-sync, 
%   1 = sync, 2 = frequency chimera

freq_state_flag = 0; % default behaviour has no synchrony

% we've removed steady states from the input
freqvec2=freqvec;

if max(std(freqvec2)) < 10^(-4) % if all nodes have the same frequencies
    freq_state_flag = 1; % sync
else 
    freqvec2 = freqvec2(:,1); % consider only dominant freq
    [n, bin] = histc(freqvec2, uniquetol(freqvec2,1e-4));
    multiplevec = find(n > 1);
    for i = 1:length(multiplevec)
        multiple = multiplevec(i);
        index2 = I(ismember(bin, multiple));
        
        logical = A(index2,index2);
        logical = logical(:);
        
        if any(A(logical))==1
            freq_state_flag = 2; % frequency chimera
            break
        end
    end
end

end

