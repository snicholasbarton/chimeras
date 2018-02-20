function [Dv,varargout] = find_death(X)
%find_death Checks if any of the nodes exhibit death (zero steady state)
% INPUTS:
%   X: the output of our odesolve
% OUTPUTS:
%   Dv: the indices of the death nodes in V
%   Dh: (optional) indices of death nodes in H

% X is of dimension (time x nodes) so num nodes is size(X)(2)
S = size(X);
N = S(2);
Nh = N/2;

% separate for convenience
V = X(:,1:Nh);
H = X(:,Nh+1:N);

% discard burn-in/transients
V = V(3*end/4:end);
H = H(3*end/4:end);

% look for death and record where you find it
for n = 1:Nh
    if abs(mean(V(1:end,n))) < 1e-7
        Dv = [Dv;n];
    end
    if abs(mean(H(1:end,n))) < 1e-7
        Dh = [Dh;n];
    end
end

varargout = Dh;
end

