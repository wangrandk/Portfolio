function [error, fittedcurve] = ls_fcn(params, x, y)
% define variables
A = params(1);
B = params(2);
% Fit curve
fittedcurve = A*x + B;
% calculate error vector
errorvector = fittedcurve - y;
% measure of total error
error = sum(errorvector .^ 2);
