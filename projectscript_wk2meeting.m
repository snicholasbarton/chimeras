% build the network
<<<<<<< HEAD:projectscript_wk2meeting.m
N = 10; % number of nodes in the graph
P = 1; % adjacency bandwidth
% topology of the network
A = toeplitz([0,ones(1,P),zeros(1,N-P-2),0]); % adjacency matrix
=======

N = 20; % number of nodes in the graph
P = 6; % adjacency bandwidth
% topology of the network
if N == 1
    A = 1;
else
    A = toeplitz([0,ones(1,P),zeros(1,N-2*P-1),ones(1,P)]); % adjacency matrix
end

>>>>>>> e52128ffe5fff05b616b7bd8572401f3f9b09a7c:projectscript.m
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

% initial conditions for N = 100
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

% solve the ode
<<<<<<< HEAD:projectscript_wk2meeting.m
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), [0 60000], x0);
=======
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), 0:6000, x0);
>>>>>>> e52128ffe5fff05b616b7bd8572401f3f9b09a7c:projectscript.m

% plot the results
mask = find(T > 5000 & T < 5500);

% % limit cycle
% figure(1)
% V=sum(X(:,1:N),2);
% H=sum(X(:,N+1:2*N),2);
% plot(V(mask),H(mask), 'LineWidth', 1.5) % phase plane
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

% %network plot
figure(4)
networkPlot(A, X) %This plots the population data as a network graph

<<<<<<< HEAD:projectscript_wk2meeting.m
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

=======
% colour plots - top is vegetation, bottom is herbivores
figure(5)
colorbar
subplot(2,1,1)
Y = X(mask,1:N);
imagesc(Y)
xlabel('$$i$$','Interpreter','latex')
ylabel('$$t$$','Interpreter','latex')
title('$$V$$ spatiotemporal colour map','Interpreter','latex')
subplot(2,1,2)
Z = X(mask,N+1:2*N);
imagesc(Z)
xlabel('$$i$$','Interpreter','latex')
ylabel('$$t$$','Interpreter','latex')
title('$$H$$ spatiotemporal colour map','Interpreter','latex')
>>>>>>> e52128ffe5fff05b616b7bd8572401f3f9b09a7c:projectscript.m
