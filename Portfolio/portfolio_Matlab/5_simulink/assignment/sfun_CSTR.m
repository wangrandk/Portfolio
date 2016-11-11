function [sys,x0,str,ts] = sfun_CSTR(t,x,u,flag,x0,par)

switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(x0);
  case 1,
    sys=mdlDerivatives(t,x,u,par);
  case 3,
    sys=mdlOutputs(t,x,u);
  case { 2, 4, 9 }
     sys = []; % Unused flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes(x0)
sizes = simsizes;
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
sys = simsizes(sizes);
% initialize the initial conditions
x0  = x0; % xinit are the initial values that are sent to the S-function, see first line of the S-function
% str is always an empty matrix
str = [];
% initialize the array of sample times
ts  = [0 0];

function sys=mdlDerivatives(t,x,u,par)
% Assign values to the parameters, par is a vector with parameter values
% that is sent to the S-function
% k1  = par(1);
% k2  = par(2);
% dxdt(1)=-k1*x(1)+k2*x(2);
% dxdt(2)=k1*x(1)-k2*x(2);
k1=par(1); 
k2=par(2);
k3=par(3);
k4=par(4);
V=par(5);
q_in=par(6);
Ain=par(7);
Bin=par(8);
Din=par(9);
Iin=par(10);
Pin=par(11);
Sin=par(12);
q_out=par(13);

r1=k1*x(1,1);
r2=k2*x(1,1);
r3=k3*x(4,1)*x(3,1);
r4=k4*x(3,1)*(x(2,1)^2);

dx(1,1)=[(q_in*Ain)-(q_out*x(1,1))]/V+(-r1-r2);
dx(2,1)=[(q_in*Bin)-(q_out*x(2,1))]/V+(r2-r4);              
dx(3,1)=[(q_in*Din)-(q_out*x(3,1))]/V+(-r3-r4);                    
dx(4,1)=[(q_in*Iin)-(q_out*x(4,1))]/V+(r1-r3);
dx(5,1)=[(q_in*Pin)-(q_out*x(5,1))]/V+(r3);
dx(6,1)=[(q_in*Sin)-(q_out*x(6,1))]/V+(r4);

sys = [dx(1,1) dx(2,1) dx(3,1) dx(4,1) dx(5,1) dx(6,1)];

function sys=mdlOutputs(t,x,u)
% Calculate the outputs of the model block
sys = [x(1,1) x(2,1) x(3,1) x(4,1) x(5,1) x(6,1)];

% function dx = ex3_2014(t,x,par);
%%% model parameters
% k1=par(1); 
% k2=par(2);
% k3=par(3);
% k4=par(4);
% V=par(5);
% q_in=par(6);
% Ain=par(7);
% Bin=par(8);
% Din=par(9);
% Iin=par(10);
% Pin=par(11);
% Sin=par(12);
% q_out=par(13);
% 
% r1=k1*x(1,1);
% r2=k2*x(1,1);
% r3=k3*x(4,1)*x(3,1);
% r4=k4*x(3,1)*(x(2,1)^2);
% 
% 
% 
% dx(1,1)=[(q_in*Ain)-(q_out*x(1,1))]/V+(-r1-r2);
% dx(2,1)=[(q_in*Bin)-(q_out*x(2,1))]/V+(r2-r4);              
% dx(3,1)=[(q_in*Din)-(q_out*x(3,1))]/V+(-r3-r4);                    
% dx(4,1)=[(q_in*Iin)-(q_out*x(4,1))]/V+(r1-r3);
% dx(5,1)=[(q_in*Pin)-(q_out*x(5,1))]/V+(r3);
% dx(6,1)=[(q_in*Sin)-(q_out*x(6,1))]/V+(r4);








