function dist = Hdistance( H,p1,p2)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
a=H*p2;
% a(1,:) = a(1,:)/a(3,:);
% a(2,:) = a(2,:)/a(3,:);
% a = a(1:2,:);

b=inv(H)*p1;
% b(1,:) = b(1,:)/b(3,:);
% b(2,:) = b(2,:)/b(3,:);
% b = b(1:2,:);

% np1(1,:) = p1(1,:)/p1(3,:);
% np1(2,:) = p1(2,:)/p1(3,:);
% np1 = np1(1:2,:);

% np2(1,:) = p2(1,:)/p2(3,:);
% np2(2,:) = p2(2,:)/p2(3,:);
% np2 = np2(1:2,:);

% dist = (norm(a- np1)) +...
%        (norm(b - np2));

dist = (norm( (a(1:2,:)./ repmat(a(3,:),2,1)) - (p1(1:2,:)./ repmat(p1(3,:),2,1)))) +...
       (norm( (b(1:2,:)./ repmat(b(3,:),2,1)) - (p2(1:2,:)./ repmat(p2(3,:),2,1))));
end

