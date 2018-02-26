function [state, n, bin] = Find_FC(freqvec,A,I)
% function that checks if there is sync or freq-chimera or neither in the
% non steady states

% NOTE: function can be run only after you check its not CD

% state 0: Neither    
% state 1: Sync       
% state 2: Freq-Chimera


%%%%%%%%%%%%% CLASSIFICATION %%%%%%%%%% 


state=0; % no state

% assuming it is not CD

if range(freqvec)<0.05*max(freqvec) % if all nodes have the same frequencies
    state=1; % sync
    n = 0;
    bin = 0;
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
