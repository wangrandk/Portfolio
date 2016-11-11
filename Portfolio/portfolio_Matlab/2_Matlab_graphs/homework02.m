clear
sim = importdata('Data_simulation.mat')
t = sim.t;
tt = sim.tt;
cal_12 = sim.cal_12;
cal_365 = sim.cal_365;
val_12 = sim.val_12;
val_365 = sim.val_365;


m = importdata('Data_measurement.mat')
mt = m.t;
mtt = m.tt;
mcal_12 = m.cal_12;
mcal_365 = m.cal_365;
mval_12 = m.val_12;
mval_365 = m.val_365;

xlim =([0 15]); 
xl1 = 'Time[month]'; 
xl2 = 'Time [day]';
yl = 'Flowrate [m3/d]';
leg1='Measurement';
leg2='Simulation';
t1='Monthly calibration';
t2='Daily calibration';
t3='Monthly validation';
t4='Daily validation';

p=plotFun( t,tt,cal_12,cal_365,mcal_12,mcal_365,val_12,val_365,mval_12,mval_365,xlim,xl1,xl2,yl,leg1,leg2,t1,t2,t3,t4);
%saveas(gcf,'flowRate.tif');
saveas(gcf,'flowRate','jpg'); %saveas(p,'flowRate','jpg');