function [error, fittedcurve] = objFunc(params, t, A)
k1 = params(1);
k2 = params(2);
k3 = 0.265;
k4 = 0.15;

V = 0.8;
Q = 0.032*60;
Ca = 0.012*1000;
Cd = 0.02*1000;

par=[k1 k2 k3 k4 V Q Ca Cd];
%Solve the model
options=odeset('RelTol',1e-4);
[t,fittedcurve]=ode15s(@CSTRfun,[0 2000],[1.252 3.131 0 6.52 0 0],options,par);
% calculate error vector
errorvector = fittedcurve(1) - A;
% measure of total error
error = sum(errorvector .^ 2);

