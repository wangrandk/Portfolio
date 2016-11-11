clear all
clc
% importdata('data_ex4.mat')
X=[0 1 2 4 8 16; 3 4 5 6 7 8];
m=mean(X(1,:));
mm=mean(X);
mmm=mean(X,2);
[Y,I] = min(X);
sort(X,1);
t=1900:10:1990; % Time (years)
p=[75.995 91.972 105.711 123.203 131.669...
150.697 179.323 203.212 226.505 249.633];
%Population>a=interp1(t,p,1975);
x=1900:1:2000;
y1=interp1(t,p,x,'spline');
figure;
plot(t,p,'o',x,y1);
xlabel('Time (y)');
ylabel('Population (millions)');

t=0:0.00025:1; % Time vector
x=sin(2*pi*30*t)+sin(2*pi*60*t);
y=decimate(x,4);
figure(1);
stem(x(1:120));
axis([0 120 -2 2]);
title('Original Signal');
figure(2);
stem(y(1:30));
title('Decimated Signal');

plot([0:0.1:25],sawtooth([0:0.1:25]));
%%
%script
x = linspace(0,10,20);
y = 5*x + 3;
yy = y + 8*rand(1,20) .* sign(rand(1,20)-0.5);
figure
plot(x,yy,'ro')
grid
zoom on
xlabel('x value')
ylabel('y value')
title('Measurement Data')
saveas(gcf, 'measdata.jpg')
% inital guess for parameters A & B
params = [1 1];

% run estimation
estimation = fminsearch(@ls_fcn,params, [], x, yy);
A = estimation(1), B = estimation(2) %A error, B fitting value
% plot result
figure
hold on
plot(x, yy, 'ro')
grid
zoom on
xlabel('x value'), ylabel('y value')
title('Example for LS curvefitting')
plot(x, y, 'c')
plot(x, A*x+B)
hold off
set(gca,'Box','on')
legend('Measurement', 'Correct curve', 'Fitted curve','Location','SouthEast')
saveas(gcf, 'fitted.jpg')

