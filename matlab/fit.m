function A = fit(X, y)
% A = fit(X, y)
%
% Fits a linear predictor A according to inputs X and outputs y
% X has one instance per column
% y has one instance per column
% A is a line array

% AX = y
% A = y * X^(-1)

[lin col] = size(X);

X = [X; ones(1, col)];
A = y * pinv(X);

