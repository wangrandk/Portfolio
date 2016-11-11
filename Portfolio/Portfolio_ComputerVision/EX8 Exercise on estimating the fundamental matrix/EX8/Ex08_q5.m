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
F1 = Fest_8point(pp1,pp2);
%%
t_cross = CrossOp(T2);
F = pinv(A)' * t_cross * R2 * A^-1;
d = sampsonFun(F,p1,p2)
thr = quantile(d,10)
sigma=3;
thresh = 5.99 * sigma^2;
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
ppp1 = reshape(np1,2,s);
ppp2 = reshape(np2,2,s); 
%% 
% figure(4)
figure(1)
subplot(1,2,1)
imshow(im1);hold on
plot(ppp1(1,:),ppp1(2,:),'ro');hold on
subplot(1,2,2)
imshow(im2);hold on
plot(ppp2(1,:),ppp2(2,:),'bo')
saveas(gcf,'SIFTmatchingPoints.png')
hold off
figure(2)
showMatchedFeatures(I,I2,ppp1',ppp2','montage');
saveas(gcf,'Epipolar Geometry montage.png');
%% Q3
% p1=[p1;ones(1,length)];
% p2=[p2;ones(1,length)];
iter=200;
for i=1:iter
    idx=randperm(length);
    idx=idx(1:8);
    F{i} = Fest_8point(pp1(:,idx),pp2(:,idx)); %takes homo points
    inlier = 0;
for cM=1:length,
    if(FSampDist(F{i},p1(:,cM),p2(:,cM))<3.84*3^ 2) %takes non-homo points
         inlier = inlier + 1;
         tr1(:,cM) = [p1(:,cM)];
         tr2(:,cM) = [p2(:,cM)];     
    end
    inlierT(i) = inlier;
end
     tt1{i} = mat2cell(tr1);
     tt2{i} = mat2cell(tr2); 
end
%%
[val idx] = max(inlierT) % inliers 840
b=F1(:)
a=F{idx}(:)
similarity=a'*b/(norm(a)*norm(b))
%% Q4
t1 = (tt1{idx}{1});
t2 = (tt2{idx}{1});
pp1 = t1(find(t1 ~= 0));
ppp1 = reshape(pp1,2,size(pp1,1)/2);
pp2 = t2(find(t2 ~= 0));
ppp2 = reshape(pp2,2,size(pp2,1)/2);

s = size(ppp1,2);
F_refined = Fest_8point([ppp1;ones(1,s)],[ppp2;ones(1,s)])
% s = size(tt1{idx}{1},2);
F_refined = Fest_8point([tt1{idx}{1};ones(1,s)],[tt1{idx}{1};ones(1,s)])
a=F_refined(:);
b=F{idx}(:);
dist=a'*b/(norm(a)*norm(b))
%%
figure(3)
subplot(1,2,1)
imshow(im1);hold on
plot(ppp1(1,:),ppp1(2,:),'ro');hold on
subplot(1,2,2)
imshow(im2);hold on
plot(ppp2(1,:),ppp2(2,:),'bo')
saveas(gcf,'RefnedFmatchingPoints.png')
hold off

