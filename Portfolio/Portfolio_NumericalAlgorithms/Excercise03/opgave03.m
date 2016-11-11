close all
clc
clear all
load('airpollutiondata.mat')
%% 1.1
t = 24;
n = 75;
delta = t/n
I = delta* sum(y)

%% 1.2
load('airpollutiondata.mat')
a1=1;a2=1;t1=2;t2=8;d1=1;d2=1;sigma1=4;sigma2=4;
p=[a1,a2,t1,t2,sigma1,sigma2,d1,d2];
p = fminsearch(@(p)fitfun3(t,y,p),p)

a1=p(1);a2=p(2);t1=p(3);t2=p(4);sigma1=p(5);sigma2=p(6);d1=p(7);d2=p(8);

f= a1.*exp(-((t-t1)/sigma1).^2).*(1+erf(d1.*(t-t1)))+...
   (a2.*exp(-((t-t2)./sigma2).^2).*(1+erf(d2.*(t-t2))));

plot(t,y,'o',t,f,'r--'); 
xlabel('Time','FontSize',16); 
ylabel('concentration,g/m3','FontSize',16);
legend('Original','Fitting line','FontSize',16);
title('Måling af luftforureningsdata','FontSize',20);
saveas(gcf,'fitting.png')

%% 1.3

f=@(t) a1.*exp(-((t-t1)./sigma1).^2).*(1+erf(d1.*(t-t1)))+...
   (a2.*exp(-((t-t2)./sigma2).^2).*(1+erf(d2.*(t-t2))));

I=quad(f,0,24) %% adaptive Simpson quadrature
%% 2.1
close all
clc
clear all
load('kondi.mat')
%%
n=12;
px=polyfit(t,x,n);
py=polyfit(t,y,n);
fx = polyval(px,t);
fy = polyval(py,t);
% tt=0:0.01:1;
% xp1=polyval(px,tt);
% yp1=polyval(py,tt);
% table = [x y fx fy x-fx y-fy,'VariableNames', {'x', 'y', 'fitx','fity''error_x','error_y'}];
figure(1)
plot(x,y,'o',fx,fy,'r--',fx,fy,'*')
xlabel('Time'); 
ylabel('Position,km');
legend('Original','Fitting line','Fitting Position');
title('Kondiløberen','FontSize',16);
saveas(gcf,'Kondiløberen.png')
% axis([0  1  0  1])
%% 2.2
dx = polyder(px)
vdx=polyval(dx,t);
dy = polyder(py)
vdy=polyval(dy,t);
figure(2)
plot(t,vdx,t,vdy)
xlabel('Time'); 
ylabel('Velocity');
legend('x','y');
title('Derivative','FontSize',16);
saveas(gcf,'Derivative.png')
%% 2.3
f =@(t) sqrt(polyval(dx,t).^2 + polyval(dy,t).^2);
tol=1e-4;
Q = quad(f,0,t(end),tol)


%% sporgsmaal A
clear all; close all; clc;

%% A.2
M=0.2; k=1; L0=0.1;D=0.1;vik=25;g=9.82;
p=[M k L0 D vik g];
%opskriver funktionerne for potentiel energi med og uden tyngdekraft
%finder integralet af de to med quad
% y_ud = l;
dy_ud= 1;
Iuden =@(l)-1/L0*M*g*l+(1/2)*k*L0*(dy_ud-1).^2;
Iu=quad(Iuden,0,L0)
Im=quad(@(l)Imed(l,1/g),0,L0)
%% A.3
%finder optimale a.
aopt=fminbnd( @(a) quad(@(l)Imed(l,a),0,L0),0,1)
%finder værdien af integralet med et nye a
Imed_opt=quad(@(l)Imed(l,aopt),0,L0)
%% A.4
I_ustr=Iu;
s=fzero(@(s) I_ustr-quad(@(l)ipot_s(l,s),0,L0),1.1,10)
%koerer nu med det fundne s
Lmax= s*(L0+aopt*g*((2*L0)/L0 - L0^2/L0^2))


