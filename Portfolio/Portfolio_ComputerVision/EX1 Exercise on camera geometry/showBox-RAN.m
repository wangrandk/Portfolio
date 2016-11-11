%%outer orientation
clear
close all
Q=Box3D;
plot3(Q(1,:),Q(2,:),Q(3,:),'.'),
axis equal
axis([-1 1 -1 1 -1 5])
xlabel('x')
ylabel('y')
zlabel('z')
%P=[eye(3),zeros(3,1)]
A=eye(3);
R=eye(3);
t=zeros(3,1);
P=A*[R,t];

figure
q=P*[Q;ones(1,size(Q,2))];
q(1,:)=q(1,:)./q(3,:);
q(2,:)=q(2,:)./q(3,:);
q(3,:)=q(3,:)./q(3,:);
plot(q(1,:),q(2,:),'.')
axis([-0.3 0.3 -0.3 0.3])
%% 11. change the outer orientation of the camera by setting the rotation to
R=[0.9397,-0.342,0;0.342,0.9397,0;0,0,1];
%12 zoom out when enlarge z axis to 2
t=[0;0;2];
P=A*[R,t];
figure
q=P*[Q;ones(1,size(Q,2))];
q(1,:)=q(1,:)./q(3,:);
q(2,:)=q(2,:)./q(3,:);
q(3,:)=q(3,:)./q(3,:);
plot(q(1,:),q(2,:),'.')
axis([-0.3 0.3 -0.3 0.3])
%% inner orientation
f=1200;   %zoom in when increasing. 
delta_x=300; %translate
delta_y=200;
A=[f,0,delta_x;0,f,delta_y;0,0,1];
%R=eye(3);
t=[0;0;5]; % zoom in when decreasing
P=A*[R,t];
figure
q=P*[Q;ones(1,size(Q,2))];
q(1,:)=q(1,:)./q(3,:);
q(2,:)=q(2,:)./q(3,:);
q(3,:)=q(3,:)./q(3,:);
plot(q(1,:),q(2,:),'.')
axis equal
axis([0 640 0 480])
%%


