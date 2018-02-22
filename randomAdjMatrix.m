function A = randomAdjMatrix(n,e)

if e>sum(1:n-1)
    display('maximum number of edges is') 
    display(sum(1:n-1))
else

    A=zeros(n,n);
    
    % construct edge list with all possible edges (not including repeated
    % ones are we are considering a non directed graph
    E = zeros(sum(1:n-1),2);
    for i = 1:n-1
        E((i-1)*n-sum(1:i-1)+1:i*n-sum(1:i),1)=ones(n-i,1)*i;
        E((i-1)*n-sum(1:i-1)+1:i*n-sum(1:i),2)=i+1:n;
    end
    
    
    for i2 = 1:e
        % select random index for edge list
        ind = randi(size(E,1));
        
        % set entry in adj matrix to 1 for edge E(randindex)
        A(E(ind,1),E(ind,2))=1;
        A(E(ind,2),E(ind,1))=1;
        
        %delete edge from edgelist
        E(ind,:)=[];
    end
end
end

    
   