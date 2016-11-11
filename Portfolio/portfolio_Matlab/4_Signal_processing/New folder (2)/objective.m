function [sumOfSquares,y1] = objective(k0,tspan,x0,yd)
%This function solves the system of ODEs for the reactions in a CSTR and
%calculates the sum of squares of errors when compared to measured data for
%the concentration of A

%Solving the model
options=odeset('RelTol',1e-4);
[t,y]=ode15s(@odesolver2,tspan,x0,options,k0);
%The initial conditions vector contains values with the units mol/m^3

%Extracting concentrations of A
y1=y(:,1);

%Subtracting measured data from simulated data
error=y1-yd(:,1);

%measure of total error
sumOfSquares=sum(error.^2);


end

