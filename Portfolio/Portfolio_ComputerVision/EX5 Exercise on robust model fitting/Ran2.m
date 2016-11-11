function [p1 p2] = Ran2( p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    i =length(p)
    r= randsample(i,2,'false');
    p1 = p(:,r(1));
    p2 = p(:,r(2));
end

