%% Opgave C
clear all; close all; clc; format long;

%% C.1
g=9.82;
M=0.2;
k=1;
L0=0.1;
a=M/2*k;
t=0;
n=400;
dl=L0/n;
j=0:n;
diameter=0.1;
coils=25;


l=(j*dl);
y1 = l+a*g*((2*l)/L0 - l.^2/L0^2);% when t=0, the length of each of the y intervals with gravity
draw_slinky(t,y1,l,diameter,coils)
%% C.2
l=l';
y1=y1';
tspan=[0:0.01:0.5];
t1=0.1;
t2=0.25;
t3=0.5;

z0= [y1;0*y1]; %dy/dt,d2y/dt2

[t,z] = ode45(@(t,z0) odefunC(t,z0,l,dl,M,k,L0,g), tspan, z0); %[0 0]: y(0)=0,dy/dt(0)=0 
yi=z(:,1:401);%1:401<-dy, 401:end<-d2y/dt2

figure 
draw_slinky(t1,yi(t==t1,:),l,diameter,coils)
figure
draw_slinky(t2,yi(t==t2,:),l,diameter,coils)
figure
draw_slinky(t3,yi(t==t3,:),l,diameter,coils)

%% C.3

y0=l; %form 22
z0=[y0;0*y0];
tspan2=[0:0.01:1.5];
[t,zi] = ode45(@(t,z0) odefunC3(t,z0,l,dl,M,k,L0,g), tspan2, z0);

t11=0;
t44=1;
t22=0.5;
t33=1.5;

y2=zi(:,1:401);

figure 
draw_slinky(t11,y2(t==t11,:),l,diameter,coils);hold on

draw_slinky(t22,y2(t==t22,:),l,diameter,coils);hold on

draw_slinky(t33,y2(t==t33,:),l,diameter,coils);hold on

draw_slinky(t44,y2(t==t44,:),l,diameter,coils)













