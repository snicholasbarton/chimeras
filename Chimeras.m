clear

n=100;
P=4;
%-------------------adjacency matrix 

A=toeplitz([0,ones(1,P),zeros(1,n-P-2),1]); 


%-------------------initial conditions

%x0 = eye(n*2,1)*rand(1,1)*0.5; %only on initial node
%x0(n+1)=rand(1,1)*0.5;

x0 = rand(2*n,1)*0.5;

%--------------------time vector
T = linspace(0,6000,60000);

%syst1(t,x,A,alpha,beta,r,K,B,P,sigma,m)
[T,X]=ode45(@(t,x) syst1(t,x,A,1,0.5,0.5,0.5,0.16,1,1.7,0.2),T,x0);

%--------------------plot

figure(1)

V=sum(X(:,1:n),2);
H=sum(X(:,n+1:2*n),2);
plot(V(5000:6000),H(5000:6000)) %phase plane

%plot(T,sum(X(:,1:n),2)) %sum of nodes

%axis([5000 5150 0.1 0.2])