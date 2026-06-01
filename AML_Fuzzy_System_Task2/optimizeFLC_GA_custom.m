function [bestChrom, bestFitness, history] = optimizeFLC_GA_custom(flc, X, Y, params)
% Real-coded GA to tune output membership function parameters

% Extract initial parameters and bounds
[LB, UB, initParams] = getOutputMFParams(flc);
nParams = length(initParams);
popSize = params.popSize;
maxGen = params.maxGen;
cprob = params.cprob;
mprob = params.mprob;
tournSize = params.tournSize;
elite = params.elite;

% Initialize population
pop = rand(popSize, nParams) .* (UB - LB) + LB;
fitness = zeros(popSize, 1);
history.best = zeros(maxGen, 1);
history.mean = zeros(maxGen, 1);

fprintf('GA running for %d generations, popSize=%d, nParams=%d\n', maxGen, popSize, nParams);

for gen = 1:maxGen
    % Evaluate fitness
    for i = 1:popSize
        flc_tmp = setOutputMFParams(flc, pop(i,:));
        Y_pred = evaluateFLC_batch(flc_tmp, X);
        % MSE over both outputs
        err = mean( (Y(:,1)-Y_pred(:,1)).^2 + (Y(:,2)-Y_pred(:,2)).^2 );
        fitness(i) = err;
    end
    
    [bestFit, idx] = min(fitness);
    history.best(gen) = bestFit;
    history.mean(gen) = mean(fitness);
    bestChrom = pop(idx,:);
    
    if mod(gen, maxGen/5) == 0 || gen == maxGen
        fprintf('Gen %d: best fitness = %.4f\n', gen, bestFit);
    end
    
    % --- Selection (Tournament) ---
    newPop = zeros(size(pop));
    % Elitism: keep best individual(s)
    [~, sortedIdx] = sort(fitness);
    for e = 1:min(elite, popSize)
        newPop(e,:) = pop(sortedIdx(e),:);
    end
    
    % Fill remaining slots
    for i = elite+1:popSize
        % Tournament selection for parent1
        idx1 = randi(popSize, [tournSize,1]);
        [~, best1] = min(fitness(idx1));
        parent1 = pop(idx1(best1),:);
        % Tournament for parent2
        idx2 = randi(popSize, [tournSize,1]);
        [~, best2] = min(fitness(idx2));
        parent2 = pop(idx2(best2),:);
        
        % Crossover (arithmetic)
        if rand < cprob
            alpha = rand; % uniform blending
            child1 = alpha * parent1 + (1-alpha) * parent2;
            child2 = alpha * parent2 + (1-alpha) * parent1;
        else
            child1 = parent1;
            child2 = parent2;
        end
        
        % Mutation (Gaussian, with bounds)
        if rand < mprob
            child1 = child1 + randn(1,nParams) .* (UB-LB)*0.1;
            child1 = min(max(child1, LB), UB);
        end
        if rand < mprob
            child2 = child2 + randn(1,nParams) .* (UB-LB)*0.1;
            child2 = min(max(child2, LB), UB);
        end
        
        newPop(i,:) = child1;
        if i+1 <= popSize
            newPop(i+1,:) = child2;
        end
    end
    pop = newPop;
end

% Assign output arguments (ensure they exist)
bestFitness = history.best(end);
% bestChrom already assigned inside loop (last generation's best)
fprintf('GA finished. Best fitness = %.4f\n', bestFitness);
end