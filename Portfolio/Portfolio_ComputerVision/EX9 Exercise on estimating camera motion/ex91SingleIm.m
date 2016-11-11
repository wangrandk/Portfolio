clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
load('Ex9_PingData.mat');
%% Left Camera 1
figure(1)
subplot(2,2,1);imshow(ImL{1});title('Current FrameL');
[Background_hsv]=round(rgb2hsv(BaseL));
[CurrentFrame_hsv]=round(rgb2hsv(ImL{1}));
Out = bitxor(Background_hsv,CurrentFrame_hsv); %bitxor: same element retures 0, different elements retures 1.
% figure(3)
subplot(2,2,2);imshow(Out)
Out=rgb2gray(Out);
% figure(4)
subplot(2,2,3);imshow(Out)
[rows columns]=size(Out);

%Convert to Binary Image
for i=1:rows
   for j=1:columns
        if Out(i,j) >0
            BinaryImage(i,j)=1;
        else
            BinaryImage(i,j)=0;
        end
        end
end
%% Left Camera 2
        subplot(2,2,4);imshow(BinaryImage)
        %Apply Median filter to remove Noise
FilteredImage= medfilt2(BinaryImage,[5 5]);
% figure(6)
% subplot(4,6,i);imshow(FilteredImage{i})
%containing labels for the connected objects in BW. The variable 
%n can have a value of either 4 or 8
[L num]= bwlabel(FilteredImage);
figure(2)
subplot(2,2,1);imshow(L)
% measures a set of properties for each connected component (object) in 
%the binary image, num returns the number of connected objects found 
STATS=regionprops(L,'all');
cc=[];
removed=0;
%%Remove the noisy regions 
for i=1:num
dd=STATS(i).Area;
if (dd < 80)
L(L==i)=0;
removed = removed + 1;
num=num-1;
else
    indexL = i;
end
end
[L2 num2]=bwlabel(L);
% Trace region boundaries in a binary image.
[B,L,N,A] = bwboundaries(L2);
%Display results
subplot(2,2,2),  imshow(L2);title('BackGround Detected L');
subplot(2,2,3),  imshow(L2);title('Blob Detecte L');hold on;
for k=1:length(B)
% if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',1);
% for l=find(A(:,k))'
% boundary = B{l};
% plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
% end
end
%end
%% Right Camera 1
figure(1)
subplot(2,2,1);imshow(ImR{1});title('Current FrameL');
[Background_hsv]=round(rgb2hsv(BaseR));
[CurrentFrame_hsv]=round(rgb2hsv(ImR{1}));
Out = bitxor(Background_hsv,CurrentFrame_hsv); %bitxor: same element retures 0, different elements retures 1.
% figure(3)
subplot(2,2,2);imshow(Out)
Out=rgb2gray(Out);
% figure(4)
subplot(2,2,3);imshow(Out)
[rows columns]=size(Out);

%Convert to Binary Image
for i=1:rows
   for j=1:columns
        if Out(i,j) >0
            BinaryImage(i,j)=1;
        else
            BinaryImage(i,j)=0;
        end
        end
end
%% Right Camera 2
        subplot(2,2,4);imshow(BinaryImage)
        %Apply Median filter to remove Noise
FilteredImage= medfilt2(BinaryImage,[5 5]);
% figure(6)
% subplot(4,6,i);imshow(FilteredImage{i})
%containing labels for the connected objects in BW. The variable 
%n can have a value of either 4 or 8
[L num]= bwlabel(FilteredImage);
figure(2)
subplot(2,2,1);imshow(L)
% measures a set of properties for each connected component (object) in 
%the binary image, num returns the number of connected objects found 
STATS=regionprops(L,'all');
cc=[];
removed=0;
%%Remove the noisy regions 
for i=1:num
Mdd(i)=STATS(i).Area;
end
[Max,indexR] = max(Mdd)
for i =1:num
dd=STATS(i).Area;
if (dd < Max)
L(L==i)=0;
removed = removed + 1;
num=num-1;
else
    
end
end
[L2 num2]=bwlabel(L);
% Trace region boundaries in a binary image.
[B,L,N,A] = bwboundaries(L2);
%Display results
subplot(2,2,2),  imshow(L2);title('BackGround Detected L');
subplot(2,2,3),  imshow(L2);title('Blob Detecte L');hold on;
for k=1:length(B)
% if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',1);
% for l=find(A(:,k))'
% boundary = B{l};
% plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
% end
end
%% 2
% [fa, da] = vl_sift(single(rgb2gray(BaseL)));
% [fb, db] = vl_sift(single(rgb2gray(BaseR)));
% [matches, scores] = vl_ubcmatch(da, db);
% nMatch=size(matches,2);
% X1 = fa(1:2,matches(1,:));
% X2 = fb(1:2,matches(2,:)); 
% figure(1)
% showMatchedFeatures(BaseL,BaseR,X1',X2','montage');
s=size(matches,2);
% X1=[X1;ones(1,s)];
% X2=[X2;ones(1,s)];
q1 = STATS(indexL).Centroid;
q2 = STATS(indexR).Centroid; 
[Q1,B]=Est3D(q1,CamL,q2,CamR);
%%
for i =1: s
   Q1{i}(1) = Q1{i}(1)/Q1{i}(4);
   Q1{i}(2) = Q1{i}(2)/Q1{i}(4);
   Q1{i}(3) = Q1{i}(3)/Q1{i}(4);
   plot3(Q1{i}(1),Q1{i}(2),Q1{i}(3))
end
plot3()
