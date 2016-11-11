clear all


%1
I= eye(3);
t1 = [0 0 0]';
t2 = [-5 0 2]';
t3 = [0.1 0 0.1]';
P1 = [I t1];
P2 = [I t2];
P3 = [I t3];

%2
Q1 = [2 4 10 1]';
q1 = P1 * Q1;
q2 = P2 * Q1;
q3 = P3 * Q1;

q1(1,:)=q1(1,:)./q1(3,:);
q1(2,:)=q1(2,:)./q1(3,:);

q2(1,:)=q2(1,:)./q2(3,:);
q2(2,:)=q2(2,:)./q2(3,:);

q3(1,:)=q3(1,:)./q3(3,:);
q3(2,:)=q3(2,:)./q3(3,:);

q1
q2
q3

%%
%VERIFICATION OF Q1
q11 = [0.2 0.4 1]';
q12 = [-0.25 1/3 1]';
[Q1,B]=Est3D(q11,P1,q12,P2);
%%
%1.2.1
q21 = [-0.1667 0.3333 1]';
q22 = [-0.5 0.2857 1]';
[Q2,B]=Est3D(q21,P1,q22,P2);
B*Q2;

%%
%1.2.2
q23 = P3 * Q2;

%%
%1.3
q22n = [q22(1:2)+0.1;q22(3)];
q23n = [q23(1:2)+0.1;q23(3)];
 %%
%1.3.2
[Q2,B]=Est3D(q21,P1,q22n,P2);
B*Q2;

%%
%1.3.3
[Q2,B]=Est3D(q21,P1,q23n,P2)
B*Q2;

q21; 
q22;

%%
%1.4
load TwoImageData.mat
figure('name','Q12 view 1');
imshow(im1);
g1 = [ginput(1) 1]';

figure('name','Q12 view 2');
imshow(im2);
g2 = [ginput(1) 1]';
format long e
[Q3,B]=Est3D(g1,P1,g2,P2);
%DrawImageLine(size(im2,1),size(im2,2),l2');

