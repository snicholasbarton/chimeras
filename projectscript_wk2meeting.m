% build the network
N = 10; % number of nodes in the graph
P = 1; % adjacency bandwidth
% topology of the network
A = toeplitz([0,ones(1,P),zeros(1,N-P-2),0]); % adjacency matrix
% parameter values
r = 0.5; % growth rate of prey
K = 4; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey
sigma = 0.001; % coupling strength

params = [r K alpha B beta m sigma P]; % vectorise the parameters

% initial conditions
x0 = rand(2*N,1)*0.5; % random initial conditions

% solve the ode
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), [0 60000], x0);

% plot the results

% limit cycle
figure(1)
V=sum(X(:,1:N),2);
H=sum(X(:,N+1:2*N),2);
plot(V(5000:6000),H(5000:6000), 'LineWidth', 1.5); % phase plane

%network plot
figure(2)
% networkPlot(A, X(1:5000,:)) %This plots the population data as a network graph
subplot(2,1,1)
plot(T,V)
subplot(2,1,2)
plot(T,H)

