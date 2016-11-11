clear all 
close all 
clc
%6.1
A=[3 12 10;12 0 20;0 2 30];
b=[72.3; 99.5;56.6];
x=A\b;
b1=[73.3;98.4;57.1];
x1=A\b1;
%Den reletiv forstyrrelse af højreside
H=norm (b-b1)/norm(b1);
%Den reletive forsryrrelse af løsning
F=norm (x-x1)/norm(x1);

%6.2
Cond=cond(A);
%øvre grønser, ganges cond med den reletive forstyrrelse af højreside
granser=Cond*H;
