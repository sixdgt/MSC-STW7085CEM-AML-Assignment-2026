function mu = evalMF(x, mf)
% Evaluate membership value for given MF structure
switch mf.type
    case 'trimf'
        a = mf.params(1); b = mf.params(2); c = mf.params(3);
        if x <= a, mu = 0;
        elseif x <= b, mu = (x - a)/(b - a);
        elseif x <= c, mu = (c - x)/(c - b);
        else mu = 0;
        end
    case 'trapmf'
        a = mf.params(1); b = mf.params(2); c = mf.params(3); d = mf.params(4);
        if x <= a, mu = 0;
        elseif x <= b, mu = (x - a)/(b - a);
        elseif x <= c, mu = 1;
        elseif x <= d, mu = (d - x)/(d - c);
        else mu = 0;
        end
    otherwise
        error('Unknown MF type');
end
end