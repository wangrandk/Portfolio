%DRAW_SLINKY - Draw a slinky with shape y(l).
%
%   draw_slinky(t, y, l, diameter, coils)
%   draw_slinky(t, y, l, diameter, coils, skip_frames)
%
% Input:
%   t           time (or a timesteps x 1 vector of times)
%
%   y           vector of length (n+1) (or timesteps x (n+1) matrix) of heights 
%               for equidistant points on the slinky
%
%   l           (n+1) x 1 vector of equidistant points on the slinky
%
%   diameter    diameter of slinky coils
%
%   viklinger   number of slinky coils
%
%   skip_frames show only every skip_frames'th frame (default = 1)
%
% Output:
%
function draw_slinky(t, y, l, diameter, coils, skip_frames)
if nargin < 5
    error('draw_slinky : Too few input arguments')
end
if nargin < 6
    skip_frames = 1; % show every frame by default
end
if size(y,1) ~= 1 && size(y,2) == 1, y = y'; end; % fix if y is column vector
if length(t) ~= size(y,1)
    error('draw_slinky : Length of the t vector must be the same as the number of rows in y')
end    
n = length(l)-1;
s = linspace(0, 2*pi*coils, n+1);
xk = diameter*sin(s)/2;
yk = diameter*cos(s)/2;
colormap hsv;
ck = l./max(l); % color the slinky
for i = 1:length(t)
    if i == 1 || i == length(t) || mod(i, skip_frames) == 0
        cla;
        zk = y(i,1:n+1);
        cline(xk, yk, zk, ck); view(3);
        hold on;
        axis equal;
        zlim([0 diameter*23]);
        title(['t = ' sprintf('%2.4f', t(i))]);
        set(gca,'ZDir','rev');
        axis off;
        drawnow;
    end
end

function cline(x, y, z, cdata)
% Thanks to 
% S. Hölz, TU-Berlin, seppel_mit_ppATweb.de
% who made the original "cline.m" code used in part below
if nargin == 2
    p = patch([x(:)' nan], [y(:)' nan], 0);
    cdata = [y(:)' nan];
elseif nargin == 3
    p = patch([x(:)' nan], [y(:)' nan], [z(:)' nan], 0);
    cdata = [z(:)' nan];
elseif nargin == 4
    if isempty(z); z = zeros(size(x)); end
    p = patch([x(:)' nan], [y(:)' nan], [z(:)' nan], 0);
    cdata = [cdata(:)' nan];
end
set(p,'cdata', cdata, 'edgecolor','interp','facecolor','none')
