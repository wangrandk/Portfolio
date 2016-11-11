function [ t_cross ] = CrossOp( t_2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
t_cross = [0 -t_2(3) t_2(2); t_2(3) 0 -t_2(1); -t_2(2) t_2(1) 0];

end

