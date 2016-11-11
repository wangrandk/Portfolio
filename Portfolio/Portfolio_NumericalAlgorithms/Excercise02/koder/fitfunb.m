
function err = fitfunb(I,Y,sigma)
A=(1/(sigma*sqrt(2*pi)))*exp(-((I-10).^2)/(2*(sigma)^2))

err = sum((Y-A).^2);
end
