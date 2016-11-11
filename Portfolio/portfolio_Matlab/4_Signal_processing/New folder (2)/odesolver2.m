function dydt = odesolver2(t,y,kk)
%The function is used to solve a system of ODEs governing 4 reactions in a
%CSTR
%Defining a column vector
dydt=zeros(6,1); 

%Assigning the parameters
k1=kk(1);
k2=kk(2);
k3=0.265; %m^3 mole^-1 min^-1
k4=0.15;  %m^6 mole^-2 min^-1
Vol=800;  %L 
q=1.92;   %L/min 
Cain=12;  %mol/m^3 
Cdin=20;  %mol/m^3


%Setting up mass balance equations for each component in the reactor
dydt(1)=(q/Vol*(Cain-y(1)))+(-k1*y(1))-(k2*y(1));
dydt(2)=(q/Vol*(-y(2)))+(k1*y(1)-(k3*y(2)*y(4)));
dydt(3)=(q/Vol*(-y(3)))+(k2*y(1)-(k4*y(4)*y(3)*y(3)));
dydt(4)=(q/Vol*(Cdin-y(4)))+((-k3*y(2)*y(4))+(-k4*y(4)*y(3)*y(3)));
dydt(5)=(q/Vol*(-y(5)))+(k3*y(2)*y(4));
dydt(6)=(q/Vol*(-y(6)))+(k4*y(4)*y(3)*y(3));

end

