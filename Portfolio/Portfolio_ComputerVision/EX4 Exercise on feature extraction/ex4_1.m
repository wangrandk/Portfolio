clear all
clc
close all

%  im = imread('TestIm1.bmp');
im = imread('House1.bmp');
radius = 2;
sigma = 1.6;
k = 0.04;
t=sigma*sigma;
x=-3*ceil(sigma):3*ceil(sigma);
g=exp(-x.*x./(2*t))/sqrt(2*pi*t);
gx=(-x/t).*exp(-x.*x./(2*t))/sqrt(2*pi*t);
% Q1. Question: Why is the rang of x set as it is?
% because the x needs to be a odd number in order to make the Gaussian
% kernel, the x is set as such, so the size of x is alway a multiplication
% of rounded sigma.
Ix= filter2(gx,im,'same');
Ix= filter2(g',Ix,'same');
Iy= filter2(g,im,'same');
Iy= filter2(gx',Iy,'same');
Ixy = filter2(gx, Ix.*Iy, 'same');
Ixy1 = filter2(x, Ix.*Iy, 'same');
figure(1)
subplot(1,2,1)
imshow(Ixy);
subplot(1,2,2)
imshow(Ixy1)
%Q.3
Ix2 = filter2(g, Ix.^2, 'same');
Iy2 = filter2(g, Iy.^2, 'same');
Ixy2 = filter2(g, Ix.*Iy, 'same');
figure(2)
subplot(1,3,1)
imshow(Ix2);
subplot(1,3,2)
imshow(Iy2);
subplot(1,3,3)
imshow(Ixy); %less detail, only corners left
%cim = (Ix2*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);

cim = (Ix2.*Iy2 - Ixy2.^2) - k*(Ix2 + Iy2).^2;
figure(3)
imshow(cim);
maxcim = max(cim(:));
%sze = 2*radius+1;                   
%mx = ordfilt2(cim,sze^2,ones(sze)); 

t = maxcim*0.025; %0.025
cim(cim < t)=0; %non-maximum suppression
figure(4)
imshow(cim);
[r, c] = find(cim>0);
% cim = (cim == maxcim) & (cim > maxcim*0.1);
% for i = r'
%     for j=c'
% cim_new(i,j) = (cim(i,j) > cim(i+1,j)) & (cim(i,j) >= cim(i-1,j)) & (cim(i,j) > cim(i,j+1)) & (cim(i,j) >= cim(i,j-1));
%    end
% end

%house
for i=sort(r(r>2))-1;
    for j=sort(c(c>2))-1;
cim_new(i,j) = (cim(i,j) > cim(i+1,j)) & (cim(i,j) >= cim(i-1,j)) & (cim(i,j) > cim(i,j+1)) & (cim(i,j) >= cim(i,j-1));
%cim_new(r,c) = (cim(r,c) > cim(r+1,c)) & (cim(r,c) >= cim(r-1,c)) & (cim(r,c) > cim(r,c+1)) & (cim(r,c) >= cim(r,c-1));  
 end
end

figure(5), imshow(im), axis image, colormap(gray), hold on
plot(c,r,'g*'), title('corners detected');
         
%I_edge = edge(im, 'canny',0.00001);
%figure(6)
%imshow(I_edge);