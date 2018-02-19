function couple_strength = interaction_coupling(x, params, A)
%interaction_coupling Prey-predator interaction dispersal described in Kang
%et al. (2015) Specifically, Eq 1
% INPUTS:
%   x: length 2N vector containing initial conditions for [V;H]
%   params: vector containing the parameters of the system
%   A: adjacency matrix for the topology of the network
%   coupling: a function handle with output being the coupling of nodes
% OUTPUTS:
%   couple_strength: a length N vector containing coupling terms in H

% unroll x
N = length(x)/2; % number of nodes in the system
V = x(1:N); % prey
H = x(N+1:2*N); % predators

% unroll parameters
r = params(1);
K = params(2);
alpha = params(3);
B = params(4);
beta = params(5);
m = params(6);
sigma = params(7);
P = params(8);

couple_strength = zeros(N,1);
for i = 1:N
    for j = 1:N
        if A(i,j) ~= 0
            rho = 5*sigma*alpha*H(i)*H(j)/(2*P);
            couple_strength(i) = couple_strength(i) + rho*(V(j)/(1+V(j)) - V(i)/(1+V(i)));
        end
    end
end

end

