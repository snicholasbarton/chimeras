function state = Chimera(P,sigma)

% build the network
%p=[1,3,5,10,15,30];
%for i=1:5
N = 100; % number of nodes in the graph
%P = p(i) % adjacency bandwidth
% topology of the network

if N == 1
    A = 1;
else
    A = toeplitz([0,ones(1,P),zeros(1,N-2*P-1),ones(1,P)]); % adjacency matrix
end

% parameter values
r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey

params = [r K alpha B beta m sigma P]; % vectorise the parameters

% initial conditions
%x0 = rand(2*N,1)*0.5; % random initial conditions

%initial conditions for N = 100
load('x0')
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
[T, X] = ode45(@(t, x) RMoscillator(x, params, A), 0:6000, x0);

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

% %colour plots - top is vegetation, bottom is herbivores
% figure(5)
% colorbar
% subplot(2,1,1)
Y = X(mask,1:N);
% imagesc(Y)
% xlabel('$$i$$','Interpreter','latex')
% ylabel('$$t$$','Interpreter','latex')
% title('$$V$$ spatiotemporal colour map','Interpreter','latex')
% subplot(2,1,2)
% Z = X(mask,N+1:2*N);
% imagesc(Z)
% xlabel('$$i$$','Interpreter','latex')
% ylabel('$$t$$','Interpreter','latex')
% title('$$H$$ spatiotemporal colour map','Interpreter','latex')

dev=std(Y(:,1:N)); % Y veg Z herbivore
flag1=0;
flag2=0;

if any(dev<0.01)
    flag1=1;
end
if any(dev>0.01)
    flag2=1;
end


if flag1==1 && flag2 ==0
    state=1; % CD all zero SD
    disp('CD');
end

if flag1==1 && flag2 ==1
    zeromask=find(dev>sqrt(eps));
    ACsearch=range(dev(zeromask));
    if ACsearch>0.1*max(dev)
        state=4;
        disp('AC + Death');
    else
        state=2; % CSOD mixed zero sd and nonzero sd
        disp('CSOD');
    end
end

if flag1==0 && flag2 ==1
    state=3; % Sync oscillation all nonzero sd
    disp('Sync');
end

end

    

