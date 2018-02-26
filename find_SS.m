function SS = find_SS(X)
%find_SS Checks if any of the nodes are steady states
% INPUTS:
%   X: the output of our odesolve
% OUTPUTS:
%   SS: the indices of the SS nodes in X

% tolerance for `steadiness'
tol=1e-4;

% X is of dimension (time x nodes)
N = size(X,2);

% transients deleted previously

% look for SS and record where you find it
SS=1:N;
SS=SS(range(X) < tol);

end