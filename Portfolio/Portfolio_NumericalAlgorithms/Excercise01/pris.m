function [ P ] = pris( S, omega, B, L )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% *%A.1*
%startgæt
x0 = 30;
%definerer vores funktion
f = @(T)  T/omega.*sinh((L.*omega)./(2.*T))-(1./2).*S;
%definerer options til fzero. 
%starter med et gæt på tolerancen = 1e-5
option1=optimset('TolX',1e-5);
%bruger f zero til at finde T
T = fzero(f,x0,option1);
%definerer x =1/2L
x = L/2;
h_max = (T/omega)*(cosh(omega*x/T)-1);
clear 'x'
for i = 1:13
x(i) = (i-1)*L/12-L/2;
V (i) = B - h_max + (T/omega)*(cosh(omega*x(i)/T)-1);
end
P = 10*S*omega + 10000*(1-omega)^2 + sum(V);
end
