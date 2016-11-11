function P = resectioning(Q,q)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
% Finding H X1(2*4)
s1=size(Q,2);
B=[];  
    idx=randsample(s1,100);
for i=idx
    b= kron(Q(:,i)',CrossOp(q(:,i))); %vl_hat = CrossOp
    B =[B; b];
end

[~,~,V] = svd(B);
P = V(:,end);
PL = reshape(P,3,4);

S = svd(PL);
P = PL/S(2);

end

