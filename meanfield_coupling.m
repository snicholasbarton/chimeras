function couple_strength = meanfield_coupling(x, params, A)
%linear_coupling Determines the meanfield coupling strength.
% INPUTS:
%   x: length 2N vector containing initial conditions for [V;H]
%   params: vector containing the parameters of the system
%   A: adjacency matrix for the topology of the network
%   coupling: a function handle with output being the coupling of nodes
% OUTPUTS:
%   couple_strength: a length N vector containing coupling terms in H

% unroll x
N = length(x)/2; % number of nodes in the system
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
Q = params(9);

Hbar = 1/N*sum(H);

couple_strength = sigma*Q*(Hbar - P*H);


end