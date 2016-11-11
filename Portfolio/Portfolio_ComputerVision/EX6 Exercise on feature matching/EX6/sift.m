clear all 
close all
load('TwoImageData.mat')
%%
('C:\Users\RAN\OneDrive\Documents\vlfeat-0.9.20-bin.tar\vlfeat-0.9.20/toolbox/vl_setup')
%%
I=single(im1);

% compute the SIFT frames (keypoints) and descriptors
[f,d] = vl_sift(I) ;
%f:disk of center f(1:2), scale f(3) and orientation f(4) 
figure(1)
imshow(im1),hold on
% h1 = vl_plotframe(f(:,:)) ;
% h2 = vl_plotframe(f(:,:)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;

perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

%overlay the descriptors 
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel));

%extract and match the descriptors 
Ia=single(im1);
Ib=single(im2);
figure(2)
[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);
[matches, scores] = vl_ubcmatch(da, db) ; %descriptor in da, vl_ubcmatch finds the closest descriptor in db
set(h3,'color','g') ;

%%
I = double(rand(100,500) <= .005) ;
I = (ones(100,1) * linspace(0,1,500)) .* I ;
I(:,1) = 0 ; I(:,end) = 0 ;
I(1,:) = 0 ; I(end,:) = 0 ;
I = 2*pi*4^2 * vl_imsmooth(I,4) ;
I = single(255 * I) ;
peak_thresh=10;
f = vl_sift(I, 'PeakThresh', peak_thresh) ;

%%
I = zeros(100,500) ;
for i=[10 20 30 40 50 60 70 80 90]
I(50-round(i/3):50+round(i/3),i*5) = 1 ;
end
I = 2*pi*8^2 * vl_imsmooth(I,8) ;
I = single(255 * I) ;
%%
% compute the descriptor of a SIFT frame centered at position (100,100), of scale 10 and orientation -pi/8
fc = [100;100;10;-pi/8] ;
[f,d] = vl_sift(I,'frames',fc) ;
figure(3)
h4 = vl_plotframe(f(:,sel));
h5 = vl_plotsiftdescriptor(d(:,sel),f(:,sel));
set(h1,'color','k','linewidth',3) ;