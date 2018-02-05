% build the network
N = 100; % number of nodes in the graph
P = 10; % adjacency bandwidth
% topology of the network
A = toeplitz([0,ones(1,P),zeros(1,N-P-2),0]); % adjacency matrix

% parameter values
r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey; try K=4, larger K yields dyssynchrony
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey
sigma = 1.7; % coupling strength; try sigma=0.001, little migration

params = [r K alpha B beta m sigma P]; % vectorise the parameters

% initial conditions
x0 = rand(2*N,1)*0.5; % random initial conditions, two populations V and H
V0 = [ones(N/4,1)*0.33;rand(N/2,1)*0.5;ones(N/4,1)*0.05];
H0 = [ones(N/4,1)*0.1;rand(N/2,1)*0.5;ones(N/4,1)*0.1];
x1 = [V0;H0];

% solve the ode
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), [0 6000], x1);

% plot the results

% limit cycle
mask = find(T>5000 & T<5150);
% figure(1)
% V=sum(X(:,1:N),2);
% H=sum(X(:,N+1:2*N),2);
% plot(V(mask),H(mask), 'LineWidth', 1.5) % phase plane
% figure(2)
% subplot(2,1,1);
% plot(T(mask),V(mask))
% subplot(2,1,2);
% plot(T(mask),H(mask))
figure(3)
imagesc(1:1:N,T(mask),X(mask,1:N));
colorbar
figure(4)
imagesc(1:1:N,T(mask),X(mask,N+1:end));
colorbar
figure(5)
subplot(2,1,1)
plot(1:1:N,V0,'*')
subplot(2,1,2)
plot(1:1:N,H0,'*')
% figure(6)
% networkPlot(A, X(mask,:)) %This plots the population data as a network graph