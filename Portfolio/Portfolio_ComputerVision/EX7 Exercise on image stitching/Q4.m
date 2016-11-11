%Q3
clear all
clc
close all
%%  Q4.
clear all
clc
close all
load('ex7match.mat');
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
load('ImL.jpg'),load('ImR.jpg')
IL = imread('ImL.jpg');
IR = imread('ImR.jpg');
H = hest(t1,t2);
T = maketform('projective',H');
ImH=imtransform(IL,T);
imagesc(ImH)
axis image
figure(1)
WarpNView(H,IL,IR);
saveas(gcf,'Wrap.png')
%%
[fa,da] = vl_sift(single(rgb2gray(ImH)));
[fb,db] = vl_sift(single(rgb2gray(IR)));
[matches,scores] = vl_ubcmatch(da, db);
nMatch=size(matches,2);
X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:)); 
s=size(matches,2);

%% H = homography_solve(X1, X2)
p1=[X1;ones(1,s)];
p2=[X2;ones(1,s)];
p=[matches;ones(1,s)]; % matches: 2d matching points
sigma=3
t = 5.99 * sigma^2;%the smaller the t is, the more iter needed
 iter=200;
for i = 1:iter
        subset = vl_colsubset(1:nMatch,4);
        H1{i} = hest(p1(:,subset), p2(:,subset));
        inlier=0;
 
for j= 1: size(p1,2)
 d(j)= Hdistance(H1{i},p2(:,j),p1(:,j));
if  d(j) <= t  
      inlier = inlier + 1;
      tr1(:,j) = p1(:,j);
      tr2(:,j) = p2(:,j);
end 
    inlierT (i) = inlier; 
end
    tt1{i} = mat2cell(tr1);
    tt2{i} = mat2cell(tr2); 
end 

figure(2)
plot(p1,p2)
figure(3)
[val,I]=max(inlierT)
plot(tt1{I}{1},tt2{I}{1})
figure(4)
subplot(1,2,1)
imagesc(ImH); axis image;hold on
plot(tt1{I}{1}(1,:),tt1{I}{1}(2,:),'ro');hold on
subplot(1,2,2)
imagesc(IR);axis image;hold on
plot(tt2{I}{1}(1,:),tt2{I}{1}(2,:),'bo')
saveas(gcf,'RansacHfittingPoint4.png')
hold off
tt1{I}{1} = tt1{I}{1}(1:2,:);
tt2{I}{1} = tt2{I}{1}(1:2,:);
figure(5)
showMatchedFeatures(ImH,IR,tt1{I}{1}',tt2{I}{1}','montage');
saveas(gcf,'RansacHfittingLine4.png')
savefile = 'ex7match.mat';
t1=tt1{I}{1};
t2=tt2{I}{1};
save(savefile, 't1','t2');
