clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
load('CamMotionData.mat');
%% 1
[F1, D1] = vl_sift(Im1,'FirstOctave',1);
[F2, D2] = vl_sift(Im2,'FirstOctave',1);
[F3, D3] = vl_sift(Im3,'FirstOctave',1);
Sigma=0.5;
[M12,E12,R12,t12]=MatchImagePair(F1,D1,F2,D2,K,Sigma)

%%
nMatch = size(M12,2);
q1 = F1(1:2,M12(1,:));% matching points
q2 = F2(1:2,M12(2,:));
F=inv(K)'*E12*inv(K)
nIn = 0;
for cM=1:nMatch,
    if(FSampDist(F,q1(:,cM),q2(:,cM)) < 3.84*3^ 2) %P.102
        nq1(:,cM) = [q1(:,cM)];
        nq2(:,cM) = [q2(:,cM)];
       nIn=nIn+1;
    end
end
figure(1)
subplot(2,1,1)
showMatchedFeatures(Im1,Im2,q1',q2','montage');
subplot(2,1,2)
showMatchedFeatures(Im1,Im2,nq1',nq2','montage');
saveas(gcf,'match','png')
%% 4
[M23,E23,R23,t23]=MatchImagePair(F2,D2,F3,D3,K,Sigma)
[ ,Idx12,Idx23] = intersect(M12,M23);
%% 5
q1 = F1(1:2,Idx12(:,1));
q2 = F2(1:2,Idx12(:,1));
q3 = F3(1:2,Idx23(:,1));

q1 = [q1;ones(1,size(q1,2))];
q2 = [q2;ones(1,size(q2,2))];
q3 = [q3;ones(1,size(q3,2))];
%% 6
I = eye(3);
t1 = [0;0;0];
P1 = [I t1];
P2 = K*[R23,t23];
%% 7
s=size(q1,2);
[Q,B]=threeD_point_tri(q1,P1,q2,P2,s); % Linear algorithm p.54

%% 8
Q1=cell2mat(Q);
P = resectioning(Q1,q1)

%% 9.Estimation of Camera3.
%  P3 = q3*Q1';
P3 = resectioning(Q1,q3)
%% 10 p3=q3+error
p3=P3*Q1;
p3 = [p3(1,:)./p3(3,:);p3(2,:)./p3(3,:);p3(3,:)./p3(3,:)];
%% 11 P.49 (2.27)"Non-linear Minimization" dist =minimizing the squared Euclidian distance. This
for i = 1:s
dist(i) =sqrt(sum(norm(q3(1:2,i)-p3(1:2,i)).^2));
end
%% 12
[row, col] = find(dist<30)
q_new = q3(:,col);
Q1_new = Q1(:,col);
% P_new3 = q_new*Q1_new';
P_new33 = resectioning(Q1_new,q_new)
%% 13 ransac

    
