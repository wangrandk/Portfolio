clear all
clc
close all
%%
%Q1
I = imread('BookImage.jpg');
I_gray = rgb2gray(I);
I_gray = im2double(I_gray);

I_edge = edge(I_gray, 'canny',[0.07 0.31],0.9);% recognize the full edge of the book
% I_edge = edge(I_gray, 'sobel');%10
% I_edge = edge(I_gray, 'prewitt');%10
% I_edge = edge(I_gray, 'roberts');%missed some lines, but line on text.

figure(1)
subplot(1,2,1)
imshow(I_gray);
subplot(1,2,2)
imshow(I_edge); axis on, hold on;
%end of 1
saveas(gcf,'edge.png') 
%% Q2 and 3
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

%% Q4
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

%% 5
peaks = houghpeaks(H,20,'threshold',ceil(0.5*max(H(:))));
%peaks = houghpeaks(H,20);
%end of 5

%% 6
x = T(peaks(:,2));
y = R(peaks(:,1));
h1=figure(5)
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough Transform of Book Image');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);
plot(x,y,'bs');
%end of 6

%% 7
lines = houghlines(I_edge, T, R, peaks,'FillGap',200,'MinLength',230); 
%Merged line segments shorter than 'MinLength' are discarded.
%two line segments are separated by less than 'FillGap' distance, houghlines merges them into a single line segment.
h2=figure(6)
imshow(I);
axis on, axis normal, hold on

for i = 1:length(lines)
    xy = [lines(i).point1; lines(i).point2];
    plot(xy(:,1), xy(:,2),'b--', 'linewidth', 3);
    
%     Plot beginnings and ends of the lines
    plot(xy(1,1), xy(1,2), 'x', 'linewidth', 5, 'color', 'y');
    plot(xy(2,1), xy(2,2), 'x', 'linewidth', 5, 'color', 'red');
end
saveas(h1,'houghEdge.png')
saveas(h2,'houghLines.png')
saveas(h2,'houghLines','png')
%end of 7











