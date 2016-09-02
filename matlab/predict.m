function y = predict(X, A)
% y = predict(X, A)
%
% A is a previously-fitted linear predictor
% X is a set of inputs (one instance per column)
% y is a set of predicted outputs

% y = X*A
[lin col] = size(X);
X = [X; ones(1,col)];

y = X * A

