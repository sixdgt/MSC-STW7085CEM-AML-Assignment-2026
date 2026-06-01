%% main_FLC_Assignment_NoToolbox.m
clear; clc; close all;

%% ======================= PART 1 =======================
fprintf('=== PART 1: Fuzzy Logic Controller Design (Custom Code) ===\n');

% Create the FLC structure
flc = createFLC_custom();

% Test with sample inputs
temp = 16;   % Cold
light = 800; % Very bright
[hc, dim] = evaluateFLC(flc, temp, light);
fprintf('Sample: Temp=%.1f°C, Light=%.0f Lux -> Heater/Cooler=%.1f%%, Dimmer=%.1f%%\n', ...
    temp, light, hc, dim);

% Plot membership functions
plotMFs_custom(flc);

% Generate control surface
plotControlSurface_custom(flc);

%% ======================= PART 2 =======================
fprintf('\n=== PART 2: GA Optimization of FLC ===\n');

% Generate synthetic dataset (500 samples)
rng(42);
N_data = 500;
X_data = [rand(N_data,1)*20 + 15, rand(N_data,1)*1000];
Y_data = evaluateFLC_batch(flc, X_data);
% Add 5% Gaussian noise to make the optimization meaningful
noise = randn(size(Y_data)) * 1;   % 1% noise
Y_data = Y_data + noise;
% Clip outputs to valid range [0,100]
Y_data = min(max(Y_data, 0), 100);

% GA parameters
ga_params = struct('popSize',20, 'maxGen',30, 'cprob',0.8, 'mprob',0.15, ...
                   'tournSize',3, 'elite',2);

% Run GA
[bestChrom, bestFitness, history] = optimizeFLC_GA_custom(flc, X_data, Y_data, ga_params);

% Update FLC with optimized parameters
flc_opt = setOutputMFParams(flc, bestChrom);

% Compare performance
Y_orig = evaluateFLC_batch(flc, X_data);
Y_opt  = evaluateFLC_batch(flc_opt, X_data);
mse_orig = mean((Y_data(:,1)-Y_orig(:,1)).^2 + (Y_data(:,2)-Y_orig(:,2)).^2);
mse_opt  = mean((Y_data(:,1)-Y_opt(:,1)).^2  + (Y_data(:,2)-Y_opt(:,2)).^2);
fprintf('MSE before GA: %.4f\n', mse_orig);
fprintf('MSE after GA : %.4f\n', mse_opt);
fprintf('Improvement   : %.2f%%\n', (1 - mse_opt/mse_orig)*100);

% Plot convergence
figure('Name','GA_Convergence');
plot(history.best, 'b-', 'LineWidth',2); hold on;
plot(history.mean, 'r--', 'LineWidth',1.5);
xlabel('Generation'); ylabel('MSE');
legend('Best','Mean'); title('GA Optimization Progress');
grid on;

fprintf('All done.\n');