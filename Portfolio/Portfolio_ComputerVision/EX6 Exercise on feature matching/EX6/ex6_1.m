clear all
clc
close all
load('TwoImageData.mat')
%%
I = im1;
I2 = im2;
figure(1)
imshow(I);
figure(2)
imshow(I2);
% a=170*pi/180;
% s=sin(a);
% c=cos(a);
% H=[c s 0;-s c 0;0 0 1];
s=0.1;
H=[1 0 0; s 1 0; 0 0 1];
%Note That H has to be transposed here if column vectors are used for points
Tr=maketform('projective',H');
figure(3)
I2=imtransform(im2,Tr);
imshow(I2);
% Y = get_patch(I, 240,308,40);
% figure(2)
% imshow(Y);
% 
% Z = get_patch(I2, 240,308,40);
% figure(3)
% imshow(I2), hold on
% plot(278,344, 'c*');
% 
% p = get_corr(Z,Y);

[r1, c1] = corner_detection(I);
[r2, c2] = corner_detection(I2);

p1 = [r1 c1]';
p2 = [r2 c2]';
%%
length = min(length(p1),length(p2));
p1=p1(:,1:length);
p2=p2(:,1:length);
pp1 = [p1;ones(1,length)];
pp2 = [p2;ones(1,length)];
%%
t_cross = CrossOp(T2);
F = pinv(A)' * t_cross * R2 * A^-1;
% dist= (((p2)'*F*p1)^2)/((F * p1(1,:))^2 + (F*p1(2,:)^2) + ((p2(1,:)' * F)^2) + ((p2(2,:)' *F)^2))
q1 = A * pp1;
q2 = A * pp2;
% q1=[p1;ones(length(p1),1)'];
% q1= q1(:,1:194);
% q2=[p2;ones(length(p2),1)'];
% dist= (((q2)'*F*q1).^2)/((F * q1(1,:)).^2 + (F*q1(2,:).^2) + ((q2(1,:)' * F).^2) + ((q2(2,:)' *F).^2))
% d1 =(F * q1);%3*194  
% d2= (q2'*F);%194*3
% sampson_dist = ((q2'*F*q1).^2)/ (d1(1,:).^2 + d1(2,:).^2 + d2(:,1).^2 + d2(:,2).^2);
d = sampsonFun(F,p1,p2)
 % Tr=maketform('projective',F')
% epiline check
l3=q1'*F;
epilines=epipolarLine(F,p2');
points=lineToBorderPoints(epilines,size(im2));% retures 4 column 2x,2y
figure(6);imshow(im2)
line(points(:, [1,3])', points(:, [2,4])');
% figure(4)
% showMatchedFeatures(I,I2,p1',p2','montage');

% [f1, vpts1] = extractFeatures(I, p1');
% [f2, vpts2] = extractFeatures(I2, p2');
% indexPairs = matchFeatures(f1, f2) ;
% matchedPoints1 = vpts1;
% matchedPoints2 = vpts2;
% figure; ax = axes;
% showMatchedFeatures(I,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
% title(ax, 'Candidate point matches');
% legend(ax, 'Matched points 1','Matched points 2');
%%
n = 8;
r = 2*n + 1;
dmax = inf;
[m1, m2, p1ind, p2ind, cormat] = matchbycorrelation(I, p1, I2, p2, r, dmax);
% cormat = correlatiomatrix(I, m1, I2, m2, r, inf);
figure(7)
showMatchedFeatures(I,I2,m1',m2','montage');
saveas(gcf,'montage.png')
% % 
% mosaic = sift_mosaic(I,I2);%demonstrates matching two images based on SIFT
% %features and RANSAC and computing their mosaic
% saveas(gcf,'mosaicFit.png')
