function Adj = makeAdjMat(N, type, param)

% ADJMAT Create an adjancency matrix for an undirected graph
% N: Number of nodes
% type: Type of topology, currently supports:
%       - ring
%       - sqlattice (square lattice)
%       - random
% param: in the case - ring : P = param : Coupling range
%        in the case - random : e = param : Number of random edges

if N == 1
    Adj = 1;
else

    switch type
        case 'ring'

            if exist('param','var') == 0
                disp('Coupling range not provided, using P = 1')
                P = 1;
            else
                P=param;
            end

            A = toeplitz([0,ones(1,P),zeros(1,N-2*P-1),ones(1,P)]); % adjacency matrix
            Adj = A;

        case 'sqlattice'
            rN = sqrt(N);
            if (mod(rN,1) ~= 1 || N < 9) %check inputs
                disp('N must be a square number and at least 9 for sqlattice topology')
                disp('Using N = 9')
            end
            A = zeros(N,N);
            
            for i = 1:N %contruct matrix row by row                
               for j = (i+1):N %only construct upper right half (symmetrix matrix)
                   
                   if abs(j-i) == rN %connect vertical neighbours
                       A(i,j) = 1;
                       A(j,i) = 1;
                   elseif abs(j-i) == 1 %connect horizontal neighbours
                       if ~(mod(i,rN) == 0 && mod(j, rN) == 1) %ensure edge nodes are not connected across the lattice
                           A(i,j) = 1;                          %WARNING: this logic will not work for non-symmetric A
                           A(j,i) = 1;
                       end
                   end
                   
               end
            end
            
            Adj = A; %construct symmetric matrix
            
        
        case 'random'
            
            
            if exist('param','var') == 0
                disp('Number of edges not provided, using e = N')
                e = N;
            else
                e=param;
            end
            
            if e>sum(1:N-1)
                disp('maximum number of edges is, using e=')
                disp(sum(1:N-1))
                
                e = sum(1:N-1);
            end
            
                
            A=zeros(N,N);

            % construct edge list with all possible edges (not including repeated
            % ones are we are considering a non directed graph
            E = zeros(sum(1:N-1),2);
            for i = 1:N-1
                E((i-1)*N-sum(1:i-1)+1:i*N-sum(1:i),1)=ones(N-i,1)*i;
                E((i-1)*N-sum(1:i-1)+1:i*N-sum(1:i),2)=i+1:N;
            end


            for i2 = 1:e              
                ind = randi(size(E,1)); % select random index for edge list

                % set entry in adj matrix to 1 for edge E(randindex)
                A(E(ind,1),E(ind,2))=1;
                A(E(ind,2),E(ind,1))=1;

                E(ind,:)=[]; %delete edge from edgelist           
            end
            
            Adj=A;
                 
    end
        
end
end