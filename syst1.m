%define system
function dxdt = syst1(t,x,A,alpha,beta,r,K,B,P,sigma,m)
    n=size(A,1);
    
    V=x(1:n);
    
    H=x(n+1:2*n);
    
    
    dVdt = r.*V.*(1-V./K)-alpha*H.*V./(V+B);
    dHdt = H.*(alpha*beta*V./(V+B)-m) + sigma/(2*P).*(A*H - diag(H)*A*ones(n,1));
    
    dxdt=[dVdt;dHdt];
end