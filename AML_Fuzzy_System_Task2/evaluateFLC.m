function [out1, out2] = evaluateFLC(flc, temp, light)
% Compute crisp outputs for one input pair

% Fuzzification
mu_in1 = zeros(1, length(flc.inputs(1).mf));
mu_in2 = zeros(1, length(flc.inputs(2).mf));
for i = 1:length(mu_in1)
    mu_in1(i) = evalMF(temp, flc.inputs(1).mf{i});
end
for i = 1:length(mu_in2)
    mu_in2(i) = evalMF(light, flc.inputs(2).mf{i});
end

% Rule firing strengths
nRules = size(flc.rules,1);
firing = zeros(nRules,1);
for r = 1:nRules
    rule = flc.rules(r,:);
    ant1 = rule(1); ant2 = rule(2);
    if ant1 == -1
        w1 = 1;
    else
        w1 = mu_in1(ant1);
    end
    if ant2 == -1
        w2 = 1;
    else
        w2 = mu_in2(ant2);
    end
    firing(r) = flc.andMethod(w1, w2);
end

% Aggregate outputs separately for each output variable
out_crisp = zeros(1,2);
for outIdx = 1:2
    % For each output, collect fuzzy sets and their firing strengths
    outMFs = flc.outputs(outIdx).mf;
    outRange = flc.outputs(outIdx).range;

    % For each rule that assigns this output
    y_aggregated = [];
    w_aggregated = [];
    for r = 1:nRules
        outMFidx = flc.rules(r, outIdx+2);  % +2 because columns: in1,in2,out1,out2
        if outMFidx ~= -1 && firing(r) > 0
            % Implication: clip membership function at firing strength
            mf = outMFs{outMFidx};
            y_aggregated = [y_aggregated, outRange];
            w_aggregated = [w_aggregated, firing(r) * ones(size(outRange))];
        end
    end
    if isempty(y_aggregated)
        out_crisp(outIdx) = (outRange(1)+outRange(2))/2;
        continue;
    end
    % For simplicity, take the max of all clipped MFs at each sample point
    % Better: compute union (max) of the clipped trapezoids.
    nPoints = 201;
    y = linspace(outRange(1), outRange(2), nPoints);
    agg = zeros(size(y));
    for r = 1:nRules
        outMFidx = flc.rules(r, outIdx+2);
        if outMFidx ~= -1 && firing(r) > 0
            mf = outMFs{outMFidx};
            mu_y = arrayfun(@(yi) evalMF(yi, mf), y);
            clipped = min(firing(r), mu_y);
            agg = flc.aggMethod(agg, clipped);
        end
    end
    % Defuzzify (centroid)
    if sum(agg) == 0
        out_crisp(outIdx) = (outRange(1)+outRange(2))/2;
    else
        out_crisp(outIdx) = sum(y .* agg) / sum(agg);
    end
end
out1 = out_crisp(1);
out2 = out_crisp(2);
end