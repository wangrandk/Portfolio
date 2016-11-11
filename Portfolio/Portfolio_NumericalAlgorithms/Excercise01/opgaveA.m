close all; clear all; clc;
%% A .1

% definerer konstanter
L=80;
w=1;
S=100;

% definerer vores funktion (nulpunktsproblem), samles ligning nr 7 på
% højreside og sættes =0 så har vi:
f=@(T)  T/w.*sinh((L.*w)./(2.*T))-(1./2).*S;
%A2
% plotter for at finde startgæt
plot1 = linspace(10,40);
plot(plot1,f(plot1),plot1,zeros(size(plot1,2)))
%ved at plotte det ses at funktion skærer x-aksen i [32,36] .

%A3
optionA= optimset('TolX',1e-3,'display','iter');
%indføres start gæt
x0=[32,36];
%fzero defineres 
T = fzero(f,x0,optionA);
%nu findes den rigtige tollerance udfra den given 
Tolx= 0.01/(2*abs(T-1));
%det ses at der skal bruges 3 itterationer til at finde T=33.8182
%A4
x=L/2;
H_max=(T/w)*(cosh(w*x/T)-1);
