%----Angelica G
% build the network
clear

N = 100; % number of nodes in the graph
P = 1; % adjacency bandwidth
e = 60;

A=makeAdjMat(N,'random',e);
% A=makeAdjMat(N,'ring',P);

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

% x0 = rand(2*N,1)*0.5; % random initial conditions

% initial conditions for N = 100
x0 = ones(200,1)*0.252; % base condition
x0(37:46,1) = 0.1;
x0(37:46,1) = x0(37:46,1) + 0.25*rand(10,1);
x0(47:66,1) = 0.05;
x0(47:66,1) = x0(47:66,1) + 0.25*rand(20,1);
x0(67:100) = 0.033;
x0(101:136) = 0.102;
x0(137:146) = 0.05;
x0(137:146) = x0(137:146) + 0.25*rand(10,1);
x0(147:166) = 0.05;
x0(147:166) = x0(147:166) + 0.25*rand(20,1);
x0(167:200) = 0.09;

% solve the ode

[T, X] = ode45(@(t, x) RMoscillator(x, params, A), 0:6000, x0);


% plot the results
mask = find(T > 5000 & T < 5500);


%network plot
figure()
networkPlot(A, X) %This plots the population data as a network graph

V=X(:,1:N);
H=X(:,N+1:2*N);

% limit cycle
figure()
Vsum=sum(X(:,1:N),2);
Hsum=sum(X(:,N+1:2*N),2);
plot(Vsum(mask),Hsum(mask), 'LineWidth', 1.5) % phase plane

% colour plots - top is vegetation, bottom is herbivores
figure()
colorbar

subplot(2,1,1)
imagesc(V(mask,:))
xlabel('$$i$$','Interpreter','latex')
ylabel('$$t$$','Interpreter','latex')
title('$$V$$ spatiotemporal colour map','Interpreter','latex')

subplot(2,1,2)
imagesc(H(mask,:))
xlabel('$$i$$','Interpreter','latex')
ylabel('$$t$$','Interpreter','latex')
title('$$H$$ spatiotemporal colour map','Interpreter','latex')

figure()
subplot(2,1,1)
plot(T(mask),V(mask,:))
xlabel('time step','Interpreter','latex')
title('$$V$$ behaviour','Interpreter','latex')

subplot(2,1,2)
plot(T(mask),H(mask,:))
xlabel('time step','Interpreter','latex')
title('$$H$$ behaviour','Interpreter','latex')
