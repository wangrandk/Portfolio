%%3.1 opstilles en funktion
function [t,backslash,inverse,x]=beregningstider(n)
A=rand(n)/5;
b=rand(n,1);
tic
backslash=A\b;%den første metod backlash
t(1)=toc;
tic
inverse = inv(A)*b; %2.invers 
t(2)=toc;
tic
D=det(A);
C=A;
x=zeros(n,1); %cramers metod 
for i=1:n
    C(:,i)=b;
    x(i)=det(C)/D;
    C(:,i)=A(:,i);
end
t(3)=toc;
end



