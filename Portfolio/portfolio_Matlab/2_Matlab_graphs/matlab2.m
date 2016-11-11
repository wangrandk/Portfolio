

x=-3:0.1:3;
y1=-x.^2;
y2=x.^2;
figure
plot(x,y1);
hold on;
plot(x,y2,'--');
hold off;
xlabel('x');
ylabel('y_1=-x^2 and y_2=x^2');
legend('y_1=-x^2','y_2=x^2');


figure
plot(x,y1);
hold on;
plot(x,y2,'--');
hold off;
xlabel('x');
ylabel('y_1=-x^2 and y_2=x^2');
legend('y_1=-x^2','y_2=x^2');
axis([-1 1 -10 10]);

figure
X = [1 2 3];
pie(X,[0 1 0],{'Profit','Taxes','Expenses'});

x = -2.9:0.2:2.9;
figure
bar(x,exp(-x.*x));

figure
x=0:0.55:10;
stairs(x,sin(x),'LineWidth',1.5);

x=0:0.5:3;
y=x.^2-1.5*x+1;
e=rand(size(x))/0.5;
figure
errorbar(x,y,e,'ro','LineWidth',1.5);
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

x=0:0.1:4;
y=sin(x.^2).*exp(x);
figure
stem(x,y,'LineWidth',1.5)
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

t=0:.01:2*pi;
figure
polar(t,abs(sin(2*t)),'r');
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

x=[0:pi/90:2*pi]';
y=x';
z=sin(x*y);
figure
mesh(x,y,z,'Linewidth',1.5);
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

x=1:0.25:10;
y=x;
Z=x'*y;
figure
surf(x,y,Z);
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')

z=peaks(25);
figure
contour(z,16,'Linewidth',1.5);
colormap(hsv);
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')