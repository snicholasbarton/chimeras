function dxdt = RMoscillator(x, params, A)
%RMoscillator RHS of N, coupled Rosenzweig-MacArthur oscillators

% unroll x
N = length(x); N = N/2; % number of nodes in the system
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
dVdt = r*V.*(1-V./K)-(alpha*H.*V)./(V+B);
dHdt = H.*(alpha*beta*V./(V+B)-m) + sigma/(2*P).*(A*H - diag(H)*A*ones(N,1));

% roll up results
dxdt=[dVdt; dHdt];
end
