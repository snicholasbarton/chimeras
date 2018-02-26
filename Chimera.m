function state = Chimera(P,sigma,coupling)
%Chimera A function that takes a given P, sigma and determines what state
%the resulting set of V nodes is in
% INPUTS:
%   P: the connectivity of the graph parameter
%   sigma: the coupling strenght parameter
% OUTPUTS:
%   state: an integer representing what state the system is in

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
Q = 1/P;

params = [r K alpha B beta m sigma P Q]; % vectorise the parameters

%%%%%%%%%%%% initial conditions %%%%%%%%%%
load('x0') %fixed random initial conditions

%%%%%%%%%%% solve the ode %%%%%%%%%%%%%%
options = odeset('RelTol',1e-9,'AbsTol',1e-9);
[T, X] = ode45(@(t, x) RMoscillator(x, params, A, coupling), 0:6000, x0);

%%%%%%%%%%%%% classify what state the system is in %%%%%%%%%%
state = classify(T,X,A);
% an enumeration of the different states is in classify.m source code!



end
