function [ Q,B ] = Est3D(q1,P1,q2,P2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
B(1,:) = P1(3,:)*q1(1) - P1(1,:);
B(2,:) = P1(3,:)*q1(2) - P1(2,:);
B(3,:) = P2(3,:)*q2(1) - P2(1,:);
B(4,:) = P2(3,:)*q2(2) - P2(2,:);

[u,s,v]=svd(B);
Q=v(:,end);

end

