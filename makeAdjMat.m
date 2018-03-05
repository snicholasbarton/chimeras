function Adj = makeAdjMat(N, type, param)

% ADJMAT Creates an adjancency matrix for an undirected graph
% N: Number of nodes
% type: Type of topology, currently supports:
%       - ring
%       - sqlattice (square lattice)
%       - random
%       - line
%       - torus (how is this different from lattice???)
% param: in the case - ring : P = param : Coupling range
%        in the case - random : e = param : Number of random edges
%        in the case - line : ???

if N == 1
    Adj = 1;
else

    switch type
        case 'ring'

            if exist('param','var') == 0
                disp('Coupling range not provided, using P = 1')
                P = 1;
            elseif param>N/2
                disp('Coupling range too big, using P = N/2')
                P=floor(N/2);
            else
                P=floor(param);
            end
            
            if P == N/2
                Adj = toeplitz([0,ones(1,N-1)]);
            else
                Adj = toeplitz([0,ones(1,P),zeros(1,N-2*P-1),ones(1,P)]);
            end

        % TODO: ADD P DEPENDENCY
        case 'sqlattice'
            rN = sqrt(N);
            if (mod(rN,1) ~= 0 || N < 9) %check inputs
                disp('N must be a square number and at least 9 for sqlattice topology')
                disp('Using N = 9')
                N=9;
            end
            
            Adj = zeros(N,N);
            
            for i = 1:N %contruct matrix row by row                
               for j = (i+1):N %only construct upper right half (symmetrix matrix)
                   
                   if abs(j-i) == rN %connect vertical neighbours
                       Adj(i,j) = 1;
                       Adj(j,i) = 1;
                   elseif abs(j-i) == 1 %connect horizontal neighbours
                       if ~(mod(i,rN) == 0 && mod(j, rN) == 1) %ensure edge nodes are not connected across the lattice
                           Adj(i,j) = 1;                          %WARNING: this logic will not work for non-symmetric A
                           Adj(j,i) = 1;
                       end
                   end
                   
               end
            end
           
        % TO-DO: MAKE THE BELOW CODE PERIODIC    
        case 'torus'
            rN = sqrt(N);
            if (mod(rN,1) ~= 0 || N < 9) %check inputs
                disp('N must be a square number and at least 9 for sqlattice topology')
                disp('Using N = 9')
                N=9;
            end
            Adj = zeros(N,N);
            
            for i = 1:N %contruct matrix row by row
                for j = (i+1):N %only construct upper right half (symmetrix matrix)
                    
                    if abs(j-i) == rN %connect vertical neighbours
                        Adj(i,j) = 1;
                        Adj(j,i) = 1;
                    elseif abs(j-i) == 1 %connect horizontal neighbours
                        if ~(mod(i,rN) == 0 && mod(j, rN) == 1) %ensure edge nodes are not connected across the lattice
                            Adj(i,j) = 1;                          %WARNING: this logic will not work for non-symmetric A
                            Adj(j,i) = 1;
                        end
                    end
                    
                end
            end
            
            
        case 'line'
            
            if exist('param','var') == 0
                disp('Coupling range not provided, using P = 1')
                P = 1;
            elseif param>N/2
                disp('Coupling range too big, using P = N/2')
                P=floor(N/2);
            else
                P=floor(param);
            end
            
            if P == N/2
                Adj = toeplitz([0,ones(1,P),zeros(1,N-P-1)]);
            else
                Adj = toeplitz([0,ones(1,P),zeros(1,N-2*P-1),zeros(1,P)]);
            end
            
            
            
        case 'random'
            
            
            if exist('param','var') == 0
                disp('Number of edges not provided, using e = N')
                e = N;
            elseif param>sum(1:N-1)
                disp('Number of edges too big, using maximum e=')
                disp(sum(1:N-1))
                e = sum(1:N-1);
            elseif param<N-1
                disp('Number of edges too small, using minimum e=N-1=')
                disp(N-1)
                e = N-1;
            else
                e=param;
            end
                
            Adj=zeros(N,N);

            % construct edge list with all possible edges (not including repeated
            % ones as we are considering a non directed graph
            E = zeros(sum(1:N-1),2);
            for i = 1:N-1
                E((i-1)*N-sum(1:i-1)+1:i*N-sum(1:i),1)=ones(N-i,1)*i;
                E((i-1)*N-sum(1:i-1)+1:i*N-sum(1:i),2)=i+1:N;
            end

            
            nodes_not=1:N; % set of non-connected nodes
            
            %initialise
            node0=randi(N); 
            nodes_con=node0; 
            nodes_not=nodes_not(nodes_not ~= node0); 
            
            
            % connect all nodes at least once
            for i3= 1:N-1
               
                % select random node1 from non connected set and connect it
                % to node0
                
                node1=nodes_not(randi(length(nodes_not)));
                
                % update lists
                nodes_con(i3+1)=node1; 
                nodes_not=nodes_not(nodes_not ~= node1);
                
                % update adj matrix with edge
                Adj(node0,node1)=1;
                Adj(node1,node0)=1;
                
                % remove edge from edgelist
                E1 = E == node0 | E == node1 ;
                E1=sum(E1,2);
                E(E1 == 2,:)=[];
                
                % select a random node0 from the set of connected nodes
                node0=nodes_con(randi(length(nodes_con)));
                
            end

            % proceed by adding random edges
           
            for i2 = 1:e-N+1              
                ind = randi(size(E,1)); % select random index for edge list

                % set entry in adj matrix to 1 for edge E(randindex)
                Adj(E(ind,1),E(ind,2))=1;
                Adj(E(ind,2),E(ind,1))=1;

                E(ind,:)=[]; % remove edge from edgelist           
            end
                 
    end
        
end
end