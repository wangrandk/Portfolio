%Script for the simulation of the model
clc;
close all;
clear all;

%Defining Model Parameters
k1=1.25e-2;%min^-1
k2=7.5e-3;%min^-1
k3=0.265;%m^3 mole^-1 min^-1
k4=0.15;%m^6 mole^-2 min^-1
Vol=800;%L 
q=1.92;%L/min 
Cain=12;%mol/m^3 
Cdin=20;%mol/m^3
par=[k1 k2 k3 k4 Vol q Cain Cdin];

%Solving the model
options=odeset('RelTol',1e-4);
[t,y]=ode15s(@odesolver,[0 2000],[1.252 6.52 3.131 0 0 0],options,par);
%The initial conditions vector contains values with the units mol/m^3

%Plotting the results
xL='time(min)';
figure(1)
subplot(3,2,1)
plot(t,y(:,1),'r-','LineWidth',1.5)
grid on;
ylabel('A[mol/min]','FontSize',10);
xlabel(xL,'FontSize',10);

subplot(3,2,2)
plot(t,y(:,3),'r-','LineWidth',1.5)
grid on;
ylabel('B[mol/min]','FontSize',10);
xlabel(xL,'FontSize',10);


subplot(3,2,3)
plot(t,y(:,4),'r-','LineWidth',1.5)
grid on;
ylabel('D[mol/min]','FontSize',10);
xlabel(xL,'FontSize',10);

subplot(3,2,4)
plot(t,y(:,2),'r-','LineWidth',1.5)
grid on;
ylabel('I[mol/min]','FontSize',10);
xlabel(xL,'FontSize',10);
grid on;

subplot(3,2,5)
plot(t,y(:,5),'r-','LineWidth',1.5)
grid on;
ylabel('P[mol/min]','FontSize',10);
xlabel(xL,'FontSize',10);

subplot(3,2,6)
plot(t,y(:,6),'r-','LineWidth',1.5)
grid on;
ylabel('S[mol/min]','FontSize',10);
xlabel(xL,'FontSize',10);

h=gcf;
saveas(h,'Ex3_Plot.jpg');
