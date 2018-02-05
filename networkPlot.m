% By Oliver Bamford
function networkPlot(A, x)
%Plots the network described by adjacency matrix A and node values x 
%A: nxn  for n nodes
%x: Nx2n  for N timesteps
%Currently assumes undirected ring structure

r = 0.1; 
n = size(A,1);
ang = 2*pi*(0:n-1)' ./ n; %calculate angle of each node (on ring)
%\theta_i = 2pi*i / n for i = 0,...,n-1
xy = [r.*cos(ang), r.*sin(ang)]; %get (x,y) coords
%plot edges
hold on
for j = 1:n
    for i = 1:j %only need to consider triangular part of symmetric matrix
        if A(i,j) ~= 0 
           plot([xy(i, 1) xy(j,1)], [xy(i, 2) xy(j, 2)], 'k-'); %plot edge between points i and j
        end
    end
end

for i = 1:10:(size(x,1))
    if i > 1
        delete(tempV) %remove previous nodes
        delete(tempH)
    end
    %plot nodes with size corresponding to vegetation population
    tempV = scatter(xy(1:n,1), xy(1:n,2), 10000*x(i,1:n), 'filled', 'g');
    %plot nodes with size corresponding to herbivore population
    tempH = scatter(xy(1:n,1), xy(1:n,2), 10000*x(i,(n+1):2*n), 'filled', 'b');
    
    pause(0.05)                                                
end
end