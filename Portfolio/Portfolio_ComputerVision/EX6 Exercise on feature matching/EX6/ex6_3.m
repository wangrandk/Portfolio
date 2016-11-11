clear all
clc
close all
load('TwoImageData.mat')
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%%
figure(1)
imshow(im1);
figure(2)
imshow(im2);
% a=170*pi/180;
% s=sin(a);
% c=cos(a);
% H=[c s 0;-s c 0;0 0 1];
s=1;
H=[1 0 0; s 1 0; 0 0 1];
%Note That H has to be transposed here if column vectors are used for points
Tr=maketform('projective',H');
figure(3)
I2=imtransform(im2,Tr);
imshow(I2);

[fa, da] = vl_sift(single((im1)));
[fb, db] = vl_sift(single((I2)));
[matches, scores] = vl_ubcmatch(da, db); %descriptor
nMatch=size(matches,2);

X1 = fa(1:2,matches(1,:));% matching points
X2 = fb(1:2,matches(2,:)); 

figure(1)
showMatchedFeatures(im1,I2,X1',X2','montage');
