clc; clear all; close force all ;
%loaddata;
r = csvread('Satelliteorbit.csv',0);
theta = csvread('Satelliteorbit.csv',0,1);
R_e=6378.1;
Y=[r';theta'];
g_o=9.81*(R_e/r(1));
v0=sqrt(r(1)*g_o);

A=[1 0 0;0 1 1;0 0 1]; %Time series analysis Report 5 Mihael Plut-s143159
C=[1 0 0;0 1 0];
RA=rank([C' (C*A)' (C*A^2)']) %checking observability
%sigma1
sigma1(1,1)=500^2;
sigma1(2,2)=0.005^2;
sigma1(3,3)=0.005^2
%sigma2
sigma2(1,1)=2000^2;
sigma2(2,2)=0.03^2
Xre=zeros(3,50)
%initialization
Xpre(1,1)=38000;
Xpre(2,1)=0;
Xpre(3,1)=0.03;
sigmaxx=[0 0 0;0 0 0; 0 0 0];
sigmayy=C*sigmaxx*C'+sigma2;
K=sigmaxx*C'*sigmayy^-1;
for i=1:50
Xre(:,i)=Xpre(:,i)+K*(Y(:,i)-C*Xpre(:,i));
Xpre(:,i+1)=A*Xre(:,i);
SIGMAxx=sigmaxx-K*sigmayy*K';
sigmaxx=A*SIGMAxx*A'+sigma1;
sigmayy=C*sigmaxx*C'+sigma2;
K1=K;
K=sigmaxx*C'*sigmayy^-1;
KK(i)=K1(1,1)/K(1,1);
end
%
 plot(Y(2,:),'r')
 hold on
 plot(Xre(2,:),'r')
%
% figure
%
% plot(Y(1,:),'')
% hold on
% plot(Xre(1,:),'r')
% figure
% plot(Xre(1,:),'r'); hold on;
% plot(Xre(2,:),'g'); hold on;
% plot(Xre(3,:),'g'); hold on;
% mean(Xre(3,:))
