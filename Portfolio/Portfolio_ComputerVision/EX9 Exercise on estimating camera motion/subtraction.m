clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
load('Ex9_PingData.mat');
%% -------------------------CamL-------------------------------------------------
% figure(1)
% subplot(2,2,1);imshow(BaseL);title('BackGroundL');
figure(2)
for i =1:24
subplot(4,6,i);
s{i} = imabsdiff(ImL{i},BaseL);
imshow(s{i});title('subtract FrameL');
saveas(gcf,'CamLAbsDiff.png')
end
%%
for i = 1:24
BW{i} = im2bw(s{i}, 0.05)
figure(3)
subplot(4,6,i);imshow(BW{i})
end
%%
for i = 1:24
FilteredImage{i}= medfilt2(BW{i},[9 9]); % adjust the kernel until all noise are eliminated,looking at 'STATS'
figure(6)
subplot(4,6,i);imshow(FilteredImage{i})
figure(7)
%containing labels for the connected objects in BW. The variable 
%n can have a value of either 4 or 8
[L{i} num{i}]= bwlabel(FilteredImage{i});
subplot(4,6,i);imshow(L{i}) 

figure(8)
% dilate the ball
se = strel('disk',20,8);
ImDilated{i} = imdilate(L{i},se);
subplot(4,6,i);imshow(ImDilated{i}) 
STATS{i}=regionprops(ImDilated{i},{'BoundingBox','Centroid'});
saveas(gcf,'CamLDialation.png')
end
% Trace region boundaries in a binary image.
%%
for i =1:24
centroids{i} = cat(1, STATS{i}.Centroid);
boundingboxes{i} = cat(1, STATS{i}.BoundingBox);
T=cell2table(centroids);
A = table2array(T)
hold on
figure(9)
plot(centroids{i}(:,1), centroids{i}(:,2), 'o')
axis([0 640 0 480])
% for k = 1:size(boundingboxes{i},1)
    rectangle('position',boundingboxes{i}(1,:),'Edgecolor','g')
% end
saveas(gcf,'CamLpengpang.png')
end
%% 2d points of CamL
 i= 1:24
    yl = A(1,2*i);
    xl = A(1,2*i-1);
    ql = [xl;yl];

    
    
    
    
    %% -------------------------CamR-------------------------------------------------
% figure(9)
% subplot(2,2,1);imshow(BaseR);title('BackGroundL');
figure(10)
for i =1:24
subplot(4,6,i);
s{i} = imabsdiff(ImR{i},BaseR);
imshow(s{i});title('subtract FrameL');
end
%%
for i = 1:24
BW{i} = im2bw(s{i}, 0.03);
figure(11)
subplot(4,6,i);imshow(BW{i});
% end
% 
% for i = 1:24
% FilteredImage{i}= medfilt2(BW{i},[9 9]); % adjust the kernel until all noise are eliminated,looking at 'STATS'
h = fspecial('disk',30);
FilteredImage{i}= imfilter(im2double(BW{i}),h,'replicate');
figure(12)
subplot(4,6,i);imshow(FilteredImage{i})
end
%% 
for i = 1:24
BW1{i} = im2bw(FilteredImage{i}, 0.05);
figure(13)
subplot(4,6,i);imshow(BW1{i});
saveas(gcf,'CamLBW.png')
end
%% search the circles
figure(14)
for i = 1:24
    [centers{i}, radii{i}, metric{i}] = imfindcircles(BW1{i},[5 31]);
    centersStrong{i} = centers{i}(1,:);
    radiiStrong{i} = radii{i}(1);
    metricStrong{i} = metric{i}(1);
   subplot(4,6,i);imshow(BW1{i});hold on;axis([0 640 0 480]);
   viscircles(centersStrong{i}, radiiStrong{i},'EdgeColor','b');
   saveas(gcf,'CamLCircle.png')
%    figure(15)
%    subplot(4,6,i);axis([0 640 0 480]);
%    viscircles(centersStrong{i}, radiiStrong{i},'EdgeColor','b*');
end
%%
% for i = 1:24
% figure(13)
% [L{i} num{i}]= bwlabel(FilteredImage{i});
% subplot(4,6,i);imshow(L{i}) 
% STATS{i}=regionprops(L{i},{'BoundingBox','Centroid'});
% end
% Trace region boundaries in a binary image.
%%
for i =1:24
centroids1{i} = cat(1, centers{i});
% boundingboxes{i} = cat(1, STATS{i}.BoundingBox);
T1=cell2table(centroids1);
A1 = table2array(T1);
hold on
figure(15)
plot(centroids1{i}(:,1), centroids1{i}(:,2), 'o')
axis([0 640 0 480])
saveas(gcf,'CamLPengPang.png')
end
%% 2d points of CamL
 i= 1:24
    yr = A1(1,2*i);
    xr = A1(1,2*i-1);
    qr = [xr;yr];
    
    %% 3D point triangulation from camera matrices and 2D points,linear algorithm
s=size(ql,2);
[Q,B]=threeD_point_tri(ql,CamL,qr,CamR,s);
Q1=cell2mat(Q) 
%% 3D position of 24 images using plot3
% for i = 1:24
%     Q1 = Q1/norm(Q1)
% rotate3d on
figure(16)
     plot3(Q1(1,:),Q1(2,:),Q1(3,:));
     xlabel('x');
     ylabel('y');
     zlabel('z');
     saveas(gcf,'3Dplot.png')
% end
% rotate3d off
   

    