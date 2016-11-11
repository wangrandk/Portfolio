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
d = sampsonFun(F,p1,p2)
thr = quantile(d,10)
sigma=3;
thresh = 3.84 * sigma^2;
for i= 1:size(d,2)
    if d(i) >= thresh
        p1(:,i)=0;
        p2(:,i)=0;
    else
       pf1(:,i) = p1(:,i);
       pf2(:,i) = p2(:,i); 
    end
end
np1 = nonzeros(pf1);
np2 = nonzeros(pf2);
s = size(np1,1)/2
pp1 = reshape(np1,2,s);
pp2 = reshape(np2,2,s); 
%% 
% figure(4)
figure(1)
subplot(1,2,1)
imshow(im1);hold on
plot(pp1(1,:),pp1(2,:),'ro');hold on
subplot(1,2,2)
imshow(im2);hold on
plot(pp2(1,:),pp2(2,:),'bo')
saveas(gcf,'SIFTmatchingPoints.png')
hold off
figure(2)
showMatchedFeatures(I,I2,pp1',pp2','montage');
saveas(gcf,'Epipolar Geometry montage.png')
