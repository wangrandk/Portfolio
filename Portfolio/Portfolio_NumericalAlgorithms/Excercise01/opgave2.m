close all; clear all; clc;
%opgave 2.1
f = @(x) x^2 -0.7*x -0.3;
 df = @(x) 2*x -0.7;
 [root,ea,iter,xi] = newtraph(f,df,2,0,6);
 %root=1 og xi viser tabel under de 6 itterationer
 Ei=abs(xi-root);
 Ei1=[];
 for i=1:length(Ei)-1
 Ei1 = [Ei1;(Ei(1+i)/(Ei(i)^2))];
 end
 Ei1;
 %opgave 2.2
 option1 = optimset('TolX',1e-14,'display','iter');
root1=fzero02601(f,[0 2],option1);
 %hvis Ei+1 går i mod konstant så er det kvadratisk konvegens ligesom
 %2.1(Ei1 i programmet). det ses i 2.2 at den går som sinus/noget i den
 %stil kurve derfor er det IKKE kvadratisk konvergens.

 
 
 
 
 
 