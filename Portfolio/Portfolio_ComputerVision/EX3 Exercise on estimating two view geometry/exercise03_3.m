clear all 
close all
%%
%2
pg = imread('petergade.png');
figure('name','petergade')
imshow(pg)
g1 = [ginput(1) 1]';
g2 = [ginput(1) 1]';
g3 = [ginput(1) 1]';
g4 = [ginput(1) 1]';
bm = imread('badmintoncourt.png');
%figure('name','badmintoncourt');

%imshow(bm)

w = (5.18+2*0.46)*100;
l = (6.7*2)*100;
q1 = [0 0 1]';
q2 = [w 0 1]';
q3 = [0 l 1]';
q4 = [w l 1]';
q = [q1 q2 q3 q4];
%normalize picking points
X1=[g1 g2 g3 g4];
Mean1=mean(X1')';
X1(1,:)=X1(1,:)-Mean1(1);
X1(2,:)=X1(2,:)-Mean1(2);
S1=mean(sqrt(diag(X1'*X1)))/sqrt(2);
X1(1:2,:)=X1(1:2,:)/S1;
T1=[eye(2)/S1,-Mean1(1:2)/S1;0 0 1];
%normalize measured points
X1q=q;
Mean1=mean(X1q')';
X1q(1,:)=X1q(1,:)-Mean1(1);
X1q(2,:)=X1q(2,:)-Mean1(2);
S1q=mean(sqrt(diag(X1q'*X1q)))/sqrt(2);
X1q(1:2,:)=X1q(1:2,:)/S1q;
T1q=[eye(2)/S1q,-Mean1(1:2)/S1q;0 0 1];
%
b1 = kron(X1(:,1)', CrossOp(X1q(:,1)));
b2 = kron(X1(:,2)', CrossOp(X1q(:,2)));
b3 = kron(X1(:,3)', CrossOp(X1q(:,3)));
b4 = kron(X1(:,4)', CrossOp(X1q(:,4)));
B = [b1;b2;b3;b4];

[u,s,v]=svd(B);
Q=v(:,end);
H = reshape(Q,3,3);
H = inv(T1q)*H*T1;

%% warping image
figure('name','Warp Image')
Tr=maketform('projective',H');
WarpIm=imtransform(pg,Tr,'YData',[-0.55*q(2,3) q(2,3)*1.5],'XData',[-0.5*q(1,2) q(1,2)*1.5]);
imagesc(WarpIm)

%% picking players
%close all
figure('name','players')
imagesc(pg);
p1 = [ginput(1) 1]';
p2 = [ginput(1) 1]';
p = [p1 p2];
qp = H*p;
qp(:,1) = qp(:,1)./qp(3,1);
qp(:,2) = qp(:,2)./qp(3,2);
