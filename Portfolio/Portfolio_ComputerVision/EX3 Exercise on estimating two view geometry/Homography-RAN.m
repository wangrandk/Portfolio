%% 3D Inference from a Plane
clear; close all;
im = imread('petergade.png');
imagesc(im);

q = ginput(4);
q = [q, ones(4,1)];
qp = [0 0 1; 610 0 1; 0 1340 1; 610 1340 1];

%% 

X1 = q';

% Normalizing q
Mean1=mean(X1')';
X1(1,:)=X1(1,:)-Mean1(1);
X1(2,:)=X1(2,:)-Mean1(2);
S1=mean(sqrt(diag(X1'*X1)))/sqrt(2);
X1(1:2,:)=X1(1:2,:)/S1;
T1=[eye(2)/S1,-Mean1(1:2)/S1;0 0 1];

% Normalizing qp
X1p = qp';
Mean1=mean(X1p')';
X1p(1,:)=X1p(1,:)-Mean1(1);
X1p(2,:)=X1p(2,:)-Mean1(2);
S1p=mean(sqrt(diag(X1p'*X1p)))/sqrt(2);
X1p(1:2,:)=X1p(1:2,:)/S1p;
T1p=[eye(2)/S1p,-Mean1(1:2)/S1p;0 0 1];

% Finding H X1(2*4)
b1 = kron(X1(:,1)', CrossOp(X1p(:,1)));
b2 = kron(X1(:,2)', CrossOp(X1p(:,2)));
b3 = kron(X1(:,3)', CrossOp(X1p(:,3)));
b4 = kron(X1(:,4)', CrossOp(X1p(:,4)));
B = [b1;b2;b3;b4]; 

[~,~,H] = svd(B);
H = H(:,end);
H = reshape(H,3,3);
H = inv(T1p)*H*T1;

%% Warping image
figure(2)
Tr = maketform('projective',H');
WarpIm = imtransform(im,Tr,'Xdata',[-100, 710], 'Ydata',[-200, 1440]);
imagesc(WarpIm)

%% Estimating players position
%close all;
imagesc(im);
q = ginput(2);
q = [q, ones(2,1)];
qp = H*q';
qp(:,1) = qp(:,1)./qp(3,1);
qp(:,2) = qp(:,2)./qp(3,2);
