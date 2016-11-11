function dy = epidi(t,y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
dy = zeros(3,1); % a column vector
dy(1) = -1*y(1)*y(2); % (10)
dy(2) = 1*y(1)*y(2)-5*y(2);
dy(3) = 5*y(2);
end

