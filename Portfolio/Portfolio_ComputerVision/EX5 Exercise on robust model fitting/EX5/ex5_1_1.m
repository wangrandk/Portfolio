clear all
clc
close all

%Q1
I = imread('BookImage.jpg');
I_gray = rgb2gray(I);
I_gray = im2double(I_gray);

%I_edge = edge(I_gray, 'canny');% recognize text and wood patterns as
%lines
%I_edge = edge(I_gray, 'sobel');%10
%I_edge = edge(I_gray, 'prewitt');%10
I_edge = edge(I_gray, 'roberts');%missed some prominent lines, but line on text.

figure(1)
imshow(I_gray);
figure(2)
imshow(I_edge);
%end of 1

%Q2 and 3
[H, T, R] = hough(I_edge);
%Hough transformation 
figure(3)
subplot(2,1,2);
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough Transform of Book Image');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);
%end of 2 and 3

%Q4
H2 = H/max(H(:));
H2 = H2.^0.5; 
figure(4)
imshow(imadjust(mat2gray(H2)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough Transform of Book Image');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);
%end of 4

%5
peaks = houghpeaks(H,20,'threshold',ceil(0.4*max(H(:))));
%peaks = houghpeaks(H,20);
%end of 5

%6
x = T(peaks(:,2));
y = R(peaks(:,1));
figure(5)
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough Transform of Book Image');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);
plot(x,y,'s','color','blue');
%end of 6

%7
lines = houghlines(I_edge, T, R, peaks);
figure(6)
% imshow(I);
hold on

for i = 1:length(lines)
    xy = [lines(i).point1; lines(i).point2];
    plot(xy(:,1), xy(:,2), 'linewidth', 2, 'color', 'green');
    
    %Plot beginnings and ends of the lines
%     plot(xy(1,1), xy(1,2), 'x', 'linewidth', 2, 'color', 'blue');
%     plot(xy(2,1), xy(2,2), 'x', 'linewidth', 2, 'color', 'red');
end
%end of 7











