% plot a bifurcation diagram over the parameters P and sigma
P_vec = 1:50; % the maximum dimension of the space 
sigma_vec = linspace(1,3.5,length(P_vec));

state = zeros(length(P_vec), length(sigma_vec));

for i = 1:length(P_vec)
    P = P_vec(i);
    for j = 1:length(sigma_vec)
        sigma = sigma_vec(j);
        % CHANGE YOUR COUPLING RULE HERE
        state(i,j) = Chimera(P,sigma,@linear_coupling);
    end
end

% CHANGE THE NAME OF THE FILE HERE TO THE NAME OF YOUR COUPLING
save('linear_bifurcation.mat','state')

% view the final bifurcation
imagesc(state)