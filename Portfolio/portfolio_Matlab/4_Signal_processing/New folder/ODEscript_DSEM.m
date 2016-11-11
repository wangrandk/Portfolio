%%
clear, clc, close all
clc
close all

data= importdata('data_ex4.mat')
%%
%you still have to SPECIFY IN YOU R SCRIPT EACH VARIABLE THAT YOU ARE LOADING FROM THE FILE
time= data.t;
A_data = data.A_data;
B_data = data.B_data;
I_data = data.I_data;
D_data = data.D_data;
P_data = data.P_data;
S_data = data.S_data;
%%
%WHY DO YOU WRITE THIS HERE???REMEBER THAT YOUR SCRIPT HAS TO START WIL ALL
%GIVEN PARAMETERS' VALUE, FOR E.G. K3=0.265 AND E.T.C.
% k1 = 1.25e-2;
% k2 = 7.5e-3;
k3 = 0.265;
k4 = 0.15;
V = 800;
Q = 0.032*60;
Ca = 0.012*1000;
Cd = 0.02*1000;
%BEFORE GIVING INITIAL GUESS YOU HAVE TO WRITE ALL GIVE DAT A AND ASSEMBLE
%THOSE GIVEN VALUES IN A VECTOR AFTER THAT SPECIFY THE INITIAL CONDITIONS
%FOR ODEs.AFTER THAT YOU CAN START WRITTING THE INITIAL GUESS VALUES 
par=[k3 k4 V Q Ca Cd];
initial_Condi = [1.252 3.131 0 6.52 0 0];
%initial value
params=[0.01 0.00625];

%THIS IS THE PART OF THE CODE RESPONSIBLE FOR YOUR CURVE FITTING
options = optimset('display', 'iter','maxfunevals', 1000);
%CHECK HOW THIS PART WILL BE WRITTEN ACCORDING TO THE FACT THAT YOU ARE
%TRYING TO FIT THE VALUES OF THE Y-AXIS THUS THERE IS SOMETHING MISSING
%BELOW
x = fminsearch(@objFunc_DSEM,params,options,time,par,initial_Condi,A_data);
%HERE YOU DONÆT DEFINE THE MODEL PARAMETERS BUT YOU HAVE TO GIVE A NEW NAME
%FOR K1 AND K2 AND USE THEIR VALUES FROM FMINSEARCH IN ORDER TO RUN NEW
%SIMULATION FOR PLOTTING.SO REWRITE THE PART BELOW
%Define model parameters
estimate_k1 = x(1)
estimate_k2 = x(2)



par2=[estimate_k1 estimate_k2 k3 k4 V Q Ca Cd];
%Solve the model
%HERE YOU HAVE TO SPECIFY THAT YOU ARE GOING TO USE THE VALUES OF K1 AND K2
%AFTER THE FMINSEARCH AND THUS YOU HAVE TO SETTLE A NEW VECTOR OF YOUR
%VARIABLES WITH K1 AND K2 AFTER FMINSEARCH INTO IT IN ORDER TO SOLVE ODEs
%FOR NEW VALUES OF INITIAL GUESS
options=odeset('RelTol',1e-4);
[t,y]=ode15s(@CSTRfun_DSEM,time,initial_Condi,options,par2);%ABDIPS
%lower the sampling frequency
t1 = decimate(time,50);
A =decimate(A_data,50);
B =decimate(B_data,50);
I =decimate(I_data,50);
D =decimate(D_data,50);
P =decimate(P_data,50);
S =decimate(S_data,50);

%Plot the results
%CHECK WHERE HOLD ON SHOULD BE WRITTEN
figure
subplot(3,2,1);
plot(t,y(:,1),'r','LineWidth',1.5); hold on
plot(t1,A,'bo'); 
legend('[A]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[A] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,2)
plot(t,y(:,2),'r','LineWidth',1.5); hold on
plot(t1,B,'bo');
legend('[B]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[B] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,3)
plot(t,y(:,3),'r','LineWidth',1.5);hold on
plot(t1,D,'bo');
legend('[D]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[D] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,4)
plot(t,y(:,4),'r','LineWidth',1.5);hold on
plot(t1,I,'bo');
legend('[I]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[I] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,5)
plot(t,y(:,5),'r','LineWidth',1.5); hold on
plot(t1,P,'bo')
legend('[P]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[P] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

subplot(3,2,6)
plot(t,y(:,6),'r','LineWidth',1.5); hold on
plot(t1,S,'bo');
legend('[S]');
xlabel('Time [min]','FontSize',14,'FontWeight','bold')
ylabel('[S] [mol/min]','FontSize',14,'FontWeight','bold')
grid;

set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

saveas(gcf,'CSTR.jpg')

