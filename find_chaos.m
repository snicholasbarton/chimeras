function [Zv,varargout] = find_chaos(X)
%find_chaos Checks if any of the nodes exhibit chaos
% INPUTS:
%   X: the output of our odesolve
% OUTPUTS:
%   Zv: the indices of the chaotic nodes in V
%   Zh: (optional) indices of chaotic nodes in H

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


% look for chaos and record where you find it
for n = 1:Nh
    chaos_Vn = z1test(V(1:100:end,n));
    chaos_Hn = z1test(H(1:100:end,n));
    if abs(1 - chaosVn) < 0.15
        Zv = [Zv;n];
    end
    if abs(1-chaosHn) < 0.15
        Zh = [Zh;n];
    end
end

varargout = Zh;



end

