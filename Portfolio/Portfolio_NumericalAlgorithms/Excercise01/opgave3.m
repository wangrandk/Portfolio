close all; clear all; clc;
f = @(x) asin(x)*x^2+sqrt(x)-1; % 0.1<=x<=0.9
%3.1 de to funktioner beregnes med random x og ses at være ens
xrandom=0.45;
t1 = fzero(@(y) (sin(y)-xrandom) , [0 pi/2]);
t2=asin(xrandom);
%det ses funktion er defineret mellem 0.1 og 0.9 dvs fzero ikke kan finde,
%nogle værdier hvis x antages >1. Desuden kan x antages hellere ikke mindre
%end 0 da funktion ikke skær 1. aksen i det positiv interval mellem 0 pg pi/2. 
xplot = linspace(0,pi/2);
f1 = sin(xplot)-1;
f2 = sin(xplot);
figure(1)
plot(xplot,f1)
figure(2)
plot(xplot,f2)
fplot(f,[0.1 0.9])
%solves i maple for y i den første ligning og sættes i den anden.
%%
%3.2
answer = Fun(0.45);
%3.3

nulpunkt = c;
%rodden skal være tæt på 0.6



