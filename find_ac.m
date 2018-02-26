function state = find_ac(X,A,I)
%find_chaos Checks if any of the nodes exhibit chaos
% INPUTS:
%   X: matrix of (time x nodes) for V or H with steady states removed
%   A: adjacency matrix of the network
%   I: the (global) indices of the nodes included in X
% OUTPUTS:
%   state: 1 if there is a amplitude chimera, 0 o/w

amplvec = range(X);

state = 0;

if range(amplvec) > 10^(-4) % if there is more than one amplitude
    [n, bin] = histc(amplvec, uniquetol(amplvec,1e-4));
    multiplevec = find(n > 1);
    
    for i = 1:length(multiplevec)
        multiple = multiplevec(i);
        index2 = I(ismember(bin, multiple));
        
        logical = A(index2,index2);
        logical = logical(:);
        
        if any(logical) == 1
            state=1; % amplitude chimera
            break
        end
    end
end

end