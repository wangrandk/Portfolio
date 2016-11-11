clear all
clc
close all

load('CamMotionData.mat');

[F1, D1] = vl_sift(Im1,'FirstOctave',1);
[F2, D2] = vl_sift(Im2,'FirstOctave',1);
[F3, D3] = vl_sift(Im3,'FirstOctave',1);
Sigma=3;

%3.Match image 1&2 as well as image 2&3%
[M12, E12, R12, t12] = MatchImagePair(F1, D1, F2, D2, K, Sigma);
[M23, E23, R23, t23] = MatchImagePair(F2, D2, F3, D3, K, Sigma);

%4.Compute 2D features that are matches over all three images:
[C, Idx12, Idx23] = intersect(M12, M23);

%5. Compute the corresponding 2D feature points q1,q2,q3.
q1 = F1(1:2,Idx12(:,1));
q2 = F2(1:2,Idx12(:,1));
q3 = F3(1:2,Idx23(:,1));

q1 = [q1;ones(1,size(q1,2))];
q2 = [q2;ones(1,size(q2,2))];
q3 = [q3;ones(1,size(q3,2))];

%6.Form camera 1&2(I didn't know about cam2, so i set it up manually).
I = eye(3);
t1 = [0;0;0];
t2 = [0.1;0;0.1];

P1 = [I t1];
P2 = [I t2];

%7.3D points estimation.
Q = Est3D(q1,P1,q2,P2);
Q = [Q(1,:)./Q(4,:);Q(2,:)./Q(4,:);Q(3,:)./Q(4,:);Q(4,:)./Q(4,:)];
%9.Estimation of Camera3.
P3 = q3*Q';

%10. compute projections
p3 = P3*Q;
p3 = [p3(1,:)./p3(3,:);p3(2,:)./p3(3,:);p3(3,:)./p3(3,:)];

%11. Reprojection error
d = sqrt(sum((q3(1:2,:) - p3(1:2,:)).^2));

%12. Recompute Cam3 using only the points with a reprojection error <30.
th = d(d<30);
[row, col] = find(d<30);
q3_new = q3(:,col);
Q_new = Q(:,col);
Cam3_new = q3_new*Q_new';











