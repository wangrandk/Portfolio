function [error, fittedcurve] = objFunc_DSEM(params,time,par,initial_Condi,A)
%THESE VALUES OF K1 AND K2 HAVE TO BE EXTRACTED FROM THE SCRIPT AFTER YOU
%MADE FMINSEARCH SO THIS PART HAS TO BE REWRITTEN AND YOU MUSTNT GIVE
%VALUES IN FUNCTION FILES YOU HAVE JUST TO GIVE A NEW NAME AND MAKE THEM EQUAL TO THE NAMES FROM THE SCRIPT FILE FOR GIVEN DATA
%IN ORDER TO PUT THIS VALUES IN A NEW VECTOR WHICH YOU WILL USE FURTHER FOR
%THE SOLVER
%initial_Condi = [1.252 3.131 0 6.52 0 0];
% t=[0:2000];
k11 = params(1)
k12 = params(2);
k3 = par(1);
k4 = par(2);
V = par(3);
Q = par(4);
Ca = par(5);
Cd = par(6);
t = time;

condi= initial_Condi;
par1=[k11 k12 k3 k4 V Q Ca Cd];
%Solve the model
options=odeset('RelTol',1e-4);
[t,fittedcurve]=ode15s(@CSTRfun_DSEM,t,condi,options,par1);
% calculate error vector
errorvector = fittedcurve(:,1) - A;
% measure of total error
error = sum(errorvector .^ 2);

