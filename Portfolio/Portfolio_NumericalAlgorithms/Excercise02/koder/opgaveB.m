clear all
clc
%% B1
%startgæt sigma=3
sigma=3
for i=1:25
    if abs(i-1)<=10;
        b(i)=(1/(sigma*sqrt(2*pi)))* exp(-((i-10)^2)./2*(sigma).^2);
    else
       b(i)= 0;
    end
end

%% B2
load('kalibreringsdata.mat');
f=@ (sigma) fitfunb(I,Y,sigma);
sigma = fminbnd(f,0,10);
%sigma=0.73
A=(1/(sigma*sqrt(2*pi)))*exp(-((I-10).^2)/(2*(sigma)^2));
plot(I,Y,'O',I,A);
xlabel('Datapunkter'), ylabel('Målinger'), legend('Målte værdier','Fittet funkt')