function pot_s = ipot_s(l,s)
a=0.1;
%Oopskriver konstanter
M=0.2; k=1; L0=0.1;g=9.82;

%a er fast
ys = s*(l+a*g*((2*l)/L0 - l.^2/L0^2));

dys= s*(1+a*g*(2/L0-(2*l)/L0^2));
        
pot_s= (-1/L0) *M*g*ys +(1/2)*k*L0*(dys-1).^2;


end



    