clear all 
close all 
clc
%s�jler skrue m�tri s�m og r�kker anders birgite og carl og deres v�gt som
%B
%2.1
A=[3 12 10;12 0 20;0 2 30];
B=[72.3; 99.5;56.6];

%2.2
x=A\B;
fprintf('V�gten for en skrue er: % .2f g \n', x(1));
fprintf('V�gten for en m�trik er: % .2f g \n', x(2));
fprintf('V�gten for et s�m er: % .2f g \n', x(2));
%2.3
%ny v�gt inds�ttes
B1=[73.3;98.4;57.1];
x1=A\B1;
fprintf('V�gten for en skrue er: % .2f g \n', x(1));
fprintf('V�gten for en m�trik er: % .2f g \n', x(2));
fprintf('V�gten for et s�m er: % .2f g \n', x(2));
%2.4
fejl=abs(x-x1);
[maxfejl, maxindex]=max(fejl);
%den viser maxfejl=0.1081 og maxindex=som viser den f�rste v�rdi i vektoren
%har den st�rste fejl
