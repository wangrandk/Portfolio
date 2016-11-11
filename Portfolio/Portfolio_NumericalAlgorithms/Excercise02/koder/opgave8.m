clear all
clc
load ('NMRdata8.mat')
lambda1=27;
lambda2=8;
%8.1 Det laves en matrice Z der består delen i phi matricen i opgaveteskten
%(ligning(15.11) bogen

%8.2 ligning(15.10
Z=[exp(-lambda1*t) exp(-lambda2*t) ones(50,1)];
%a=Z\y
A = (Z'*Z)\(Z'*y);
%a1=1.2949 a2= 1.8967  a3=0.3222

%8.3
a1=1.2949; a2= 1.8967;  a3=0.3222;
phi=a1*exp(-lambda1*t)+a2*exp(-lambda2*t)+a3;
plot(t,phi)
xlabel('tid [t]');ylabel('vand-inhold [y]')

%8.4
[afgivelse,afpunkt]=max(abs(phi-y));
%afgivelse=0.1956 og afgivelse_punkt=29

%ekstra i følge side 369
%the sum of the squars
%Sr=sum((y-Z*A).^2);
%the coeifficient of determination
%r2=1-Sr/sum((y-mean(y)).^2);
%the standard error
%syx=sqrt(Sr/(length(phi)-length(A)));

