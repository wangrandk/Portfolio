clear all
clc
load ('NMRdata9.mat')
%9.1
%p=[1.29;27;0.32]; det pr�ves for at se om funktion virker 
f = @(p) fitfun(t,y,p);

%9.2
a=fminsearch(f, [0.1 0.1 0.1]);
tt=linspace (0, 0.4, 300)';
yy=a(1)*exp(-a(2)*tt)+a(3);
plot(t,y,'o',tt,yy,'-','linewidth',2)
title('ulin�rer data-fitting')
xlabel('tid [s]');
%lambda 27.33, a1=1.45557 og a3=0.2150