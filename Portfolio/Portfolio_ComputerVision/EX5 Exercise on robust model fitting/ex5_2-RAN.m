clear all
clc
close all
% isinlier(0.6 [2;5;1] [2;5])

%%
%5.1
p1 = [2;5];
p2 = [6;8];
l = estimate_line(p1, p2)

%%
%5.2
t=1;
% l=[2;5;1];
p=[1;3];
n  = isinlier(l,p,t)

%%
%5.3
clear all
clc
close all
p1 = [2;5];
p2 = [6;8];
l = estimate_line(p1, p2)
p=RanLine(13,14); %generate non-homogeneous random points
t=1;
inlier = count_inliers(l, p, t)
plot(p(1,:),p(2,:),'ro');hold on
pfit = polyfit(p(1,:),p(2,:),1)
%use pfit to predict y
yfit = polyval(pfit,p(1,:));
plot(p(1,:),yfit,'b')
saveas(gcf,'inlierFit.png')
% yresid = p(2,:) - yfit;
% %Square the residuals and total them to obtain the residual sum of squares:
% SSresid = sum(yresid.^2);
% SStotal = (length(p(2,:))-1) * var(p(2,:));
% rsq = 1 - SSresid/SStotal
%% 5.4 rqneomly draws two of n 2D points
p=RanLine(10,6);
[p1,p2]=Ran2(p);
% n=3
% [p1,p2]=two_points(n)
%% 5.5
clear all
clc
close all
iter =6;
t=1; %the smaller the t is, the more iter needed
for i=1:iter
    in =33;
    out=30;
    p=RanLine(in,out);
    [p1,p2]=Ran2(p);
    l = estimate_line(p1, p2);
    [inlier(i) inp{i} outp{i}] = count_inliers(l, p, t);
end
inlier
[highestCon I]= max(inlier)
% inp = inp{I}
% outp = outp{I}
m = in+out;
%estimated prob of outlier
iks = 1-highestCon/m
% iteraction needed based on the estimated prob of outlier
N=log(1-0.99)/log(1-(1-iks)^2)
% plot(inp(1,:), inp(2,:),'ro',outp(1,:), outp(2,:),'go');hold on
% pfit = polyfit(inp(1,:),inp(2,:),1) % coeficients
% yfit = polyval(pfit,inp(1,:)); %evaluate coef
% plot(inp(1,:),yfit,'b')
% title('RansacFit');
% xlabel(iks)
% saveas(gcf,'RansacFit.png')
for i = 1: iter
% inp = inp{i}
% outp = outp{i}
subplot(3,2,i);
plot(inp{i}(1,:), inp{i}(2,:),'ro',outp{i}(1,:), outp{i}(2,:),'go');hold on
title(i);
pfit{i} = polyfit(inp{i}(1,:),inp{i}(2,:),1) % coeficients
yfit{i} = polyval(pfit{i},inp{i}(1,:)); %evaluate coef
plot(inp{i}(1,:),yfit{i},'b')
end
saveas(gcf,'RansacFit.png')
%% 5.6
%what is a good threshold for distinguishing between inliers and outliers?
%For line, Fundamental Matrix, Essential Matrix detection, the threshlold is recomended to be 3.84*variance
%For homography and Camera Matrix, it is 5.99*variance