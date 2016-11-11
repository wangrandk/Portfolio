clear all
clc
load ('barcode.mat')
%A1
sigma=1.15;
n=length(btilde);

for i=1:n;
    for j=1:n;
    if abs(i-j)<=10
        A(i,j)=(1/(sigma*sqrt(2*pi))*exp(-(i-j)^2/(2*sigma^2)));
    else
        A(i,j)=0;
    end
    end
end

 xtilde=A\btilde;
 figure()
 plot(btilde)
 figure()
 plot(xtilde)
 %btilde er rystende og xtilde når lyser fanger rigtigt
 
 %A2
 relativefejl=cond(A)*1.5*10^-4;
 %0.0512 som er større end 0.01
 %A3
 maksfejl=0.01/cond(A);
 %maksfejl er 2.929898250548337e-05
 
 %A4
 tic
 x = GaussNaive(A,btilde);
 t(1)=toc
 tic
 x1 =  GaussNaiveorig(A,btilde);
 t(2)=toc;
 % t1=0.05 s viser den tid for den nye funktion og t2=2.19 s viser for den
 % original
 
 %A5
%i alt 230*(n-1)+21*n=251n-230