clear all
close all
clc
% sobel
A = imread('BookImage.jpg');
B=rgb2gray(A);
C=double(B);
for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %Sobel mask for x-direction:
        Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        %Sobel mask for y-direction:
        Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
      
        %The gradient of the image
        %B(i,j)=abs(Gx)+abs(Gy);
       
%         if (Gx)^2+(Gy)^2 > sqrt(0.1)
%            B(i,j)=(Gx)^2+(Gy)^2;
%         end
        B(i,j)=sqrt(Gx.^2+Gy.^2);
      
    end
end
figure,imshow(B); title('Sobel gradient');

% threshold value
Thresh=90;
B=max(B,Thresh);
B(B<=round(Thresh))=0;
B=uint8(B);
figure,imshow(B);title('Edge detected Image');

figure
B_edge = edge(B,'sobel',0.03);
imshow(B_edge);

%hough transform
[H,T,R] = hough(B);
figure('name','hough space')
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P= houghpeaks(H, 5);
BW = hough_bin_pixels(B, T, R, P(2,:));
%lines = houghlines(B, T, R, P,'FillGap',5,'MinLength',7);
figure, imshow(BW)
title('Pixels corresponding to maximum Hough transform bin')
% overlay those pixels in color on original image
rgb = imoverlay(B, imdilate(BW,ones(3,3)), [.6 .6 1]);
imshow(rgb)
