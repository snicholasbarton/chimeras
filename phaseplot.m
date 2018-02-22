% plot a bifurcation diagram over the parameters P and sigma
P_vec = 1:50; % the maximum dimension of the space 
sigma_vec = linspace(1,3.5,length(P_vec));
lP = length(P_vec);
lS = length(sigma_vec);
state = zeros(lP, lS);

for i = 1:lP
    P = P_vec(i);
    for j = 1:lS
        sigma = sigma_vec(j);
        % CHANGE YOUR COUPLING RULE HERE
        state(i,j) = Chimera(P,sigma,@linear_coupling);
    end
end

% CHANGE THE NAME OF THE FILE HERE TO THE NAME OF YOUR COUPLING
save('linear_bifurcation.mat','state')

% view the final bifurcation
imagesc(state)