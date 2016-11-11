function err = fitfun3(t,y,p);


a1=p(1);
a2=p(2);
t1=p(3);
t2=p(4);
sigma1=p(5);
sigma2=p(6);
d1=p(7);
d2=p(8);

%definerer funktionen
A= a1.*exp(-((t-t1)./sigma1).^2).*(1+erf(d1.*(t-t1)))+(a2.*exp(-((t-t2)./sigma2).^2).*(1+erf(d2.*(t-t2))));
%definerer den summerede, kvadredede fejl

err = sum((y-A).^2);