function [Dv,Dh] = find_Death(X)
%find_SS Checks if any of the nodes are dead steady states
% INPUTS:
%   X: the output of our odesolve
% OUTPUTS:
%   Dv: the indices of the Dead nodes in V
%   Dh: (optional) indices of Dead nodes in H

% tolerance for Dead range
tol=1e-7;

% X is of dimension (time x nodes.2) so num nodes is size(X,2)/2
N = size(X,2)/2;


% separate for convenience
V = X(:,1:N);
H = X(:,N+1:2*N);

% discard burn-in/transients
V = V(3*end/4:end,:);
H = H(3*end/4:end,:);

% look for Death and record where you find it
Dv=1:N;
Dh=1:N;
Dv=Dv(mean(abs(V)) < tol);
Dh=Dh(mean(abs(H)) < tol);

end