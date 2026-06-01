function [best_fitness, conv_hist] = pso_optimizer(func, D)
% Standard Particle Swarm Optimization
% Input:  func - objective function handle
%         D    - number of dimensions
% Output: best_fitness - best value found
%         conv_hist    - convergence history (iterations)

% PSO parameters
numParticles = 50;
maxIter = 200;
w = 0.729;       % inertia weight
c1 = 1.496;      % cognitive coefficient
c2 = 1.496;      % social coefficient

% Bounds
lb = -100 * ones(1, D);
ub = 100 * ones(1, D);

% Initialize swarm
X = lb + (ub - lb) .* rand(numParticles, D);   % positions
V = zeros(numParticles, D);                    % velocities

% Evaluate initial positions
fitness = zeros(numParticles, 1);
for i = 1:numParticles
    fitness(i) = func(X(i, :));
end

% Personal bests
pBest = X;
pBestVal = fitness;

% Global best
[gBestVal, gBestIdx] = min(pBestVal);
gBest = pBest(gBestIdx, :);

conv_hist = zeros(maxIter, 1);

for iter = 1:maxIter
    % Update velocity and position
    for i = 1:numParticles
        r1 = rand(1, D);
        r2 = rand(1, D);

        V(i, :) = w * V(i, :) + c1 * r1 .* (pBest(i, :) - X(i, :)) + c2 * r2 .* (gBest - X(i, :));
        X(i, :) = X(i, :) + V(i, :);

        % Clamp position to bounds
        X(i, :) = min(max(X(i, :), lb), ub);

        % Evaluate new position
        newVal = func(X(i, :));

        % Update personal best
        if newVal < pBestVal(i)
            pBestVal(i) = newVal;
            pBest(i, :) = X(i, :);
        end
    end

    % Update global best
    [currBest, currIdx] = min(pBestVal);
    if currBest < gBestVal
        gBestVal = currBest;
        gBest = pBest(currIdx, :);
    end

    conv_hist(iter) = gBestVal;
end

best_fitness = gBestVal;
end