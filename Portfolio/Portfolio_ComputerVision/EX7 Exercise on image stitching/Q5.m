%%
%Q5
clear all
clc
close all
load('ImL.jpg'),load('ImR.jpg')
IL = imread('ImL.jpg');
IR = imread('ImR.jpg');
H1=homography(IL,IR);
WarpNView(H1,IL,IR);

[fa,da] = vl_sift(single(rgb2gray(IL)));
[fb,db] = vl_sift(single(rgb2gray(IR)));
figure(1)
[matches,scores] = vl_ubcmatch(da, db);
X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:)); 
nMatch=size(matches,2);
Xn1 = X1; Xn1(3,:) = 1;
Xn2 = X2; Xn2(3,:) = 1;

for iter = 1:nMatch
    H{iter} = hest2(Xn1(:,iter), Xn2(:,iter));
    % score homography
    X2_ = H{iter} * Xn1 ;
    du = X2_(1,:)./X2_(3,:) - Xn2(1,:)./Xn2(3,:) ;
    dv = X2_(2,:)./X2_(3,:) - Xn2(2,:)./Xn2(3,:) ;
    ok{iter} = (du.*du + dv.*dv) < 50 ;
    score(iter) = sum(ok{iter}) ;
end
[score, best] = max(score) ;
H = H{best} ;
ok = ok{best};
