function dxdt = RMoscillator(x, params, A, coupling)
%RMoscillator RHS of N, coupled Rosenzweig-MacArthur oscillators
% INPUTS:
%   x: length 2N vector containing initial conditions for [V;H]
%   params: vector containing the parameters of the system
%   A: adjacency matrix for the topology of the network
%   coupling: a function handle with output being the coupling of nodes
% OUTPUTS:
%   dxdt: the time rate of change of [V;H]

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

% differential equations for V, H; replace sum with mat-vec mult
dVdt = r.*V.*(1-V./K)-alpha*H.*V./(V+B);
dHdt = H.*(alpha*beta*V./(V+B)-m) + coupling(x, params, A);

% roll up results
dxdt=[dVdt; dHdt];
end