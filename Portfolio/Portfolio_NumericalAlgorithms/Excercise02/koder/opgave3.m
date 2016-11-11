clear all 
close all 
clc
%det er lavet en funktion hvilken skal vælges en n for at kunne beregne .
[t_100,backlash_100,inverse_100,x_100]=beregningstider(100);
sort(t_100);
%alle de 3 metoder skal give samme resultat ved at vælge n=tal

%3.2 x repræsenter cram ogt for tiden
[t_100,backslash_100,inverse_100,x_100]=beregningstider(100);
[t_200,backslash_200,inverse_200,x_200]=beregningstider(200);
[t_400,backslash_400,inverse_400,x_400]=beregningstider(400);
[t_800,backslash_800,inverse_800,x_800]=beregningstider(800);
A = [t_100;t_200;t_400;t_800];
T = array2table(A,'VariableName',{'backlash' 'inverse' 'Crame'});
save T
save T.txt A -ascii
%det kommer ud som en T.txt fil som backlash inverse og cramer i 3 søjler 