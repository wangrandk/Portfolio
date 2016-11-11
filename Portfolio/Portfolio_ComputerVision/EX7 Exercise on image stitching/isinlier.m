function [ n ] = isinlier(l,p,t)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%l=[2;5;1];
l = l/norm(l(1:2));
% p = [p;1];
if abs(dot(l',p)) < t
    n=1;
else
    n=0;  
end
end

% isinlier(0.6 [2;5;1] [2;5])