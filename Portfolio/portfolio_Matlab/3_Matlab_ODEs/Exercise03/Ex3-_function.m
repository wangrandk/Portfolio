function dydt = odesolver(t,y,par)
%The function is used to solve a system of ODEs governing 4 reactions in a
%CSTR
%Defining a column vector
dydt=zeros(6,1); 

%Assigning the parameters
k1=par(1);
k2=par(2);
k3=par(3);
k4=par(4);
Vol=par(5);
q=par(6);
Cain=par(7);
Cdin=par(8);

%Setting up mass balance equations for each component in the reactor
dydt(1)=(q/Vol*(Cain-y(1)))+(-k1*y(1))-(k2*y(1)); %y1=A
dydt(2)=(q/Vol*(-y(2)))+(k1*y(1)-(k3*y(2)*y(4)));%y2=I y4=D 
dydt(3)=(q/Vol*(-y(3)))+(k2*y(1)-(k4*y(4)*y(3)*y(3)));%y3=B
dydt(4)=(q/Vol*(Cdin-y(4)))+((-k3*y(2)*y(4))+(-k4*y(4)*y(3)*y(3)));
dydt(5)=(q/Vol*(-y(5)))+(k3*y(2)*y(4));
dydt(6)=(q/Vol*(-y(6)))+(k4*y(4)*y(3)*y(3));

end

