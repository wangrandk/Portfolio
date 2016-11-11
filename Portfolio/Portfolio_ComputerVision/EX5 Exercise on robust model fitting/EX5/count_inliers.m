function [inlier pp] = count_inliers(l,p,t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
np =size(p,2);
inlier=0;
for i=1:np
    if isinlier(l,p(:,i),t)==1;
        inlier=inlier+1;
        pp(:,i) = p(:,i);
    end 
end       
end

