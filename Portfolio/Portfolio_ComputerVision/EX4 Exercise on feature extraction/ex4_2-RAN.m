clear all
close all
clc
% THRESH is a two-element vector in which the first element
%     is the low threshold, and the second element is the high threshold. If
%     you specify a scalar for THRESH, this value is used for the high
%     threshold and 0.4*THRESH is used for the low threshold. If you do not
%     specify THRESH, or if THRESH is empty ([]), edge chooses low and high
%     values automatically.
% BW = edge(I,'canny',THRESH,SIGMA) specifies the Canny method, using
%     SIGMA as the standard deviation of the Gaussian filter. The default
%     SIGMA is sqrt(2); the size of the filter is chosen automatically, based
%     on SIGMA.

im1 = imread('House1.bmp');
im2 = imread('House2.bmp');
im3 = imread('TestIm1.bmp');
im4 = imread('TestIm2.bmp');
im_edge1 = edge(im4, 'canny',[0.1 0.2],0.9);
im_edge2 = edge(im4, 'canny' , [0.1 0.2],0.1);
im_edge3 = edge(im4, 'canny' ,[0.6,0.99],0.9);
im_edge4 = edge(im4, 'canny' ,[0.6,0.99],0.1); %big sigma gives dominant edge
figure(1)
subplot(2,2,1);
imshow(im_edge1);
subplot(2,2,2);
imshow(im_edge2);
subplot(2,2,3);
imshow(im_edge3);
subplot(2,2,4);
imshow(im_edge4);

% for i=sort(r(r>2))-1;
%     for j=sort(c(c>2))-1;
% cim_new(i,j) = (cim(i,j) > cim(i+1,j)) & (cim(i,j) >= cim(i-1,j)) & (cim(i,j) > cim(i,j+1)) & (cim(i,j) >= cim(i,j-1));
% %cim_new(r,c) = (cim(r,c) > cim(r+1,c)) & (cim(r,c) >= cim(r-1,c)) & (cim(r,c) > cim(r,c+1)) & (cim(r,c) >= cim(r,c-1));  
%  end
% end