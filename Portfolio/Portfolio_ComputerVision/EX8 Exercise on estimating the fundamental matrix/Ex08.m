clear all
clc
close all
load('Qtest.mat'), 
 load('TwoImageData.mat')
%%

P_1 = A * [R1 T1]; %3 by 4, 5 dof
P_2 = A * [R2 T2];

q1 = P_1 * Q;
q2 = P_2 * Q;

q1(1,:)=q1(1,:)./q1(3,:);
q1(2,:)=q1(2,:)./q1(3,:);
q1(3,:)=q1(3,:)./q1(3,:);

q2(1,:)=q2(1,:)./q2(3,:);
q2(2,:)=q2(2,:)./q2(3,:);
q2(3,:)=q2(3,:)./q2(3,:);

CrossOp =@(T2) [0 -T2(3) T2(2); T2(3) 0 -T2(1); -T2(2) T2(1) 0];
T2_cross = CrossOp(T2);
F = pinv(A)' * T2_cross * R2 * A^-1 %Ftrue
F1= Fest_8point(q1,q2); % P.55 
% fundamental matrix can be used as a constraint on point correspondences

b=F(:);
a=F1(:);
diff=a'*b/(norm(a)*norm(b))