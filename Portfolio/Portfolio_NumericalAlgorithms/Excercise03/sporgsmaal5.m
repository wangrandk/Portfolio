%% spørgsmaal 5
clear all; close all; clc; clf;
%% 5.1

dx=0.1;

e=((7/dx^2)+(1/(2*dx)));

c=((7/dx^2)-(1/(2*dx)));

d=((-14/dx^2)-1);

N=(20/dx)+1;

A = full(gallery('tridiag',N-2,c,d,e));

x = (0:dx:20)'; 

b = -x(2:N-1); b(1) = b(1)-c*5; b(end) = b(end)-e*8;

%% 5.2

y=A\b;

plot(x,[5;y;8])

%% 5.3

tspan = [0, 20];

initial = [5, -0.8];

initial2=[5, -0.9];

[x1,y1] = ode45(@odefun, tspan, initial);

[x2,y2]=ode45(@odefun, tspan, initial2);

%NewTon linear interpolerer for at finde hældningen P.411
dydx0=-0.8+((-0.9+0.8)/(y2(end,1)-y1(end,1)))*(8-y1(end,1))

[x3,y3]=ode45(@odefun, tspan, [5,dydx0]);

figure
hold on
plot(x1,y1(:,1)) 
plot(x2,y2(:,1),'g')
plot(x3,y3(:,1),'r')
title('skudmetode')
xlabel('x')
ylabel('y')
legend('skud1','skud2','pletskud','Location','SouthWest')







