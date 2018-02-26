% build the network

N = 100; % number of nodes in the graph
P = 10; % adjacency bandwidth

A = makeAdjMat(N, 'sqlattice', P);

% parameter values
r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey
sigma = 7; % coupling strength

params = [r K alpha B beta m sigma P]; % vectorise the parameters

% initial conditions
%x0 = rand(2*N,1)*0.5; % random initial conditions

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

load('x0');
% solve the ode
opts = odeset('AbsTol', 1e-9, 'RelTol', 1e-9);
[T, X] = ode45(@(t, x) RMoscillator(x, params, A, @linear_coupling), 0:6000, x0, opts);

% plot the results

mask = find(T > 5000 & T <= 6000);

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

%figure(4)
%networkPlot(A, X) %This plots the population data as a network graph

% colour plots - top is vegetation, bottom is herbivores
figure(6)
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

dev=std(Y(:,1:N)); % Y veg Z herbivore
if max(dev) < 0.01       % if all sd are 0 / all steady states
    state=1; 
    disp([P sigma]);
    disp('CD');

elseif min(dev) > 0.01   % if all sd are non-0 / no steady states
    state=3; 
    disp([P sigma]);
    disp('Sync');

else                     % some oscillatory & some steady states
    sdrange=range(dev(dev>sqrt(eps)));
    
    if sdrange>0.1*max(dev)
        state=4; 
        disp([P sigma]);
        disp('AC+Death');   
    else
        state=2; 
        disp([P sigma]);
        disp('CSOD');
    end
end


