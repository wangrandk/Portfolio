clear, clc, close all
clc
close all
load('data_ex4.mat')
t1 = decimate(t,50);
%initial value
k1 = 1.25e-2;
k2 = 7.5e-3;
params=[k1 k2];
options = optimset('display', 'iter','maxfunevals', 100000);
[x,fval] = fminsearch(@objFunc,params, options,t,A_data);

[o,p] = objFunc(params,t,A_data)
%Define model parameters
k11 = x(1)
k12 = x(2)

k3 = 0.265;
k4 = 0.15;
V = 800;
Q = 0.032*60;
Ca = 0.012*1000;
Cd = 0.02*1000;

par=[k11 k12 k3 k4 V Q Ca Cd];
%Solve the model
options=odeset('RelTol',1e-4);
[t,y]=ode15s(@CSTRfun,[0 2000],[1.252 3.131 0 6.52 0 0],options,par);%ABDIPS
%lower the sampling frequency

A_data =decimate(A_data,50);
B_data =decimate(B_data,50);
I_data =decimate(I_data,50);
D_data =decimate(D_data,50);
P_data =decimate(P_data,50);
S_data =decimate(S_data,50);

%Plot the results
figure
subplot(3,2,1);
plot(t,y(:,1),'r','LineWidth',1.5); hold on
plot(t1,A_data,'bo'); 
legend('[A]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[A] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,2)
plot(t,y(:,2),'r','LineWidth',1.5); hold on
plot(t1,B_data,'bo');
legend('[B]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[B] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,3)
plot(t,y(:,3),'r','LineWidth',1.5);hold on
plot(t1,D_data,'bo');
legend('[D]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[D] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,4)
plot(t,y(:,4),'r','LineWidth',1.5);hold on
plot(t1,I_data,'bo');
legend('[I]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[I] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,5)
plot(t,y(:,5),'r','LineWidth',1.5); hold on
plot(t1,P_data,'bo')
legend('[P]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[P] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,6)
plot(t,y(:,6),'r','LineWidth',1.5); hold on
plot(t1,S_data,'bo');
legend('[S]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[S] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

saveas(gcf,'CSTR.jpg')

