clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%%
im1 = imread('ImL.jpg');
im2 = imread('ImR.jpg');

[fa, da] = vl_sift(single(rgb2gray(im1)));
[fb, db] = vl_sift(single(rgb2gray(im2)));
[matches, scores] = vl_ubcmatch(da, db);
nMatch=size(matches,2);

X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:)); 

figure(1)
showMatchedFeatures(im1,im2,X1',X2','montage');

%% Q3

Xn1 = X1; Xn1(3,:) = 1;
Xn2 = X2; Xn2(3,:) = 1;
%starting iterations

for iter = 1:nMatch
    H{iter} = hest2(Xn1(:,iter), Xn2(:,iter));
    % score homography
    X2_ = H{iter} * Xn1 ;
%     u = H(1) * X1(1,ok) + H(4) * X1(2,ok) + H(7) ;
%     v = H(2) * X1(1,ok) + H(5) * X1(2,ok) + H(8) ;
%     d = H(3) * X1(1,ok) + H(6) * X1(2,ok) + 1 ;
%     du = X2_(1,ok) - u ./ d ;
%     dv = X2_(2,ok) - v ./ d ;
%     err = sum(du.*du + dv.*dv) ; 
    du = X2_(1,:)./X2_(3,:) - Xn2(1,:)./Xn2(3,:) ;
    dv = X2_(2,:)./X2_(3,:) - Xn2(2,:)./Xn2(3,:) ;
    %err = sum(du.*du + dv.*dv) ; 
    ok{iter} = (du.*du + dv.*dv) <11111;
    score(iter) = sum(ok{iter}) ;
end
[score, best] = max(score) ;
H = H{best} ;
ok = ok{best} ;


dh1 = max(size(im2,1)-size(im1,1),0) ;
dh2 = max(size(im1,1)-size(im2,1),0) ;

figure(2) ; clf ;
subplot(2,1,1) ;
imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
o = size(im1,2) ;
line([fa(1,matches(1,:));fb(1,matches(2,:))+o], ...
     [fa(2,matches(1,:));fb(2,matches(2,:))]) ;
title(sprintf('%d tentative matches', nMatch)) ;
axis image off ;

subplot(2,1,2) ;
imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
o = size(im1,2) ;
line([fa(1,matches(1,ok));fb(1,matches(2,ok))+o], ...
     [fb(2,matches(1,ok));fb(2,matches(2,ok))]) ;
title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
              sum(ok), ...
              100*sum(ok)/nMatch, ...
              nMatch)) ;
axis image off ;

drawnow ;

