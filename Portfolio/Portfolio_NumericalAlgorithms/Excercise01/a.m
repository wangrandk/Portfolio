clear all 
close all 
clc
%1.1 husk der skal v�re figure() f�r fplot
fx=@(x) cos(13*x)+1.4/cosh(x)+0.5;
figure()
fplot(fx,[3,4]); hold on;
%finder hver af r�dderne ud fra hvordan det plottes
%det tilf�jes en tollerance 10^-6 
option1 = optimset('TolX',1e-6);
root1=fzero02601(fx,[3 3.1],option1);
root2=fzero02601(fx,[3.11 3.25],option1);
root3=fzero02601(fx,[3.5 3.6],option1);
root4=fzero02601(fx,[3.61 3.8],option1);
plot(root1,0,'o');plot(root2,0,'o');plot(root3,0,'o');plot(root4,0,'o');
hold off;
%det gentages med en ny tolerance
figure()
fplot(fx,[3,4]); hold on;
option2 = optimset('TolX',1e-3);
root12=fzero02601(fx,[3 3.1],option2);
root22=fzero02601(fx,[3.11 3.25],option2);
root32=fzero02601(fx,[3.5 3.6],option2);
root42=fzero02601(fx,[3.61 3.8],option2);
%De 8 r�dder skal samles 
TolX6 = [root1, root2, root3, root4];
TolX3 = [root12, root22, root32, root42];
plot(root12,0,'o');plot(root22,0,'o');plot(root32,0,'o');plot(root42,0,'o');
hold off;
figure()
plot(TolX6,TolX3)
%%
%1.2
%root121 = fzero02601(fx,[3.3 3.8],option1);
%det virker ikke da alle x v�rdier har positiv y v�rdier men de skal ogs�
%have negativ v�rdier, -> ingen r�dder
root122 = fzero02601(fx,[3.1 3.8],option1);
%den virker da y v�rdien er henholdvis har negativ og positiv v�rdier.
%funktion fzero finder kun 1 af 3 r�dder. 
root123 = fzero02601(fx,[3.1 3.705],option1);
%virker det igen for de valgte x v�rdier er der b�de negativ og positiv y
%v�rdier.
%%
%1.3
figure()
fplot(fx,[0,2.5]);hold on;
fplot(@(x) 0,[0,2.5]);
option3 = optimset('TolX',1e-9,'display','iter');
root131=fzero02601(fx,[2 2.2],option3);
% Bisection formel som (5.6) s. 138 i bogen bruges.
% F�rst s�ttes xu og xi:
x_u=2.2;
x_l=2;
%det bestemmes delta x
Deltax=x_u-x_l;
%den maksimale fejl defineres;
E_a=10^(-9);
 % Antal iterationer for bisection:
 n=log2(Deltax/E_a);
 %det ses at i root131 der er brug for 10 itteration, trods i bisection
 %skal det v�re 27.5454...=28 iterationer.
 %%

 




