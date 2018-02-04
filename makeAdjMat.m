function Adj = makeAdjMat(N, type, P)
%ADJMAT Create an adjancency matrix for an undirected graph
% N: Number of nodes
% type: Type of topology, currently supports:
%       - ring
%       - sqlattice (square lattice)
% P: Coupling range (not relevant for all topologies)
if N == 1
    Adj = 1;
else

    switch type
        case 'ring'

            if ~exists(P)
                disp('Coupling range not provided, using P = 1')
                P = 1;
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
            
            
    end
        
end
end