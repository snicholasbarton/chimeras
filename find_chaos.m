function Z = find_chaos(X)
%find_chaos Checks if any of the nodes exhibit chaos
% INPUTS:
%   X: matrix of (time x nodes) for either V or H
% OUTPUTS:
%   Z: the indices of the chaotic nodes in X

% X is size (time x num. nodes)
N = size(X,2);

% transients discarded previously
Z = []; % initialise Z

% look for chaos and record where you find it
for n = 1:N
    chaos_Xn = z1test(X(1:10:end,n));
    if abs(1 - chaos_Xn) < 0.75
        Z = [Z;n];
    end
end


end
