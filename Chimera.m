function state = Chimera(P,sigma)
%CHIMERA_STATE
%Inputs:
%       P - Coupling range (for ring topology)
%       sigma - coupling strength
%Outputs the state of system after transient period

% build the network

N = 100; % number of nodes in the graph
A = makeAdjMat(N, 'ring', P);

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
options = odeset('RelTol',1e-9,'AbsTol',1e-9);
[T, X] = ode45(@(t, x) RMoscillator(x, params, A, @interaction_coupling), 0:5e-2:12000, x0, options);

%%%%%%%%%%%% organise data %%%%%%%%%%

mask = T > 10000 & T <= 12000;

V=X(:,1:N);
H=X(:,N+1:2*N);

dev=std(V(mask,:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RIGHT NOW ONLY CLASSIFYING V STATES %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% search for chaos
[Zv, ~] = find_chaos(X);
if ~ISEMPTY(Zv)
    has_any_V_chaos = 1;
end

% search for death
[Dv, ~] = find_death(X);
if ~ISEMPTY(Dv)
    has_any_V_death = 1;
end

% find and classify states

if length(Zv) == 100
    state=6;
    disp([P sigma])
    disp('All chaotic')
else
    if max(dev) < 0.01       % if all sd are 0 / all steady states
        if has_any_V_death
            state=1;
            disp([P sigma]);
            disp('CD');
        else % no death states, all non-zero steady
            state = 9;
            disp([P sigma]);
            disp('Steady non-death')
        end
    elseif min(dev) > 0.01   % if all sd are non-0 / no steady states
        % TODO: check if sync and chaos or what?
        if ~has_any_V_chaos % there is no chaos
            state = 3;
            disp([P sigma]);
            disp('Sync');
        else % some chaos, some non-steady states
            % are there sync states?
            % are there amplitude chimera states?
        end
        
    else                     % some non-steady & some steady states
        % CASES: DEATH + CHAOS , NON-ZERO STEADY + CHAOS,
        sdrange=range(dev(dev>sqrt(eps)));
        if ~has_any_V_chaos % the case where there's no chaos
            if sdrange>0.2*max(dev)
                state=4;
                disp([P sigma]);
                disp('AC+Death');
            else
                state=2;
                disp([P sigma]);
                disp('CSOD');
            end
        else % there is some chaos, some steady states, some nonsteady
            if has_any_V_death % there are death states
                if length(Zv) + length(Dv) == 100
                    state = 8;
                    disp([P sigma]);
                    disp('Chaos + death');
                elseif 0 % here we add the conditions from FFT
                    % are there synchronised oscillatory states?
                    % are they sync or amplitude chimera?
                else %no death states, no oscillating states --> chaos + non-zero steady
                    state = 7;
                    disp([P sigma]);
                    disp('Chaos + steadystate');
                end
            else % there are no death states
                if 1 % conditions from FFT
                    % foo
                else
                    % bar
                end
            end
        end
    end
end
imagesc(V)
end