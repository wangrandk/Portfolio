%Q3
clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
clear('H')
load('ImL.jpg'),load('ImR.jpg')
IL = imread('ImL.jpg');
IR = imread('ImR.jpg');

[fa,da] = vl_sift(single(rgb2gray(IL)));
[fb,db] = vl_sift(single(rgb2gray(IR)));
[matches,scores] = vl_ubcmatch(da, db);
nMatch=size(matches,2);
X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:)); 
s=size(matches,2);

% H = homography_solve(X1, X2)
p1=[X1;ones(1,s)];
p2=[X2;ones(1,s)];
p=[matches;ones(1,s)]; % matches: 2d matching points
% H1 = hest(p1, p2);

%  dist = NonLinearOptimization(H,p1,p2)
sigma=3
t = 5.99 * sigma^2;%the smaller the t is, the more iter needed
 iter=200;

for i = 1:iter
    % estimate homograpyh
    subset = vl_colsubset(1:nMatch,4);
%     A = [];
%     for ii = subset;
%     A = cat(1, A, kron(p1(:,ii)', vl_hat(p2(:,ii)))) ;
        H{i} = hest(p1(:,subset), p2(:,subset));
%   end
%   [U,S,V] = svd(A) ;
%   H{i} = reshape(V(:,9),3,3);
%  H{i}, inliers(i) = ransacfithomography(p1(:,subset), p2(:,subset),3)
%  for cM=1:nMatch,
 inlier=0;
 
for j= 1: size(p1,2)
%     if Hdistance(H{i},p2(:,j),p1(:,j))<t
 d(j)= Hdistance(H{i},p2(:,j),p1(:,j));

if  d(j) <= t  
      inlier = inlier + 1;
%        tmpin = [tmpin cM];
      tr1(:,j) = p1(:,j);
      tr2(:,j) = p2(:,j);
end 
    inlierT (i) = inlier;
    
end
    tt1{i} = mat2cell(tr1);
    tt2{i} = mat2cell(tr2); 
end 


figure(1)
plot(p1,p2)
figure(2)
[val,I]=max(inlierT)
plot(tt1{I}{1},tt2{I}{1})
figure(3)
subplot(1,2,1)
imagesc(IL);hold on
plot(tt1{I}{1}(1,:),tt1{I}{1}(2,:),'ro');hold on
subplot(1,2,2)
imagesc(IR);hold on
plot(tt2{I}{1}(1,:),tt2{I}{1}(2,:),'bo')
saveas(gcf,'RansacHfittingPoint3.png')
hold off
ttt1{I}{1} = tt1{I}{1}(1:2,:);
ttt2{I}{1} = tt2{I}{1}(1:2,:);
figure(4)
showMatchedFeatures(IL,IR,ttt1{I}{1}',ttt2{I}{1}','montage');
saveas(gcf,'RansacHfittingLine3.png')
savefile = 'ex7match.mat';
t1=ttt1{I}{1};
t2=ttt2{I}{1};
save(savefile, 't1','t2');





