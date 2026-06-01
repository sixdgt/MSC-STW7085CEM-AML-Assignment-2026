function flc_out = setOutputMFParams(flc, chrom)
flc_out = flc;
idx = 1;
for outIdx = 1:2
    for mfIdx = 1:length(flc.outputs(outIdx).mf)
        mf = flc.outputs(outIdx).mf{mfIdx};
        n = length(mf.params);
        newParams = chrom(idx:idx+n-1);
        % Ensure correct order for trapezoidal (a<=b<=c<=d) and triangular (a<=b<=c)
        if strcmp(mf.type, 'trapmf')
            newParams = sort(newParams);
        elseif strcmp(mf.type, 'trimf')
            newParams = sort(newParams);
        end
        mf.params = newParams;
        flc_out.outputs(outIdx).mf{mfIdx} = mf;
        idx = idx + n;
    end
end
end