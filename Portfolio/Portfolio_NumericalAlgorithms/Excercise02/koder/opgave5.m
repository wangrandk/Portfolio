clear all 
close all 
clc
% 5.1 vi bruger hess funktion med random med 5 tal. Det udtrykeks man skal
% have et element længere ned i søjlen for hvergang der skiftes 1 ned i
% rækken. det ses at vi får gaus ellemantion i resultat

A=hess(rand(5));
b=rand(5,1);
 Aug = [A b]; n = size(A,1); nb = n+1;
 for k = 1 : n-1
  factor = Aug(k+1,k)/Aug(k,k);
 Aug(k+2,k) = 0;
 Aug(k+2,k+1:nb) = Aug(k+2,k+1:nb) - factor*Aug(k,k+1:nb);
 end
 Aug;
 
 %5.2
 
 