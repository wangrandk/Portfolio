clear all
clc
load ('deblur.mat')
figure();
imagesc(B), axis image off, colormap gray
%7.1 X = A\B/A; chol funktiion bruges til factorisering (regnes på
%halvdelen da den er symetsik)
U=chol(A);
X = U\(U'\B)/U/U';
x=U\(U'\B);
figure();
imagesc(X), axis image off, colormap gray
figure();
x1 = A\B/A;
imagesc(x1), axis image off, colormap gray
%Det ses at billedet er blevet tydeligere og x1 billede er samme som X

%7.2
Ef=0.02*norm(B,'fro')/cond(A)^2;
%svaret er 3.171242345634412e+03

%7.3
[n,n]=size(A);
E=rand(n);
syms k 
scale=solve(norm(E,'fro')*k==Ef,k);
E=E*eval(scale);
Bn=B+E;
Xt=U\(U'\Bn);  
fejl=norm (Xt-x,'fro')/norm(x,'fro');
%relative fejl er på 1.2907e-04 som er mindre end 0.02
