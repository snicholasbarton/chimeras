N = 100; % number of nodes in the graph
P = 1; % adjacency bandwidth
e = 10; %number of edges of random matrix

A=makeAdjMat(N,'ring',P);

%diag(A)=zeros(size(A,1),1);

% parameter values
r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey
sigma = 1.7; % coupling strength = epsilon for mean field
Q = 1/P; % meanfield strength for meanfield coupling only

params = [r K alpha B beta m sigma P Q]; % vectorise the parameters

% initial conditions

% x0 = rand(2*N,1)*0.5; % random initial conditions

% % initial conditions for N = 100
% x0 = ones(200,1)*0.252; % base condition
% x0(37:46,1) = 0.1;
% x0(37:46,1) = x0(37:46,1) + 0.25*rand(10,1);
% x0(47:66,1) = 0.05;
% x0(47:66,1) = x0(47:66,1) + 0.25*rand(20,1);
% x0(67:100) = 0.033;
% x0(101:136) = 0.102;
% x0(137:146) = 0.05;
% x0(137:146) = x0(137:146) + 0.25*rand(10,1);
% x0(147:166) = 0.05;
% x0(147:166) = x0(147:166) + 0.25*rand(20,1);
% x0(167:200) = 0.09;

load('x0');

% solve the ode
options = odeset('RelTol',1e-9,'AbsTol',1e-9);
[T, X] = ode45(@(t, x) RMoscillator(x, params, A, @interaction_coupling), 0:0.05:6000, x0,options);

% plot the results

% find the right sample size to reproduce the figures
% searching T is not too bad since T is ordered
mask = find(T > 5000 & T <= 6000);

% % limit cycle
% figure(1)
% V=sum(X(:,1:N),2);
% H=sum(X(:,N+1:2*N),2);
% plot(V(mask),H(mask), 'LineWidth', 1.5) % phase plane
% 
% H, V vs t
% figure(2)
% plot(T(mask),X(mask,1:N), 'LineWidth', 1.5)
% xlabel('$$t$$','Interpreter','latex')
% ylabel('$$V$$','Interpreter','latex')
% title('Time series of $$V$$ - Dutta/Banerjee Fig 1bi','Interpreter','latex')
% 
% figure(3)
% plot(T(mask),X(mask,N+1:2*N), 'LineWidth', 1.5)
% xlabel('$$t$$','Interpreter','latex')
% ylabel('$$H$$','Interpreter','latex')
% title('Time series of $$H$$ - Dutta/Banerjee Fig 1bii','Interpreter','latex')

% % %network plot
% figure(4)
% networkPlot(A, X) %This plots the population data as a network graph

% % limit cycle
% figure(1)
% V=sum(X(:,1:N),2);
% H=sum(X(:,N+1:2*N),2);
% plot(V(mask),H(mask), 'LineWidth', 1.5) % phase plane
% xlabel('$$V$$','Interpreter','latex')
% ylabel('$$H$$','Interpreter','latex')
% title('Limit Cycle attractor - Dutta/Banerjee Fig 1a','Interpreter','latex')
% 
% % H, V vs t
% figure(2)
% plot(T(mask),V(mask), 'LineWidth', 1.5)
% xlabel('$$t$$','Interpreter','latex')
% ylabel('$$V$$','Interpreter','latex')
% title('Time series of $$V$$ - Dutta/Banerjee Fig 1bi','Interpreter','latex')
% 
% figure(3)
% plot(T(mask),H(mask), 'LineWidth', 1.5)
% xlabel('$$t$$','Interpreter','latex')
% ylabel('$$H$$','Interpreter','latex')
% title('Time series of $$H$$ - Dutta/Banerjee Fig 1bii','Interpreter','latex')

% % colour plots - top is vegetation, bottom is herbivores
% figure(6)
% figure()
% subplot(2,1,1)
% plot(T(mask),V(mask,:))
% xlabel('time step','Interpreter','latex')
% title('$$V$$ behaviour','Interpreter','latex')
% 
% subplot(2,1,2)
% plot(T(mask),H(mask,:))
% xlabel('time step','Interpreter','latex')
% title('$$H$$ behaviour','Interpreter','latex')
