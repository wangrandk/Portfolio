function [ p1,p2 ] = two_points( n )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
m = rand(2,n);
r= randsample(n,2,'false');
p1 = m(:,r(1));
p2 = m(:,r(2));

end

