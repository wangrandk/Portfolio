function x_nedslag = nedslag(v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Kører først ode45 endnu en gang, hvor jeg gemmer resultatet i en struct 
% kaldet sol.
sol = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*v)*500 sin(pi/180*v)*500 ]);
% Finder nulpunkt i matlab:
% Projektil, y position (t):
y = @(t) deval(sol,t,2);
% Nulpunkt via fzero: (finder tidspunktet, hvor y=0, første gang) [sek]
t_0 = fzero(@(t) y(t),[0 30]);
% Projektil, x position (t):
x = @(t) deval(sol,t,1);
% x position hvor projektilet slår ned (indsætter den fundne tid) [m]
x_nedslag = x(t_0);
end

