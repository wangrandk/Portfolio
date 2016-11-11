clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%%
load('Qtest.mat'), load('TwoImageData.mat')
%Q1
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
Ftrue = pinv(A)' * T2_cross * R2 * A^-1
F1= Fest_8point(q1,q2)
%% Q2
 load('TwoImageData.mat')

[fa,da] = vl_sift(single(im1));
[fb,db] = vl_sift(single(im2));
figure(1)
[matches,scores] = vl_ubcmatch(da, db)
nMatch=size(matches,2);
X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:));
showMatchedFeatures(im1,im2,X1',X2','montage');
figure(2)
plot(X1,X2)
saveas(gcf,'siftFitting','png')

%% Q3
s=size(matches,2)
p1=[X1;ones(1,s)];
p2=[X2;ones(1,s)];
iter=10
for i=1:iter
idx=randperm(nMatch);
idx=idx(1:8);
F{i} = Fest_8point(p1(:,idx),p2(:,idx));
% d{i}=FSampDist(F{i},X1(:,idx),X2(:,idx));
end
for i = 1:iter
b=Ftrue(:);
a=F{i};
a = a(:);
diff(i)= a'*b/(norm(a)*norm(b));
end

[value bestF]= max(diff(:))
nIn=0;
for cM=1:nMatch,
    if(FSampDist(F{bestF},X1(:,cM),X2(:,cM))<3.84*3^ 2)
        tr1(:,cM) = [X1(:,cM)];
        tr2(:,cM) = [X2(:,cM)];
       nIn=nIn+1;
    end
end

%% Q4
p1=[tr1;ones(1,s)];
p2=[tr2;ones(1,s)];
F2 = Fest_8point(p1,p2);

% b=F{bestF};
b=Ftrue(:);
% b = b(:);
a=F2(:);
diff2= a'*b/(norm(a)*norm(b));
figure(2)
plot(tr1,tr2);
saveas(gcf,'inlierFitting','png')

%% 5
h1 = imread('House1.bmp');
h2 = imread('House2.bmp');
[fa,da] = vl_sift(single(h1));
[fb,db] = vl_sift(single(h2));
figure(1)
[matches,scores] = vl_ubcmatch(da, db)
nMatch=size(matches,2);
X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:));
showMatchedFeatures(h1,h2,X1',X2','montage');
figure(2)
plot(X1,X2)
saveas(gcf,'siftFitting','png')

s=size(matches,2)
p1=[X1;ones(1,s)];
p2=[X2;ones(1,s)];
iter=10
for i=1:iter
idx=randperm(nMatch);
idx=idx(1:8);
F{i} = Fest_8point(p1(:,idx),p2(:,idx));
% d{i}=FSampDist(F{i},X1(:,idx),X2(:,idx));
end
for i = 1:iter
b=Ftrue(:);
a=F{i};
a = a(:);
diff(i)= a'*b/(norm(a)*norm(b));

end
[value bestF]= min(diff(:));
nIn=0;
for cM=1:nMatch,
    if(FSampDist(F{bestF},X1(:,cM),X2(:,cM))<3.84*3^ 2)
        tr1(:,cM) = [X1(:,cM)];
        tr2(:,cM) = [X2(:,cM)];
       nIn=nIn+1;
    end
end

p1=[tr1;ones(1,s)];
p2=[tr2;ones(1,s)];
F3 = Fest_8point(p1,p2);
% 
% b=Ftrue(:);
% a=F3(:);
% diff2= a'*b/(norm(a)*norm(b));
figure(3)
plot(tr1,tr2);
% saveas(gcf,'inlierFitting','png')