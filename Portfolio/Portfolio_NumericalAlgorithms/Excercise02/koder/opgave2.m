clear all 
close all 
clc
%søjler skrue møtri søm og rækker anders birgite og carl og deres vægt som
%B
%2.1
A=[3 12 10;12 0 20;0 2 30];
B=[72.3; 99.5;56.6];

%2.2
x=A\B;
fprintf('Vægten for en skrue er: % .2f g \n', x(1));
fprintf('Vægten for en møtrik er: % .2f g \n', x(2));
fprintf('Vægten for et søm er: % .2f g \n', x(2));
%2.3
%ny vægt indsættes
B1=[73.3;98.4;57.1];
x1=A\B1;
fprintf('Vægten for en skrue er: % .2f g \n', x(1));
fprintf('Vægten for en møtrik er: % .2f g \n', x(2));
fprintf('Vægten for et søm er: % .2f g \n', x(2));
%2.4
fejl=abs(x-x1);
[maxfejl, maxindex]=max(fejl);
%den viser maxfejl=0.1081 og maxindex=som viser den første værdi i vektoren
%har den største fejl
