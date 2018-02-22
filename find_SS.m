
function [SSv,SSh] = find_SS(X)
%find_SS Checks if any of the nodes are steady states
% INPUTS:
%   X: the output of our odesolve
% OUTPUTS:
%   Dv: the indices of the SS nodes in V
%   Dh: indices of SS nodes in H

% tolerance for SS range
tol=1e-7;

% X is of dimension (time x nodes.2) so num nodes is size(X,2)/2
N = size(X,2)/2;


% separate for convenience
V = X(:,1:N);
H = X(:,N+1:2*N);

% discard burn-in/transients
V = V(floor(3*end/4):end,:);
H = H(floor(3*end/4):end,:);

% look for SS and record where you find it
SSv=1:N;
SSh=1:N;
SSv=SSv(range(V) < tol);
SSh=SSh(range(H) < tol);

end