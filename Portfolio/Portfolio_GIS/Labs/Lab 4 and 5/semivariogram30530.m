function sv = semivariogram30530(X,nlag,lagdist)

% sv = semivariogram_simple(X,nlag,lagdist);
%
% calculate omni-directional a.k.a. isotropic semi-variogram for 2D data
%
% Input
% X         - input data matrix with three columns
%             col 1 is x-coord, col 2 is y-coord, col 3 is variable
% nlag      - number of lags (number of lags in output is actually nlag+2)
% lagdist   - lag separation distance
%
% Output
% sv        - output data matrix with three columns
%             col 1 is number of point pairs
%             col 2 is lag distance
%             col 3 is the semi-variogram value
% NaN(M,N) or NaN([M,N]) is an M-by-N matrix of NaNs.
% NaN(M,N,P,...) or NaN([M,N,P,...]) is an M-by-N-by-P-by-... array of NaNs.
% Allan Aasbjerg Nielsen, Ph.D., M.Sc.
% aa@space.dtu.dk, www.imm.dtu.dk/~aa
% 26 Jan 2013

if nargin<3
    error('you must specify X, number of lags and lag separation distance');
end

[n m] = size(X);
if m>3, error('more than three columns not allowed'); end

dist = pdist(X(:,1:2));
pc = pdist(X(:,3)).^2;
dx=pdist(X(:,1));
dy=pdist(X(:,2)); %dy=0 means vertical dist is 0,point in the same row
sv = nan(nlag+2,3); %(6x3 matrix)
idx = find(dist==0);
sv(1,:) = [size(idx,2) mean(dist(idx)) 0.5*mean(pc(idx))];
idx = find(0<dist & dist<=(lagdist/2)); % 0<dist<=50
sv(2,:) = [size(idx,2) mean(dist(idx)) 0.5*mean(pc(idx))];
for ii=3:(nlag+2)
    idx = find((2*ii-5)*(lagdist/2)<dist & dist<=(2*ii-3)*(lagdist/2) & dy==0); %find((50:100:350)<dist<(150:100:450))
    sv(ii,:,1) = [size(idx,2) mean(dist(idx)) 0.5*mean(pc(idx))];
end
for ii=3:(nlag+2)
    idx = find((2*ii-5)*(lagdist/2)<dist & dist<=(2*ii-3)*(lagdist/2) & dx==0);
    sv(ii,:,2) = [size(idx,2) mean(dist(idx)) 0.5*mean(pc(idx))];
end
