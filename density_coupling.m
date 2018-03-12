function couple_strength = density_coupling(x, params, A)
%density_coupling Summary of this function goes here
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

shape=1;
maxd=0.25;
hS=0.15;
D=@(H) maxd.*H.^(shape)./(hS.^shape+H.^shape);

% differential equations for V, H;

HD = H.*D(H);
couple_strength = sigma*(A*HD - diag(HD)*A*ones(N,1))./sum(A,2);

end