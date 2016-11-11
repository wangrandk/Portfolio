clear all
clc
close all
load('TwoImageData.mat')
%%
[r1, c1] = corner_detection(im1);
[r2, c2] = corner_detection(im2);

p1 = [r1 c1]';
p1=p1(:,1:194);% I got 2 by 195 for p1
p2 = [r2 c2]';
pp1 = [p1;ones(1,length(p1))];
pp2 = [p2;ones(1,length(p2))];
%%
t_cross = CrossOp(T2);
F = pinv(A)' * t_cross * R2 * A^-1;
% CONVERT p TO q
q1 = A * pp1;
q2 = A * pp2;
d1 =(F * q1);%3*194  
d2= (F' *q2);%194*3
sampson_dist1 = ((q2'*F*q1).^2)/ (d1(1,:).^2 + d1(2,:).^2 + d2(1,:).^2 + d2(2,:).^2);
% dist between two q points are minimized wrt. F.
% sampson_dist2 = sampsonFun(F, p1, p2);
figure
hist(sampson_dist1,194)
norm(sampson_dist1)
Algebraic_dist = ((q1')*F*(q2)).^2;
norm(Algebraic_dist)
%epipolar line check
l3=q1'*F;
figure(5)
imshow(im2)
epilines=epipolarLine(F,p2');
points=lineToBorderPoints(epilines,size(im2));% retures 4 column 2x,2y
line(points(:, [1,3])', points(:, [2,4])');
%the horizontal lines indicates two cameras center are very close to each other