N=100;
P=11;

A=makeAdjMat(N,'ring',P);

T = 500:0.01:600;

X2 = 3*sin(3*pi*T)';
X1 = sin(2*pi*T)';

V=ones(length(T),N);


V(:,7) = X2;
V(:,78) = X1;
V(:,40) = X2;

V(:,89) = X1;

% A1 = repmat(X1,1,50);
% A2 = repmat(X2,1,50);
% V = [A1,A2];
% V(:,7) = zeros(size(T,1),1);
% V(:,9) = ones(size(T,1),1);

amplvec=range(V);

I=1:N;
I=I(amplvec>0.01);

V=V(:,amplvec>0.01);

find_ac(V,A,I)