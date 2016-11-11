clear all
clc
close all
run('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
load('Ex9_PingData.mat');
%%
figure(1)
subplot(2,2,1);imshow(BaseL);title('BackGroundL');
figure(2)
for i =1:24
subplot(4,6,i);imshow(ImL{i});title('Current FrameL');
end
[Background_hsv]=round(rgb2hsv(BaseL));
for i = 1:24
[CurrentFrame_hsv{i}]=round(rgb2hsv(ImL{i}));
end

for i = 1:24
Out{i} = bitxor(Background_hsv,CurrentFrame_hsv{i}); %bitxor: same element retures 0, different elements retures 1.
% figure(3)
% subplot(4,6,i);imshow(Out{i})
Out{i}=rgb2gray(Out{i});
% figure(4)
% subplot(4,6,i);imshow(Out{i})
[rows{i} columns{i}]=size(Out{i});
end

%Convert to Binary Image
for i=1:480
   for j=1:640
        for k = 1:24
        if Out{k}(i,j) >0
            BinaryImage{k}(i,j)=1;
        else
            BinaryImage{k}(i,j)=0;
        end
        end
    end
end
%%
for i = 1:24
%     figure(5)
%         subplot(4,6,i);imshow(BinaryImage{i})
%Apply Median filter to remove Noise
FilteredImage{i}= medfilt2(BinaryImage{i},[13 13]);
% FilteredImage{3}= medfilt2(BinaryImage{3},[5 5]);
% figure(6)
% subplot(4,6,i);imshow(FilteredImage{i})
figure(7)
%containing labels for the connected objects in BW. The variable 
%n can have a value of either 4 or 8
[L{i} num{i}]= bwlabel(FilteredImage{i});
subplot(4,6,i);imshow(L{i})
% measures a set of properties for each connected component (object) in 
%the binary image, num returns the number of connected objects found 
STATS{i}=regionprops(L{i},'all');
end
%%
%Remove the noisy regions 
% for i =1:24
% % for j=1:size(STATS{i},1)
% %   n{i} = cell2mat(STATS{i}); 
%   x{i} = struct2cell(STATS{i});
% %   k= cell2mat(x{i});
% end
% end

%%
%   x = struct2cell(STATS{4});
%   k= cell2mat(x(1,:));
%%
maxArea = 0;
for i=1:24
    for j = size(STATS{i},1)
        dd = STATS{i}(j).Area;
           if dd > maxArea;
              maxArea = dd;
                index {i} = j;  
% maxArea(i,1) = max(STATS{i}.Area);
% if (dd(i,1) < maxArea(i,1))
% L(L==i)=0;
% removed = removed + 1;
% num=num-1;
else
end
end
    end

[L2 num2]=bwlabel(L);
% Trace region boundaries in a binary image.
[B,L,N,A] = bwboundaries(L2);
%Display results
subplot(2,2,3),  imshow(L2);title('BackGround Detected L');
subplot(2,2,4),  imshow(L2);title('Blob Detecte L');hold on;
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
