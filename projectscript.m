% build the network
N = 5; % number of nodes in the graph
P = 1; % adjacency bandwidth
% topology of the network
A = toeplitz([0,ones(1,P),zeros(1,N-P-2),1]); % adjacency matrix

% parameter values
r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey
sigma = 1.7; % coupling strength

params = [r K alpha B beta m sigma P]; % vectorise the parameters

% initial conditions
x0 = rand(2*N,1)*0.5; % random initial conditions

% solve the ode
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), [0 6000], x0);

% plot the results

% limit cycle
figure(1)
V=sum(X(:,1:N),2);
H=sum(X(:,N+1:2*N),2);
plot(V(5000:6000),H(5000:6000), 'LineWidth', 1.5) % phase plane
figure(2)
subplot(2,1,1);
% plot(T(5000:5150),V(5000:5150))
plot(T(18488:19043),V(18488:19043))
subplot(2,1,2);
% plot(T(5000:5150),H(5000:5150))
plot(T(18488:19043),H(18488:19043))