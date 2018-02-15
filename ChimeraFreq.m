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

% solve the ode

[T, X] = ode45(@(t, x) RMoscillator(x, params, A, @linear_coupling), 0:6000, x0);

%%%%%%%%%%%% organise data %%%%%%%%%%

mask = T > 5000 & T <= 6000;

V=X(:,1:N);
H=X(:,N+1:2*N);

T=T(mask);
V=V(mask,:);


%%%%%%%%%%%%% classification %%%%%%%%%% 

maxpeak=3;
peakstol=0.01;

M=size(V,1);
w=fft(V);

fshift=(-(M-1)/2:(M+1)/2-1)/range(T);
yshift= abs(fftshift(w,1));

yshift=yshift(fshift>0,:);
fshift=fshift(fshift>0);

% figure()
% plot(fshift,yshift);

freqvec=zeros(N,maxpeak);

for i = 1:N
    
    [pks,locs] = findpeaks(yshift(:,i));
    pks=pks(pks>peakstol);
    locs=locs(pks>peakstol);
    
    [pks,I] = sort(pks,'descend');
    
    peaks=fshift(locs);
    peaks=peaks(I);
    
    if length(peaks)>maxpeak-1
        freqvec(i,:)=peaks(1:maxpeak);
    else
        freqvec(i,1:length(peaks))=peaks(1:length(peaks));
    end
        
    
end


if sum(std(freqvec))<10^(-4)
    freqvec2=freqvec(1,:);
    if any(freqvec2)==0
        state=1;
        disp('CD')
    else 
        state=2;
        disp('sync')
    end
elseif sum(std(freqvec(any(freqvec,2),:)))<10^(-4)
    state=3;
    disp('CSOD')
else
    state=4;
    disp('Non-Sync')
end


% figure()
% plot(V)
    
end







