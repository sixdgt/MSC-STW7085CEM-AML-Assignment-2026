function y = cec05_f1(x)
D = size(x, 2);
if nargin == 1
    o = zeros(1, D);   % Shift vector
    bias = -450;       % Function bias
    z = x - o;
    y = sum(z.^2, 2) + bias;
else
    error('Invalid input');
end
end