function Q=PointsInPlane()

alpha=0:0.01:2*pi;

a=-0.5:0.01:0.5;
a2=-0.4:0.01:0.4;
b=ones(size(a));

p=[[sin(alpha);cos(alpha)] [-0.4*b; a] [0.4*b; a] [a2 ; zeros(size(a2))]];

figure
plot(p(1,:),p(2,:),'.')
axis equal

A=[1/sqrt(2) 0 1/sqrt(2)]';
B=[0 1 0]';
C=[1 0.5 5]';

Q=A*p(1,:)+B*p(2,:)+C*ones(1,size(p,2));
%Q=[Q;ones(1,size(Q,2))];




