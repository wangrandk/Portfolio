function p = plotFun( t,tt,cal_12,cal_365,mcal_12,mcal_365,val_12,val_365,mval_12,mval_365,xlim,xl1,xl2,yl,leg1,leg2,t1,t2,t3,t4)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
p=figure
subplot(2,2,1);
plot(t,mcal_12,'b',t,cal_12,'r--');hold on;
grid on
xlim; 
xlabel(xl1); 
ylabel(yl);
legend(leg1,leg2);
title(t1,'FontSize',16);
set(gca,'FontSize',9,'LineWidth',1.5);

subplot(2,2,2);
plot(tt,mcal_365,'b',tt,cal_365,'r--')
grid on
xlabel(xl2); 
ylabel(yl);
legend(leg1,leg2);
title(t2,'FontSize',16);
set(gca,'FontSize',9','LineWidth',1.5);

subplot(2,2,3);
plot(t,mval_12,'b',t,val_12,'r--');hold on;
grid on
xlim=([0 15]); 
xlabel(xl1); 
ylabel(yl);
legend(leg1,leg2);
title(t3,'FontSize',16);
set(gca,'FontSize',9','LineWidth',1.5);

subplot(2,2,4);
plot(tt,mval_365,'b',tt,val_365,'r--')
grid on
xlabel(xl2); 
ylabel(yl);
legend(leg1,leg2);
title(t4,'FontSize',16);
set(gca,'FontSize',9,'LineWidth',1.5);

end

