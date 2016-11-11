function [t,y] = heunode(dydt,tspan,y0,h)
% [t,y] = Heunode(dydt,tspan,y0,h):
%   uses Heun's method to integrate an ODE
% input:
%   dydt = name of the M-file that evaluates the ODE 
%   tspan = [ti, tf] where ti and tf = initial and
%           final values of independent variable
%   y0 = initial value of dependent variable
%   h = step size
% output:
%   t = vector of independent variable
%   y = vector of solution for dependent variable

ti = tspan(1);
tf = tspan(2);
t = (ti:h:tf)';
n = length(t);
% if necessary, add an additional value of t
% so that range goes from t = ti to tf
if t(n)<tf  
  t(n+1) = tf;
  n = n+1;
end
y = y0*ones(n,1); %preallocate y to improve efficiency
for i = 1:n-1  %implement Heun's method
    var = feval(dydt,t(i),y(i));
  yi0 = y(i) + var*(t(i+1)-t(i));
  y(i+1) = y(i) + (var+feval(dydt,t(i+1),yi0))*(t(i+1)-t(i))/2;
end

