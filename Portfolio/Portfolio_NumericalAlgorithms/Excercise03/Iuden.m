function Iuden = ipot_ud(l,a)


M=0.2; k=1; L0=0.1;D=0.1;vik=25;g=9.82;

y_ud = l;
dy_ud= 1;

Iuden= -1/L0*M*g*y_ud+(1/2)*k*L0*(dy_ud-1).^2;
end
