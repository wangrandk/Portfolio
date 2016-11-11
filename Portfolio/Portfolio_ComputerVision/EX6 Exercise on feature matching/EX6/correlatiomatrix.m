function cormat = correlatiomatrix(im1, p1, im2, p2, w, dmax)

if mod(w, 2) == 0
    error('Window size should be odd');
end

[rows1, npts1] = size(p1);
[rows2, npts2] = size(p2);    

% Initialize correlation matrix values to -infinty
cormat = -ones(npts1,npts2)*Inf;

if (rows1 ~= 2 || rows2 ~= 2)
    error('Feature points must be specified in 2xN arrays');
end

[im1rows, im1cols] = size(im1);
[im2rows, im2cols] = size(im2);    

r = w;   % 'radius' of correlation window

% For every feature point in the first image extract a window of data
% and correlate with a window corresponding to every feature point in
% the other image.  Any feature point less than distance 'r' from the
% boundary of an image is not considered.

% Find indices of points that are distance 'r' or greater from
% boundary on image1 and image2;
n1ind = find(p1(1,:)>r & p1(1,:)<im1rows+1-r & ...
    p1(2,:)>r & p1(2,:)<im1cols+1-r);

n2ind = find(p2(1,:)>r & p2(1,:)<im2rows+1-r & ...
    p2(2,:)>r & p2(2,:)<im2cols+1-r);    

for n1 = n1ind            
    % Generate window in 1st image   	
    w1 = im1(p1(1,n1)-r:p1(1,n1)+r, p1(2,n1)-r:p1(2,n1)+r);
    % Pre-normalise w1 to a unit vector.
    w1 = w1./sqrt(sum(sum(w1.*w1)));

    % Identify the indices of points in p2 that we need to consider.
    if dmax == inf
	n2indmod = n2ind; % We have to consider all of n2ind
    
    else     % Compute distances from p1(:,n1) to all available p2.
	p1pad = repmat(p1(:,n1),1,length(n2ind));
	dists2 = sum((p1pad-p2(:,n2ind)).^2);
	% Find indices of points in p2 that are within distance dmax of
        % p1(:,n1) 
	n2indmod = n2ind(find(dists2 < dmax^2)); 
    end

    % Calculate normalised correlation measure.  Note this gives
    % significantly better matches than the unnormalised one.

    for n2 = n2indmod 
        % Generate window in 2nd image
        w2 = im2(p2(1,n2)-r:p2(1,n2)+r, p2(2,n2)-r:p2(2,n2)+r);
        cormat(n1,n2) = sum(sum(w1.*w2))/sqrt(sum(sum(w2.*w2)));
    end
end