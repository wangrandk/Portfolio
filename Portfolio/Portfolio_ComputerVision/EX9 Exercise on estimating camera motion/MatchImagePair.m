function [M12,E,R,t]=MatchImagePair(F1,D1,F2,D2,K,Sigma)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

M12 = vl_ubcmatch(D1, D2);
nMatch = size(M12,2);
q1 = F1(1:2,M12(1,:));% matching points
q2 = F2(1:2,M12(2,:));
q1 = [q1;ones(1,nMatch)];
q2 = [q2;ones(1,nMatch)];
[E,R,t,nIn]=EestMex(K,q1',K,q2',Sigma);
end

