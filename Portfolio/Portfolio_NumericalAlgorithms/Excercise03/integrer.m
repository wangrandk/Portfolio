function I = integrer(f,a,b,tol,I1)
m = (a+b)/2;
IL = simpson(f,a,m);
IR = simpson(f,m,b);
I2 = IL + IR;
I = I2 + (I2 - I1)/15;
if abs(I - I2) > tol
IL = integrer(f,a,m,tol/2,IL);
IR = integrer(f,m,b,tol/2,IR);
I = IL + IR;
end
I = quad(@(x) humps(x)+c,0,1,1e-1,true)
