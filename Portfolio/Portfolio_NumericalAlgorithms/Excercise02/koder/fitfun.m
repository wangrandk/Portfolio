function err = fitfun(t,y,p)


phi = p(1)*exp(-p(2)*t)+p(3);

err=sum((y-phi).^2)

%9.1 