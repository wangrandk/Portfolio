%% Question 1

clear;
close all;

f = 1000;
d_x = 300;
d_y = 200;

A = [f 0 d_x; 0 f d_y; 0 0 1];
t = [0.8866; 0.5694; 0.1911];
R = Rot(0.2, -0.3, 0.1);

P = A * [R t];

in_Q = Box3D;
Q = [in_Q;ones(1,size(in_Q,2))]; 

figure('name','3d points');
plot3(Q(1,:),Q(2,:),Q(3,:),'.');

figure('name','q1 projection');
q = P * Q;
q(1,:)=q(1,:)./q(3,:);
q(2,:)=q(2,:)./q(3,:);
q(3,:)=q(3,:)./q(3,:);
plot(q(1,:),q(2,:),'.')
axis equal
axis([0 640 0 480])


%% Question 2



A_p = [f 0 0; 0 f 0; 0 0 1];
A_q = [1 0 d_x; 0 1 d_y; 0 0 1];

p_d = A_p*[R t]*Q;

p_d(1,:)=p_d(1,:)./p_d(3,:);
p_d(2,:)=p_d(2,:)./p_d(3,:);
p_d(3,:)=p_d(3,:)./p_d(3,:);

r = sqrt(p_d(1,:).^2 + p_d(2,:).^2);

k_3 = -1e-6;
k_5 = 1e-12;
delta = @(r) k_3*r.^2 + k_5*r.^4;

p_d(1,:) = p_d(1,:).*(1+delta(r));
p_d(2,:) = p_d(2,:).*(1+delta(r));

q = A_q * p_d;

figure('name','q2 projection');
plot(q(1,:),q(2,:),'.')
axis equal
axis([0 640 0 480])

%% Question 3

k_5 = 0;

p_d(1,:) = p_d(1,:).*(1+delta(r));
p_d(2,:) = p_d(2,:).*(1+delta(r));
q = A_q * p_d;
figure('name','q3 projection');
plot(q(1,:),q(2,:),'.')
axis equal
axis([0 640 0 480])

%% Question 4

%CrossOp = @(t_2) [0 -t_2(3) t_2(2); t_2(3) 0 -t_2(1); -t_2(2) t_2(1) 0]; 
%% Question 5

A = [100  0 300; 0 1000 200; 0 0 1];
R_1 = Rot(0,0,0);
R_2 = Rot(-0.1,0.1,0);

t_1 = [0;0;0];
t_2 = [0.2;2;0.1];

P_1 = A * [R_1 t_1];
P_2 = A * [R_2 t_2];

Q = [1; 0.5; 4; 1];

q_1 = P_1 * Q;
q_2 = P_2 * Q;

q_1(1,:)=q_1(1,:)./q_1(3,:);
q_1(2,:)=q_1(2,:)./q_1(3,:);
q_1(3,:)=q_1(3,:)./q_1(3,:);

q_2(1,:)=q_2(1,:)./q_2(3,:);
q_2(2,:)=q_2(2,:)./q_2(3,:);
q_2(3,:)=q_2(3,:)./q_2(3,:);

%% Question 6
t_2_cross = CrossOp(t_2);
F = pinv(A)' * t_2_cross * R_2 * A^-1;
%     F = -0.0000   -0.0000    0.0262
%        0.0000    0.0000   -0.0006
%       -0.0142    0.0011   -2.0025 
   

%% Question 7

L_2 = F*q_1;
% L_2 =
% 
%     0.0188
%    -0.0002
%    -6.2717

%% Question 8

on = q_2' * L_2;  % Practically 0 5.3291e-15

%% Question 9
clear;
load('TwoImageData.mat');

% Q_l1 = R_1 * Q_g + t_1;
% Same as
% Q_g = R_1' * Q_l1 - R_1' * t_1;


%% Question 10

% R_2*Q_g + t_2 = Q_l2
% Same as
% R_2*(R_1' * Q_l1 - R_1' * t_1) + t_2 = Q_l2
% Same as
% R_2*R_1'*Q_l1 - R_2*R_1' * t_1 + t_2 = Q_l2

% If
% rR_2 = R_2*R_1'
% rT_2 = t_2 - R_2*R_1' * t_1

% Then
%Q_l2 = rR_2*Q_l1 + rT_2

%% Question 11
CrossOp = @(t_2) [0 -t_2(3) t_2(2); t_2(3) 0 -t_2(1); -t_2(2) t_2(1) 0]; 

rT2 = T2 - R2*R1' * T1;
rR2 = R2*R1';
F = pinv(A)' * CrossOp(rT2) * rR2 * A^-1;
% F =1.0e-03 *
% 
%     0.0000   -0.0000    0.0001
%    -0.0000   -0.0000    0.0329
%     0.0004   -0.0322   -0.2120
%% Question 12

figure('name','Q12 view 1');
imshow(im1);

g1 = [ginput(1) 1]';
l2 = F * g1;

figure('name','Q12 view 2');
imshow(im2);

DrawImageLine(size(im2,1),size(im2,2),l2');

%% Question 13

figure('name','view 2');
imshow(im2);

g2 = [ginput(1) 1]';
l1 = g2'* F;

figure('name','view 1');
imshow(im1);
DrawImageLine(size(im2,1),size(im2,2),l1);

%% Question 14
clear;

f = 1000;
d_x = 300;
d_y = 200;

Ac = [f 0 d_x; 0 f d_y; 0 0 1];
t = [0.8866; 0.5694; 0.1911];
R = Rot(0.2, -0.3, 0.1);
P = Ac * [R t];

Q = PointsInPlane;
Q = [Q;ones(1,size(Q,2))];

figure('name','q14 projection');
q = P * Q;
q(1,:)=q(1,:)./q(3,:);
q(2,:)=q(2,:)./q(3,:);
q(3,:)=q(3,:)./q(3,:);
plot(q(1,:),q(2,:),'.')
axis equal
axis([0 640 0 480])

%% Question 15

A = [2^-0.5; 0 ; 2^-0.5];
B = [0; 1; 0];
C = [1; 0.5; 5];

H = P * [A B C ; 0 0 1];

%% Question 16

q_p = pinv(H) * q;

q_p(1,:)=q_p(1,:)./q_p(3,:);
q_p(2,:)=q_p(2,:)./q_p(3,:);
q_p(3,:)=q_p(3,:)./q_p(3,:);

figure('name','q16 image to plane');
plot(q_p(1,:),q_p(2,:),'.')
axis equal












