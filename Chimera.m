function state = Chimera(P,sigma)
% function that classifies the state of system of 100 nodes with ring topology for
% different sigmas and coupling coefficients

% state 1: CD       - all nodes constant / no oscillation
% state 2: CSOD     - 
% state 3: Sync     - all nodes are oscillating
% state 4: AC+Death -

N = 100; % number of nodes in the graph


%%%%%%%%%%%% topology of the network %%%%%%%%%%

A=makeAdjMat(N,'ring',P);

%%%%%%%%%%%% parameter values %%%%%%%%%%%%%%%%%

r = 0.5; % growth rate of prey
K = 0.5; % carrying capacity of prey
alpha = 1; % predation rate
B = 0.16; % half-saturation constant
beta = 0.5; % prey efficiency
m = 0.2; % mortality of prey

params = [r K alpha B beta m sigma P]; % vectorise the parameters

%%%%%%%%%%%% initial conditions %%%%%%%%%%

% x0 = rand(2*N,1)*0.5; % random initial conditions

% load('x0') %fixed random initial conditions

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

[T, X] = ode45(@(t, x) RMoscillator(x, params, A, @linear_coupling), 0:6000, x0);

%%%%%%%%%%%% organise data %%%%%%%%%%

mask = T > 5000 & T <= 6000;

V=X(:,1:N);
H=X(:,N+1:2*N);

dev=std(V(mask,:)); 

%%%%%%%%%%%%% classification %%%%%%%%%% 


%find states

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


end

    

