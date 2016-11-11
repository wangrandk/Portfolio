clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%%
srcFiles = dir('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\ukbench\*.jpg');  % the folder in which ur images exists
for i = 1 : length(srcFiles)
    filename = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\ukbench\',srcFiles(i).name)
    I = single(rgb2gray(imread(filename)));
%     I = single(rgb2gray(I));
    %I = rgb2gray(I);
    [f,d] = vl_sift(I);
    images{i} = I;
    SIFTframes{i} = f;
    SIFTdescr{i} = d;
end
%%
srcTest = dir('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\testimage\*.jpg');
test_image_name = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\EX10 Exercise on Image search\testimage\',srcTest.name);
TestImg = imread(test_image_name);
TestImg = single(rgb2gray(TestImg));
[ft, dt] = vl_sift(TestImg);
TestImgDescr = dt;
TestImgFrames = ft;
%% 50 visual words
numClusters = 50;
for k = 1:length(srcFiles)
    data = SIFTdescr{k};
    data = single(data);
    [centers{k},mincenter{k},mindist{k},q2{k},quality{k}] = kmeans2(data, numClusters);
end

%% for each image make a K-bin histogram(mincenter) of how many SIFT features are closest to each of the K clusters
for j = 1:length(srcFiles)
    for m = 1:numClusters
        s = sum(mincenter{j} == m);
        tmp(m,1) = s;
     %how many of each of the visual words(50) does each image has   
    end
    h{j} = tmp; %50 by 99
end
%% compute the descriptor of the query image
dt = single(dt);
[centers_testimg,mincenter_testimg,mindist_testimg,q2_testimg,quality_testimg] = kmeans2(dt, numClusters);

% sqdists= sum(power(centers-repmat(feat',50,1),2),2);

for n = 1:numClusters
s_testimg = sum(mincenter_testimg == n);
tmp_testimg(n,1) = s_testimg;
end
h_testimg = tmp_testimg;

 F =@(X,Y) sum((Y-X).^2 ./(Y+X),2) % distance between histograms, where X,Y are two descriptors
for p = 1:length(srcFiles)
    D(p,1) =F(h{p}', h_testimg');
end

%%
[value, idx] = min(D);
figure(1)
subplot(2,2,1)
imshow(uint8(images{idx}));
title('matching 50')
subplot(2,2,2)
imshow(uint8(TestImg));
title('testing')
subplot(2,2,3)
figure
bar(D)
saveas(gcf,'clustering match.png')
%%
figure(2)
subplot(2,2,1)
bar(h{1,idx})
title(idx)
subplot(2,2,2)
bar(h_testimg)% query
title('testing')
subplot(2,2,3)
bar(h{1,5}) % random comparision
subplot(2,2,4)
bar(h{1,6})