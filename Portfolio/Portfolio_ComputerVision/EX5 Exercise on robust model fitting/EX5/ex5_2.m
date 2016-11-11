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
p=[2;5];
n  = isinlier(l,p,t)

%%
%5.3
clear all
clc
close all
p1 = [2;5];
p2 = [6;8];
l = estimate_line(p1, p2)
p=RanLine(13,14);
t=1;
inlier = count_inliers(l, p, t)
plot(p(1,:),p(2,:),'ro');hold on
pfit = polyfit(p(1,:),p(2,:),1)
%use pfit to predict y
yfit = polyval(pfit,p(1,:));
plot(p(1,:),yfit,'b')
% yresid = p(2,:) - yfit;
% %Square the residuals and total them to obtain the residual sum of squares:
% SSresid = sum(yresid.^2);
% SStotal = (length(p(2,:))-1) * var(p(2,:));
% rsq = 1 - SSresid/SStotal

%%
%5.4 rqneomly draws two of n 2D points
n=2
[p1,p2]=two_points(n)

%%
%5.5
clear all
clc
close all
iter =6
in =100;
out=20;
m = in+out;
p=RanLine(in,out);
for i=1:iter
n=19;
[p1,p2]=two_points(n);
store_p{:,i} = [p1 p2];
l(:,i) = estimate_line(p1, p2);

t=1; %the smaller the t is, the more iter needed
[inlier(i) pp] = count_inliers(l(:,i), p, t);

end
[highestCon I]= max(inlier)
tmp = store_p{1,I};
plot(p(1,:),p(2,:),'o'), hold on
polyfit(p(1,:),p(2,:),1);



%plot(p1,p2,'r');
hold off

% %estimated prob of outlier
ksi = 1-highestCon/m
% % iteraction needed based on the estimated prob of outlier
N=log(1-0.99)/log(1-(1-ksi)^2)
% plot(pp(1,:), pp(2,:), 'linewidth', 2, 'color', 'green');

%%
%5.6
%what is a good threshold for distinguishing between inliers and outliers?
%For line, Fundamental Matrix, Essential Matrix detection, the threshlold is recomended to be 3.84*variance
%For homography and Camera Matrix, it is 5.99*variance