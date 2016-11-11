clear all, clc, close all
load('TwoImageData.mat')
% figure(1)
%  imshow(im1)
 %r = xcorr2(im1,im2)
 %%
radius = 1;
sigma = 1.6;
k = 0.15;
t=sigma*sigma;
x=-3*ceil(sigma):3*ceil(sigma);
g=exp(-x.*x./(2*t))/sqrt(2*pi*t);
gx=(-x/t).*exp(-x.*x./(2*t))/sqrt(2*pi*t);

Ix= filter2(gx,im2,'same');
Ix= filter2(g',Ix,'same');
Iy= filter2(g,im2,'same');
Iy= filter2(gx',Iy,'same');

Ix2 = filter2(g, Ix.^2, 'same');
Iy2 = filter2(g, Iy.^2, 'same');
Ixy2 = filter2(g, Ix.*Iy, 'same');
figure(2)
subplot(1,3,1)
imshow(Ix2);
subplot(1,3,2)
imshow(Iy2);
subplot(1,3,3)
imshow(Ixy2); %less detail, only corners left

cim = (Ix2.*Iy2 - Ixy2.^2) - k*(Ix2 + Iy2).^2;
figure(3)
imshow(cim);
maxcim = max(cim(:));

t = maxcim*0.025; %0.025
cim(cim < t)=0; %non-maximum suppression
figure(4)
imshow(cim);
[r, c] = find(cim>0);
n=4;
s=2*n+1;
for i=sort(r(r>2))-1;
    for j=sort(c(c>2))-1;
p(i,j) = (cim(i,j) > cim(i+1,j)) & (cim(i,j) >= cim(i-1,j)) & (cim(i,j) > cim(i,j+1)) & (cim(i,j) >= cim(i,j-1));
%cim_new(r,c) = (cim(r,c) > cim(r+1,c)) & (cim(r,c) >= cim(r-1,c)) & (cim(r,c) > cim(r,c+1)) & (cim(r,c) >= cim(r,c-1));  
    end
end
[r1,c1]=find(p>0);


figure(5), imshow(im2), axis image, colormap(gray), hold on
plot(c1,r1,'g*'), title('corners detected');
figure(6) 
[r2, c2] = corner_detection(im2);
% P2= imcrop(im2,[c1(1),r1(1),s,s])
% P1= imcrop(im1,[c1(1),r1(1),s,s])
% p1=[c1(2:5),r1(2:5)];
% p2=[c1(6:9),r1(6:9)];
% [f1, vpts1] = extractFeatures(im1, p1);
% [f2, vpts2] = extractFeatures(im2, p2);
% indexPairs = matchFeatures(f1, f2) ;
% matchedPoints1 = vpts1(indexPairs(1:20, 1));
% matchedPoints2 = vpts2(indexPairs(1:20, 2));
% figure(7); ax = axes;
% showMatchedFeatures(im1,im2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
% title(ax, 'Candidate point matches');

p1=[r1,c1]';
p2=[r2,c2]';
im1(p1)

% subplot(1,2,1)
% imshow(p1)
% subplot(1,2,2)
% imshow(p2);
dmax=inf;
[m1, m2, p1ind, p2ind, cormat] = matchbycorrelation(im1, p1, im2, p2, s, dmax);
figure(8)
showMatchedFeatures(im1,im2,m1',m2','montage');
% S1=sum(P1);S2=sum(P2);S11=sum(P1.^2);S12=sum(P1.*P2);S22=sum(P2.^2);
% nn=size(P1,1);
% cov = (1/nn-1)*(S12-((S1.*S2)/nn));
% var1 = (1/nn-1)*(S11-((S1.^2)/nn));
% var2 = (1/nn-1)*(S22-((S2.^2)/nn));
% 
% % cov=cov(P1,P2);
% % var1 = var(P1);
% % var2 = var(P2);
% cor = cov/sqrt(var1.*var2)

 
 %%

