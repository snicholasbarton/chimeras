function D = find_death(X)
%find_death Checks if any of the nodes are dead steady states
% INPUTS:
%   X: matrix of (time x nodes) for either V or H
% OUTPUTS:
%   D: the indices of dead nodes in X

% tolerance for `death'
tol=1e-7;

% X is of dimension (time x nodes)
N = size(X,2);

% transients discarded previously

% look for Death and record where you find it
D=1:N;
D=D(mean(abs(X)) < tol);

end
