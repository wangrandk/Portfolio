clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%% subtract descriptors of all images
srcFiles = dir('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\ukbench\*.jpg');  % the folder in which ur images exists
for i = 1 : length(srcFiles)
    filename = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\ukbench\',srcFiles(i).name);
    I = single(rgb2gray(imread(filename)));
    [f,d] = vl_sift(I);
    images{i} = I;
    SIFTdescr{i} = d;
end
%%
Discriptor = single(cell2mat(SIFTdescr))'; %convert descriptor to an array
numClusters = 50;
[centers,mincenter,mindist,q2,quality]  = kmeans2(Discriptor, numClusters);
%I dont understand "For each SIFT feature in each image determine which cluster it is closest to." ...
%I dont know how to draw histogram for each image, since the Discriptor
%contends all images.
%%
s = {};
for i = 1 : length(srcFiles)
    s{i} = size(SIFTdescr{i}, 2)
end 
size = cell2mat(s);
%%
histograms = zeros(23, 50);
idx = 1;
for j = 1:length(srcFiles)  
currentMinCenter  = mincenter(idx:idx + size(j) - 1);
idx = idx+ size(j);
histograms(j,:) = histc(currentMinCenter, 1:50); 
end

%% subtract descriptor of query image
srcTest = dir('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\QueryImg\*.jpg');
test_image_name = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\QueryImg\',srcTest.name);
TestImg = imread(test_image_name);
TestImg = single(rgb2gray(TestImg));
[ft, dt] = vl_sift(TestImg);
TestImgDescr = dt;
TestImgFrames = ft;
 
%% compute the descriptor of the query image
dtt = single(dt)';
% for i = 1: length(dtt)
%     minTest(i,1) = mean(dtt(i,:));
% end
% minTest = round(minTest);
% [centers_testimg,mincenter_testimg,mindist_testimg,q2_testimg,quality_testimg] = kmeans2(dtt, numClusters);
%% 
s_testimg = histc(mincenter_testimg, 1:50)';
%%
% for n = 1:numClusters
% s_testimg(n) = sum(mincenter_testimg == n);
% end
%%
 F =@(X,Y) sum((Y-X).^2 ./(Y+X),2) % distance between histograms, where X,Y are two descriptors
for p = 1:length(srcFiles)
    D(p,1) =F(histograms(p,:), s_testimg);
end
%%
[value, index] = min(D);
figure(1)
subplot(2,2,1)
imshow(uint8(TestImg)); 
title('QueryImg')
subplot(2,2,2)
imshow(uint8(images{index}));
title(index)
subplot(2,2,3)
imshow(uint8(images{index-1}));
title(index-1)
subplot(2,2,4)
imshow(uint8(images{index+1}));
title(index+1)
saveas(gcf,'clustering match.png')
figure(2)
bar(D)
saveas(gcf,'hist.png')
%%
figure(3)
subplot(2,2,1)
% hist(s_testimg,1:50)
bar(s_testimg)
title('QueryImg')
subplot(2,2,2)
% hist(histograms(index,:),1:50)
bar(histograms(index,:))
title(index)
subplot(2,2,3)
% hist(histograms(index-1,:),1:50)
bar(histograms(index-1,:))
title(index-1)
subplot(2,2,4)
% hist(histograms(index+1,:),1:50)
bar(histograms(index+1,:))
title(index+1)
saveas(gcf,'histAll.png')
 