function [inlier, inp,outp] = count_inliers(l,p,t)

np =size(p,2);
inlier=0;
for i=1:np
    if isinlier(l,p(:,i),t)==1;
        inlier=inlier+1;
        inp(:,i) = p(:,i);
    else
        outp(:,i) = p(:,i);
    end 
end       
end

