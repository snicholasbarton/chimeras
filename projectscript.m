% build the network
N = 5; % number of nodes in the graph
P = 2; % adjacency bandwidth
% topology of the network
if N == 1
    A = 1;
else
    A = toeplitz([0,ones(1,P),zeros(1,N-P-2),1]); % adjacency matrix
end

% parameter values
r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey
sigma = 3; % coupling strength

params = [r K alpha B beta m sigma P]; % vectorise the parameters

% initial conditions
x0 = rand(2*N,1)*0.5; % random initial conditions

% solve the ode
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), [0 6000], x0);

% plot the results
mask = find(T > 5000 & T < 5150);

% limit cycle
figure(1)
V=sum(X(:,1:N),2);
H=sum(X(:,N+1:2*N),2);
plot(V(mask),H(mask), 'LineWidth', 1.5) % phase plane
