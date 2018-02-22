N=100;
P=11;

A=makeAdjMat(N,'ring',P);

T = 500:0.01:600;

X2 = sin(3*pi*T)';
X1 = sin(2*pi*T)';

V=ones(length(T),N);


V(:,7) = X2;
V(:,79) = X2;
V(:,40) = X1;

V(:,90) = X2;

amplvec=range(V);

I=1:N;
I=I(amplvec>0.01);

V=V(:,amplvec>0.01);
I
ChimeraFreq2(V,T,A,I)
