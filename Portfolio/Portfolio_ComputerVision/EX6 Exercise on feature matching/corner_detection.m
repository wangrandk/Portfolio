function [r, c] = corner_detection( im )
%thresh = 20;
radius = 1;
sigma = 2;
k = 0.04;
t=sigma*sigma;
x=-3*ceil(sigma):3*ceil(sigma);
g=exp(-x.*x./(2*t))/sqrt(2*pi*t);
gx=(-x/t).*exp(-x.*x./(2*t))/sqrt(2*pi*t);
Ix= filter2(gx,im,'same');
Ix= filter2(g',Ix,'same');
Iy= filter2(g,im,'same');
Iy= filter2(gx',Iy,'same');

Ix2 = filter2(g, Ix.^2, 'same');
Iy2 = filter2(g, Iy.^2, 'same');
Ixy = filter2(g, Ix.*Iy, 'same');

%cim = (Ix2*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);

cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
maxcim = max(max(cim));
thresh = 0.08*maxcim;

sze = 2*radius+1;                   
mx = ordfilt2(cim,sze^2,ones(sze)); 
cim = (cim == mx) & (cim > thresh);
[r, c] = find(cim);

figure, imagesc(im), axis image, colormap(gray), hold on
plot(c,r,'b*'), title('corners detected');


end

