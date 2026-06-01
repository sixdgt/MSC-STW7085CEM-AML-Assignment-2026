%% run_benchmark.m
% Part 3: Compare GA and PSO on CEC2005 functions (F1 and F6)
% Dimensions: D = 2 and D = 10
% Runs: 15 independent trials per algorithm per function per dimension

clc; clear; close all;

% Configuration
funcs = {@cec05_f1, @cec05_f6};
funcNames = {'F1: Shifted Sphere', 'F6: Shifted Rosenbrock'};
dimensions = [2, 10];
nRuns = 15;

% Store results
results = struct();

for fIdx = 1:length(funcs)
    for dIdx = 1:length(dimensions)
        D = dimensions(dIdx);
        func = funcs{fIdx};
        
        fprintf('\n========================================\n');
        fprintf('Function: %s, D = %d\n', funcNames{fIdx}, D);
        fprintf('========================================\n');
        
        % --- GA results ---
        fprintf('\n--- Running GA (%d trials) ---\n', nRuns);
        gaBest = zeros(nRuns, 1);
        gaConvHist = [];
        for run = 1:nRuns
            [fval, hist] = ga_optimizer(func, D);
            gaBest(run) = fval;
            if run == nRuns
                gaConvHist = hist;   % store convergence of last run
            end
            fprintf('  GA run %2d: best = %.6e\n', run, fval);
        end
        
        % --- PSO results ---
        fprintf('\n--- Running PSO (%d trials) ---\n', nRuns);
        psoBest = zeros(nRuns, 1);
        psoConvHist = [];
        for run = 1:nRuns
            [fval, hist] = pso_optimizer(func, D);
            psoBest(run) = fval;
            if run == nRuns
                psoConvHist = hist;
            end
            fprintf('  PSO run %2d: best = %.6e\n', run, fval);
        end
        
        % --- Statistical Summary ---
        results(fIdx).(sprintf('D%d', D)).GA.best = min(gaBest);
        results(fIdx).(sprintf('D%d', D)).GA.worst = max(gaBest);
        results(fIdx).(sprintf('D%d', D)).GA.mean = mean(gaBest);
        results(fIdx).(sprintf('D%d', D)).GA.std = std(gaBest);
        results(fIdx).(sprintf('D%d', D)).GA.all = gaBest;
        
        results(fIdx).(sprintf('D%d', D)).PSO.best = min(psoBest);
        results(fIdx).(sprintf('D%d', D)).PSO.worst = max(psoBest);
        results(fIdx).(sprintf('D%d', D)).PSO.mean = mean(psoBest);
        results(fIdx).(sprintf('D%d', D)).PSO.std = std(psoBest);
        results(fIdx).(sprintf('D%d', D)).PSO.all = psoBest;
        
        % --- Print Summary Table ---
        fprintf('\n---------- SUMMARY for %s, D=%d ----------\n', funcNames{fIdx}, D);
        fprintf('%-10s | %12s | %12s | %12s | %12s\n', ...
                'Algorithm', 'Best', 'Worst', 'Mean', 'Std Dev');
        fprintf('%-10s | %12.6e | %12.6e | %12.6e | %12.6e\n', ...
                'GA', results(fIdx).(sprintf('D%d', D)).GA.best, ...
                results(fIdx).(sprintf('D%d', D)).GA.worst, ...
                results(fIdx).(sprintf('D%d', D)).GA.mean, ...
                results(fIdx).(sprintf('D%d', D)).GA.std);
        fprintf('%-10s | %12.6e | %12.6e | %12.6e | %12.6e\n', ...
                'PSO', results(fIdx).(sprintf('D%d', D)).PSO.best, ...
                results(fIdx).(sprintf('D%d', D)).PSO.worst, ...
                results(fIdx).(sprintf('D%d', D)).PSO.mean, ...
                results(fIdx).(sprintf('D%d', D)).PSO.std);
        
        % --- Convergence Plot for last run ---
        figure;
        if contains(funcNames{fIdx}, 'Sphere')
            % Use linear plot for negative values
            plot(gaConvHist, 'b-', 'LineWidth', 2); hold on;
            plot(psoConvHist, 'r--', 'LineWidth', 2);
            ylabel('Best Fitness');
        else
            % Use semilogy for positive values (Rosenbrock)
            semilogy(gaConvHist, 'b-', 'LineWidth', 2); hold on;
            semilogy(psoConvHist, 'r--', 'LineWidth', 2);
            ylabel('Best Fitness (log scale)');
        end
        xlabel('Iteration');
        legend('GA', 'PSO', 'Location', 'northeast');
        title(sprintf('Convergence: %s, D = %d', funcNames{fIdx}, D));
        grid on;
        drawnow;
    end
end

fprintf('\n========================================\n');
fprintf('All experiments completed.\n');
fprintf('========================================\n');

% Display final results table
fprintf('\n=== FINAL RESULTS TABLE ===\n');
fprintf('%-20s | %-5s | %-6s | %-12s | %-12s | %-12s\n', ...
        'Function', 'D', 'Metric', 'GA', 'PSO', 'Better?');
fprintf('%s\n', repmat('-', 80, 1));

metrics = {'Best', 'Mean', 'Std'};
for fIdx = 1:length(funcs)
    for dIdx = 1:length(dimensions)
        D = dimensions(dIdx);
        res = results(fIdx).(sprintf('D%d', D));
        for mIdx = 1:length(metrics)
            metric = metrics{mIdx};
            if strcmp(metric, 'Best')
                gaVal = res.GA.best;
                psoVal = res.PSO.best;
            elseif strcmp(metric, 'Mean')
                gaVal = res.GA.mean;
                psoVal = res.PSO.mean;
            else % Std
                gaVal = res.GA.std;
                psoVal = res.PSO.std;
            end
            better = '';
            if ~strcmp(metric, 'Std')
                if psoVal < gaVal
                    better = 'PSO';
                elseif gaVal < psoVal
                    better = 'GA';
                else
                    better = 'Tie';
                end
            end
            fprintf('%-20s | %-5d | %-6s | %-12.6e | %-12.6e | %-10s\n', ...
                    funcNames{fIdx}, D, metric, gaVal, psoVal, better);
        end
        fprintf('%s\n', repmat('-', 80, 1));
    end
end