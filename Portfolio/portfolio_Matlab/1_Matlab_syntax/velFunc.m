function  v  = velFunc( g,Cd,Pp,Pw,d)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
v = sqrt(((4*g)/(3*Cd)) * ((Pp-Pw)/Pw).* d);

end

