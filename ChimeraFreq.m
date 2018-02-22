function state = ChimeraFreq(P,sigma)
% function that classifies the state of system of 100 nodes with ring topology for
% different sigmas and coupling coefficients

% state 1: CD      
% state 2: Sync     
% state 3: CSOD    
% state 4: Non-Sync 

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

%%%%%%%%%%%% solve the ODE %%%%%%%%%%

opts = odeset('RelTol',1e-9,'AbsTol',1e-9);
[T, X] = ode45(@(t, x) RMoscillator(x, params, A, @linear_coupling), 0:6000, x0, opts);

%%%%%%%%%%%% organise data %%%%%%%%%%

mask = T > 5000 & T <= 6000;

V=X(:,1:N);

T=T(mask);
V=V(mask,:);
Vc=V-mean(V);

%%%%%%%%%%%%% find dominating frequencies %%%%%%%%%% 

Vc=V-mean(V); % center all the vegetation at the nodes

maxpeak=3; % number of peaks to take into account
peakstol=0.01; % min height of peak to take into account 

M=size(Vc,1); 
w=fft(Vc); % take fast fourier of Vc at all nodes in time

fshift=(-(M-1)/2:(M+1)/2-1)/range(T); % create frequency axis (horizontal)
yshift= abs(fftshift(w,1)); % shift fft vector 

% take only positive frequencies
yshift=yshift(fshift>0,:); 
fshift=fshift(fshift>0);

% create matrix of (N x maxpeak) that will contain the dominating
% frequencies

freqvec=zeros(N,maxpeak); % allocate 

for i = 1:N
    
    [pks,locs] = findpeaks(yshift(:,i)); %find the peaks (frequencies)
    
    % cancel noise / keep only high intensity peaks
    locs=locs(pks>peakstol); % index of peaks
    pks=pks(pks>peakstol); % intensity of peaks
    freqs=fshift(locs); %frequency at peaks
    
    % sort frequencies in order of intensity
    [pks,I] = sort(pks,'descend');
    freqs=freqs(I);
    
    % take only maxpeak number of frequencies and store in freqvec
    if length(freqs)>maxpeak-1
        freqvec(i,:)=freqs(1:maxpeak);
    else
        freqvec(i,1:length(freqs))=freqs(1:length(freqs));
    end
        
end

%%%%%%%%%%%%% CLASSIFICATION %%%%%%%%%% 

if sum(std(freqvec))<10^(-4) % if all nodes have the same frequencies
    freqvec2=freqvec(1,:); % consider only first node
    
    if any(freqvec2)==0 % if the frequencies are all 0 
        state=1; 
        disp('CD')
        
        % check steady states
        s=V(1,:);
        if max(s) < 0.01 
            disp('all steady states are dead')
        elseif min(s) > 0.01 
            disp('all steady states are alive')
        else
            disp('steady states are mixed') 
        end
    
    else 
        state=2;
        disp('sync')
    end

    
elseif sum(std(freqvec(any(freqvec,2),:)))<10^(-4)
    state=3;
    disp('CSOD')
    
    s=V(1,any(freqvec,2)==0); % take first time vec of steady states nodes
    if max(s) < 0.01 % if all the nodes are 0 
        disp('all steady states are dead')
    elseif min(s) > 0.01 % if none of the nodes are 0
        disp('all steady states are alive')
    else % if some are zero and some are not
        disp('steady states are mixed') 
    end
    
elseif 1
    freqvec2=freqvec(any(freqvec,2)==0,1); % get rid of the steady states
    
    
    [n, bin] = histc(freqvec2, uniquetol(A,1e-4));
    multiplevec = find(n > 1);
    for i =1:length(multiplevec)
        multiple=multiplevec(i);
        index = find(ismember(bin, multiple));
        
        if any(A(index, index))==1
            break
            disp('frequency chimera')
        end
    end
        
    
    [uniqueFreq, IA, IC] = uniquetol(freqvec2,1e-4);
    
    
    
    
    
    
    
    
    
    
    
else % if the frequencies are not syncronised
    state=4;
    disp('Non-Sync')
end

%%%%%%%%%%%%%%%%% PLOTS %%%%%%%%%%%%%%%%%%%%

% % plot frequencies
% figure()
% plot(fshift,yshift);
% xlabel('frequency','Interpreter','latex')
% ylabel('intensity','Interpreter','latex')
% title('Frequencies of $H$','Interpreter','latex')
% 
% % plot vegetation 
% figure()
% plot(V)
% xlabel('timestep','Interpreter','latex')
% ylabel('$V$ vegetation for $100$ nodes','Interpreter','latex')
% title('Behaviour of $V$ at each node','Interpreter','latex')
end







