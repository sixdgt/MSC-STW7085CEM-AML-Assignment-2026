function [best_fitness, conv_hist] = ga_optimizer(func, D)
% Real-valued GA for function minimization

% GA parameters
popSize = 50;
maxGen = 200;
cprob = 0.8;      % crossover probability
mprob = 0.1;      % mutation probability
tournSize = 3;    % tournament size
elite = 2;        % number of elites to preserve

% Bounds
lb = -100 * ones(1, D);
ub = 100 * ones(1, D);

% Initialize population (random within bounds)
pop = rand(popSize, D) .* (ub - lb) + lb;
fitness = zeros(popSize, 1);
conv_hist = zeros(maxGen, 1);

for gen = 1:maxGen
    % Evaluate fitness
    for i = 1:popSize
        fitness(i) = func(pop(i, :));
    end

    % Sort population by fitness
    [fitness, idx] = sort(fitness);
    pop = pop(idx, :);

    % Store best fitness
    best_fitness = fitness(1);
    conv_hist(gen) = best_fitness;

    % Create new population (elitism + selection, crossover, mutation)
    newPop = zeros(popSize, D);
    newPop(1:elite, :) = pop(1:elite, :);  % elitism

    for i = elite+1:2:popSize
        % Tournament selection (parent1)
        candidates = randi(popSize, [tournSize, 1]);
        [~, idx1] = min(fitness(candidates));
        parent1 = pop(candidates(idx1), :);

        % Tournament selection (parent2)
        candidates = randi(popSize, [tournSize, 1]);
        [~, idx2] = min(fitness(candidates));
        parent2 = pop(candidates(idx2), :);

        % Crossover (blend crossover)
        if rand < cprob
            alpha = rand;   % blend factor
            child1 = alpha * parent1 + (1-alpha) * parent2;
            child2 = alpha * parent2 + (1-alpha) * parent1;
        else
            child1 = parent1;
            child2 = parent2;
        end

        % Mutation (Gaussian with decreasing amplitude)
        if rand < mprob
            sigma = (0.1 * (ub - lb)) * (1 - gen/maxGen);
            child1 = child1 + randn(1, D) .* sigma;
        end
        if rand < mprob
            sigma = (0.1 * (ub - lb)) * (1 - gen/maxGen);
            child2 = child2 + randn(1, D) .* sigma;
        end

        % Clamp to bounds
        child1 = min(max(child1, lb), ub);
        child2 = min(max(child2, lb), ub);

        % Add to new population
        newPop(i, :) = child1;
        if i+1 <= popSize
            newPop(i+1, :) = child2;
        end
    end

    pop = newPop;
end
end