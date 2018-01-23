function networkPlot(A, x)
%Plots the network described by adjacency matrix A and node values x 
%A: nxn  for n nodes
%x: Nxn  for N timesteps
%Currently assumes undirected ring structure

r = 0.1; 
n = size(x,2);
ang = 2*pi*(0:n-1)' ./ n; %calculate angle of each node (on ring)
%\theta_i = 2pi*i / n for i = 0,...,n-1
xy = [r.*cos(ang), r.*sin(ang)]; %get (x,y) coords
%plot edges
hold on
for j = 1:n
    for i = 1:j %only need to consider triangular part of symmetric matrix
        if A(i,j) ~= 0 
           plot([xy(i, 1) xy(j,1)], [xy(i, 2) xy(j, 2)], 'b-'); %plot edge between points i and j
        end
    end
end


for i = 1:100:(size(x,1))
    if i > 1
        delete(temp) %remove previous nodes
    end
    temp = scatter(xy(:,1), xy(:,2), 10000*x(i,:), 'filled', 'b'); %plot nodes with size corresponding to population x
    pause(0.1)
end


end