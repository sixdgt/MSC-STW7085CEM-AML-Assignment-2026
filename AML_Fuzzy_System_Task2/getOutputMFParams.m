function [LB, UB, init] = getOutputMFParams(flc)
% Flatten all output MF parameters and set bounds (±20% around initial values)
init = [];
for outIdx = 1:2
    for mfIdx = 1:length(flc.outputs(outIdx).mf)
        p = flc.outputs(outIdx).mf{mfIdx}.params;
        init = [init, p];
    end
end
% Bounds: allow 20% variation, but keep within output range [0,100]
LB = max(init * 0.8, 0);
UB = min(init * 1.2, 100);
end