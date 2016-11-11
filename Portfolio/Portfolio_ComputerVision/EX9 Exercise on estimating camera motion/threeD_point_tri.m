function [ Q,B ] = threeD_point_tri( q1,P1,q2,P2,s)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
for i = 1:s
B{i}(1,:) = P1(3,:)*q1(1,i) - P1(1,:);
B{i}(2,:) = P1(3,:)*q1(2,i) - P1(2,:);
B{i}(3,:) = P2(3,:)*q2(1,i) - P2(1,:);
B{i}(4,:) = P2(3,:)*q2(2,i) - P2(2,:);

[u,s,v{i}]=svd(B{i});
Q{i}=v{i}(:,end);
Q{i} = [Q{i}(1,:)./Q{i}(4,:);Q{i}(2,:)./Q{i}(4,:);Q{i}(3,:)./Q{i}(4,:);Q{i}(4,:)./Q{i}(4,:)];
end

