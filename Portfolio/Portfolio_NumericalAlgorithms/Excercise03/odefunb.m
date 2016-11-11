function dzdt = odefunb( t,z )
% z = [ z1 ; z2 ; z3 ; z4 ] = [ x ; y ; dx/dt ; dy/dt ]
% dzdt = [ dx/dt ; dy/dt ; d^2x/dt^2 ; d^2y/dt^2 ] = [ z(3) ; z(4) ; d^2x/dt^2 ; d^2y/dt^2 ] 
% Definerer konstanter herunder:
% Tyngdeaccelerationen [m/s^2]
g = 9.81;
% Masse af projektil [kg]
m = 0.55;
% Luftens massetæthed [kg/m^3]
rho = 1.2041;
% Drag coefficient: [-]
C_d = 0.5;
% Diameter [m]
d = 0.07; 
% Tværsnitsareal for projektil [m^2]
A = pi*d^2/4;
% Output:
dzdt = [ z(3) ; z(4) ; -C_d*A*rho/(2*m)*((z(3))^2 + (z(4))^2)^(1/2)*z(3) ;  
-g/m-C_d*A*rho/(2*m)*((z(3))^2 + (z(4))^2)^(1/2)*z(4) ];
end

