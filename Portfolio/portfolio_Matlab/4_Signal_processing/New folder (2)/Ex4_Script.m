%The script is used to obtain the values of k1 and k2 for the given system
%based on the given component A concentration data. It is done by using a
%the objective function that is minimized using an inbuilt function
%'fminsearch'

clear all;
close all;
clc;

% Data points
load data_ex4;
tspan=t;
yd(:,1)=A_data;
yd(:,2)=B_data;
yd(:,3)=D_data;
yd(:,4)=I_data;
yd(:,5)=P_data;
yd(:,6)=S_data;

% Initial Conditions for ODEs
x0=[1.252 6.52 3.131 0 0 0];

% Initial Parameter guess
k0=[0.01 0.00625];

%Minimizing the difference between the curve and the model
options=optimset('display','iter','MaxFunEvals',1000);

%Running the estimation
estimation=fminsearch(@objective,k0,options,tspan,x0,yd(:,1));
k1=estimation(1);
k2=estimation(2);
kk = [k1 k2]
display(k1);
display(k2);

%Solving the model
[t,y]=ode15s(@odesolver2,tspan,x0,options,kk);


%Plotting the results
figure(1)
subplot(3,2,1)
plot(tspan(1:50:end),y((1:50:end),1),'r--','LineWidth',2);
hold on
plot(tspan(1:50:end),yd((1:50:end),1),'bo','LineWidth',2);
hold off
grid on
xlabel('Time (min)','FontSize',12);
ylabel('Ca (mole/m3)','FontSize',12);

subplot(3,2,2)
plot(tspan(1:50:end),y((1:50:end),3),'r--','LineWidth',2);
hold on
plot(tspan(1:50:end),yd((1:50:end),2),'bo','LineWidth',2);
hold off
grid on
xlabel('Time (min)','FontSize',12);
ylabel('Cb (mole/m3)','FontSize',12);

subplot(3,2,3)
plot(tspan(1:50:end),y((1:50:end),4),'r--','LineWidth',2);
hold on
plot(tspan(1:50:end),yd((1:50:end),3),'bo','LineWidth',2);
hold off
grid on
xlabel('Time (s)','FontSize',12);
ylabel('Cd (mole/m3)','FontSize',12);

subplot(3,2,4)
plot(tspan(1:50:end),y((1:50:end),2),'r--','LineWidth',2);
hold on
plot(tspan(1:50:end),yd((1:50:end),4),'bo','LineWidth',2);
hold off
grid on
xlabel('Time (min)','FontSize',12);
ylabel('Ci (mole/m3)','FontSize',12);

subplot(3,2,5)
plot(tspan(1:50:end),y((1:50:end),5),'r--','LineWidth',2);
hold on
plot(tspan(1:50:end),yd((1:50:end),5),'bo','LineWidth',2);
hold off
grid on
xlabel('Time (min)','FontSize',12);
ylabel('Cp (mole/m3)','FontSize',12);

subplot(3,2,6)
plot(tspan(1:50:end),y((1:50:end),6),'r--','LineWidth',2);
hold on
plot(tspan(1:50:end),yd((1:50:end),6),'bo','LineWidth',2);
hold off
grid on
xlabel('Time (s)','FontSize',12);
ylabel('Cs (mole/m3)','FontSize',12);


h=gcf;
saveas(h,'Ex4_Plot.jpg');