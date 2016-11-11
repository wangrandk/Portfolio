function Imed = ipot_med(l,a)

M=0.2; k=1; L0=0.1;g=9.82;

y_med = l+a*g*((2*l)/L0 - l.^2/L0^2);

dy_med= 1+a*g*(2/L0-(2*l)/L0^2);

Imed= (-1/L0) *M*g* y_med +(1/2)*k*L0* (dy_med-1).^2;


end



