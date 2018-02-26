% plot a bifurcation diagram over the parameters P and sigma
P_vec = 1:50; % the maximum dimension of the space 
sigma_vec = 0:0.1:7;

state = zeros(length(P_vec), length(sigma_vec));

for P = P_vec
    for j = 1:length(sigma_vec)
        sigma = sigma_vec(j);
        % CHANGE YOUR COUPLING RULE HERE
        state(P,j) = Chimera(P,sigma,@linear_coupling);
    end
    save('linear_bifurcation.mat','state')
end

% CHANGE THE NAME OF THE FILE HERE TO THE NAME OF YOUR COUPLING
save('linear_bifurcation.mat','state')

% view the final bifurcation
figure()
imagesc(state)
xlabel('P')
ylabel('sigma')

