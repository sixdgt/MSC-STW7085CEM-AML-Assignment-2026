function Y = evaluateFLC_batch(flc, X)
% X: Nx2 matrix [temp, light]
N = size(X,1);
Y = zeros(N,2);
for i = 1:N
    [Y(i,1), Y(i,2)] = evaluateFLC(flc, X(i,1), X(i,2));
end
end