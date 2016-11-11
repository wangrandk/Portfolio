clear all
clc
close all
%%
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%%
%Q1
qq1=rand(3,4); qq2=rand(3,4);


%%
q1=rand(3,10);
Htrue=[10 0 -1;1 10 20;0.01 0 3]
% q1=[q1;ones(1,9)];
q2=Htrue*q1;
% q1(1,:)=q1(1,:)./q1(3,:);
% q1(2,:)=q1(2,:)./q1(3,:);
% q1(3,:)=q1(3,:)./q1(3,:);
% q2(1,:)=q2(1,:)./q2(3,:);
% q2(2,:)=q2(2,:)./q2(3,:);
% q2(3,:)=q2(3,:)./q2(3,:);
  
% H=homography_solve(x1(1:2,:),x2(1:2,:))
H = hest(q1,q2)
% qq2=H*q1

%%
load('ImL.jpg'),load('ImR.jpg')
IL = imread('ImL.jpg');
IR = imread('ImR.jpg');
%%
[fa,da] = vl_sift(single(rgb2gray(IL)));
[fb,db] = vl_sift(single(rgb2gray(IR)));
figure(1)
[matches,scores] = vl_ubcmatch(da, db)
nMatch=size(matches,2);

figure(2)
imshow(IL),hold on
perm = randperm(size(fa,2)) ;
sel = perm(1:20) ;
h1 = vl_plotframe(fa(:,sel)) ;
h2 = vl_plotframe(fa(:,sel)) ;
h3 = vl_plotsiftdescriptor(da(:,sel),fa(:,sel)) ;
set(h3,'color','g')

set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2);

% mosaic = sift_mosaic(IL,IR);
saveas(gcf,'sift_mosaic','png')

%%
%Q3
clear all
clc
close all
load('ImL.jpg'),load('ImR.jpg')
IL = imread('ImL.jpg');
IR = imread('ImR.jpg');
H=homography(IL,IR);
IIL=(rgb2gray(IL));
IIR=(rgb2gray(IR));
T = maketform('projective',H');
ImH = imtransform(IL,T);
imagesc(ImH)
axis image

[fa,da] = vl_sift(single(rgb2gray(IL)));
[fb,db] = vl_sift(single(rgb2gray(ImH)));
figure(1)
[matches,scores] = vl_ubcmatch(da, db);
nMatch=size(matches,2);
X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:)); 

figure(1)
showMatchedFeatures(IL,ImH,X1',X2','montage');

Xn1 = X1; Xn1(3,:) = 1;
Xn2 = X2; Xn2(3,:) = 1;
%starting iterations

for iter = 1:nMatch
     subset = vl_colsubset(1:nMatch,4);
    H{iter} = hest2(Xn1(:,subset), Xn2(:,subset));
    % score homography
    X2_ = H{iter} * Xn1 ;
    du =norm( X2_(1,:)./X2_(3,:) - Xn2(1,:)./Xn2(3,:) );
    dv =norm( X2_(2,:)./X2_(3,:) - Xn2(2,:)./Xn2(3,:) );
    ok{iter} = (du^2 + dv^2) < 3 ;
    score(iter) = sum(ok{iter}) ;
end
[score, best] = max(score) ;
H = H{best} ;
ok = ok{best} ;
    
dh1 = max(size(ImH,1)-size(IL,1),0) ;
dh2 = max(size(IL,1)-size(ImH,1),0) ;

figure(2) ; clf ;
subplot(2,1,1) ;
imagesc([padarray(IL,dh1,'post') padarray(ImH,dh2,'post')]) ;
o = size(im1,2) ;
line([fa(1,matches(1,:));fb(1,matches(2,:))+o], ...
     [fa(2,matches(1,:));fb(2,matches(2,:))]) ;
title(sprintf('%d tentative matches', nMatch)) ;
axis image off ;

subplot(2,1,2) ;
imagesc([padarray(IL,dh1,'post') padarray(ImH,dh2,'post')]) ;
o = size(IL,2) ;
line([fa(1,matches(1,ok));fb(1,matches(2,ok))+o], ...
     [fb(2,matches(1,ok));fb(2,matches(2,ok))]) ;
title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
              sum(ok), ...
              100*sum(ok)/nMatch, ...
              nMatch)) ;
axis image off ;

drawnow ;

