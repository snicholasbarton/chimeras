%----Angelica G
% build the network
N = 100; % number of nodes in the graph
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
%x0 = ones(2*N,1)*0.1;
%x0(1:37)= ones(37,1)*0.25;
%x0(67:100)=ones(34,1)*0.03;
%x0(38:99)=rand(62,1)*0.4;
%x0(130:66)=rand(37,1)*

% solve the ode
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), 0:1:6000, x0);

% plot the results

V=X(:,1:N);
H=X(:,N+1:2*N);

% limit cycle
figure(1)
Vsum=sum(X(:,1:N),2);
Hsum=sum(X(:,N+1:2*N),2);
plot(Vsum(5000:6000),Hsum(5000:6000), 'LineWidth', 1.5) % phase plane

%colour plot
figure(2)
imagesc(H(5000:6000,:))

