function dydt = CSTRfun(t,y,par) 
% A->B
% Define parameters
k1=par(1);
k2=par(2);
k3=par(3);
k4=par(4);
V=par(5);
Q=par(6);
Ca=par(7);
Cd=par(8);
% Define variables
A=y(1,1);
B=y(2,1);
D=y(3,1);
I=y(4,1);
P=y(5,1);
S=y(6,1);
%rate
r=[k1*A k2*A k3*I*D k4*D*B^2];
% Define the function outputs (derivatives)
dAdt=(Q/V*(Ca-A))-r(1)-r(2);%-k1*A-k2*A;
dBdt=(Q/V*(-B))+r(2)-r(4);%k2*A-k4*B; 
dDdt=(Q/V*(Cd-D))-r(3)-r(4);%-k3*D-k4*D;
dIdt=(Q/V*(-I))+r(1)-r(3);%k1*A-k3*I*D;
dPdt=(Q/V*(-P))+r(3);%k3*I*D;
dSdt=(Q/V*(-S))+r(4);%k4*D*B^2;
dydt = [dAdt dBdt dDdt dIdt dPdt dSdt]';




