function dydx = odefun(x,v)
% dzdt = odefun(t,z)
% y=z(1);
% v=z(2);
% dydx=[v; ((-v+y-x)/7)];
y=v(1);
z=v(2);
dydx=[z; ((-z+y-x)/7)];

end









