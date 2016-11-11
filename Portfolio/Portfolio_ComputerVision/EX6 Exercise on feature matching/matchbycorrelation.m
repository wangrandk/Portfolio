function [m1, m2, p1ind, p2ind, cormat] = ...
                  matchbycorrelation(im1, p1, im2, p2, w, dmax)

if nargin == 5
    dmax = Inf;
end

im1 = double(im1);
im2 = double(im2);

% Subtract image smoothed with an averaging filter of size wXw from
% each of the images.  This compensates for brightness differences in
% each image.  Doing it now allows faster correlation calculation.
im1 = im1 - filter2(fspecial('average',w),im1);
im2 = im2 - filter2(fspecial('average',w),im2);    

% Generate correlation matrix
cormat = correlatiomatrix(im1, p1, im2, p2, w, dmax);
[corrows,corcols] = size(cormat);

% Find max along rows give strongest match in p2 for each p1
[mp2forp1, colp2forp1] = max(cormat,[],2);

% Find max down cols give strongest match in p1 for each p2    
[mp1forp2, rowp1forp2] = max(cormat,[],1);    

% Now find matches that were consistent in both directions
p1ind = zeros(1,length(p1));  % Arrays for storing matched indices
p2ind = zeros(1,length(p2));    
indcount = 0;    
for n = 1:corrows
    if rowp1forp2(colp2forp1(n)) == n  % consistent both ways
        indcount = indcount + 1;
        p1ind(indcount) = n;
        p2ind(indcount) = colp2forp1(n);
    end
end

% Trim arrays of indices of matched points
p1ind = p1ind(1:indcount);    
p2ind = p2ind(1:indcount);        

% Extract matched points from original arrays
m1 = p1(:,p1ind);  
m2 = p2(:,p2ind);    