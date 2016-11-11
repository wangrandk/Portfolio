
format long
f = @(x) 1./(1+x);
for k = 0:3, disp(trap(f,0,1,2^k)), end

% I = integrer(f,a,b,tol,I1)