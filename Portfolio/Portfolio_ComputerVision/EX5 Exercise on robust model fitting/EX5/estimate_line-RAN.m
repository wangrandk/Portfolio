function l = estimate_line(p1, p2)
% X : 2D point correspondences

x = [p1;1];
y = [p2;1];

l = cross(x,y);
end





