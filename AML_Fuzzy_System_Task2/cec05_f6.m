function y = cec05_f6(x)
% CEC2005 F6: Shifted Rosenbrock's Function
D = size(x, 2);
if nargin == 1
    o = zeros(1, D);   % Shift vector
    bias = 390;        % Function bias
    z = x - o;
    
    y = zeros(size(x,1), 1);
    for i = 1:size(x,1)
        sum_val = 0;
        for j = 1:(D-1)
            sum_val = sum_val + 100 * (z(i, j+1) - z(i, j)^2)^2 + (z(i, j) - 1)^2;
        end
        y(i) = sum_val + bias;
    end
else
    error('Invalid input');
end
end