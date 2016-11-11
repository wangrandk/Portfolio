close all; clear all; clc;
f = @(x) 1.5*x^6 + 2*x^2 - 12*x;
%4.1
[x,fx,ea,iter] = goldmin(f,0,2,0.1);
%det viser sig 14 itterationer og løsning som er minimum er x=0.9792
%4.2
tol=10^(-12);
%phi er definiret i side 187
phi=(1+sqrt(5))/2;
xl=0;
xu=2;
k=(log(phi-1)+log(tol/(phi*xl-phi*xu-2*xl+2*xu)))/log(phi-1);
%det laves solve fra ligning og k isoleres vha maple, der ved vælges lower
%og upper bund 0,2 og så findes k som 57.8601 = 58 
%4.3% funktionen fminbnd er en indbygget matlab funktion, der finder location
% og value for min. xmin er location og fval er value.
option43= optimset('TolX',1e-12,'display','iter');
%det kan gøres på forskellige måder, x_new resultat og xmin resultat er det
%samme=0.9788
x_new = fminbnd(f,0,2,option43);
[xmin, fval, exitflag, output] = fminbnd(f,xl,xu,option43);
% som det ses via at brug matlab funktion, laves kun 11 iterationer til at
% beregne men goldmin bruges 58. Dette skyldes at 
%fminbnd benytter sig af den langsomme robuste golden section search metode
%og derudover den hurtigere parabolske interpolation.


