function [ fx ] = Fun( x )
% Functions navn er sat sum FUN med variabel: x and
% output parameter som fx. x er et tal mellem 0.1 and 0.9
roden = fzero( @ (y) (sin(y) - x), [0 pi/2]);
fx = roden*x^2+sqrt(x)-1;
end

