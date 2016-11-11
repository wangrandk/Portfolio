% Call file
% -------------------------------------------------------------------------
clc
clear
close all
% -------------------------------------------------------------------------
% Parameters
k1=1.25*10^-2;  %min-1
k2=7.5*10^-3;   %min-1
k3=0.265;       %m3 mol-1 min-1
k4=0.15;        %m6 mol-2 min-1
V=0.8;          %m3
q_in=1.92*10^-3;%m3 min-1
Ain=12;         %mol m-3
Bin=0;
Din=20;         %mol m-3
Iin=0;
Pin=0;
Sin=0;
q_out=q_in;
par=[k1 k2 k3 k4 V q_in Ain Bin Din Iin Pin Sin q_out];

%%% Initial values
A0=1.252;    % mol m-3
B0=3.131;    % mol m-3
D0=0;           % mol m-3
I0=5.216;      % mol m-3
P0=0;           % mol m-3
S0=0;           % mol m-3
x0=[A0 B0 D0 I0 P0 S0];

% Simulation time
t0=0;
tfin=2000;   

sim('simulink_mSfunc')
xl='time [min]';
yl='[mol/m^3]';
tA='Concentration A';
tB='Concentration B';
tD='Concentration D';
tI='Concentration I';
tP='Concentration P';
tS='Concentration S';



plotFun(t,y,xl,yl,tA,tB,tD,tI,tP,tS);
saveas(gcf,'flowRate','jpg');
%%% Plotting results
