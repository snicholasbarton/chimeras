function networkPlot(A, x)
%Plots the network described by adjacency matrix A and node values x 
%A: nxn
%x: nx1
%Currently assumes ring structure
r = 0.1;
n = size(x,1);
ang = 2*pi*(0:n-1)' ./ n; %calculate angle of each node (on ring)
%\theta_i = 2pi*i / n for i = 0,...,n-1

xy = [r.*cos(ang), r.*sin(ang)]; %get (x,y) coords

scatter(xy(:,1), xy(:,2), 10000*x, 'filled')

end