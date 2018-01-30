clear
% set up the different size networks to test
% some these are bigger than what we'll use in the study
N = 2.^[5 6 7 8 9 10];

% arrays to store the timed results
matvec_mult = zeros(5,length(N));
sparse_matvec_mult = zeros(5,length(N));
summation = zeros(5,length(N));

for i = 1:length(N)
    n = N(i);
    H = ones(1,n)';
    P = floor(linspace(1,n/2,5));
    for j = 1:length(P)
        p = P(j);
        A = toeplitz([0,ones(1,p),zeros(1,n-p-2),1]);
        tic;
        A*H;
        matvec_mult(j,i) = toc;
        A = sparse(A);
        tic;
        A*H;
        sparse_matvec_mult(j,i) = toc;
        tic;
        % do the summation
        h = 0;
        for k = 1:2*p % mock sum using the same number of terms
           h = h + 2*(H(k) - H(1)); 
        end
        summation(j,i) = toc;
    end
end

% to check results we make the following subtractions:
matvecmult_summation = matvec_mult - summation
sparse_matvecmult_summation = sparse_matvec_mult - summation
dense_vs_sparse = matvec_mult - sparse_matvec_mult
% where sum > 0, 'right' method is faster (and vice versa for sum < 0)
% to interpret the results: L-to-R is increasing N, T-to-B is increasing P
