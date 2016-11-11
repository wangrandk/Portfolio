function H = hest( q1,q2 )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% Normalizing q
% Mean1=mean(q1')';
% q1=q1./norm(q1);
% q1(1,:)=q1(1,:)./q1(3,:);
% q1(2,:)=q1(2,:)./q1(3,:);
% q1(3,:)=q1(3,:)./q1(3,:);
% q1(1,:)=q1(1,:)-Mean1(1);
% q1(2,:)=q1(2,:)-Mean1(2);
% q1(3,:)=q1(3,:)-Mean1(3);
% S1=mean(sqrt(diag(q1'*q1)))/sqrt(2);
% q1(1:2,:)=q1(1:2,:)/S1;
% T1=[eye(2)/S1,-Mean1(1:2)/S1;0 0 1];

% Mean2=mean(q2')';
% q2=q2./norm(q2);
% q2(1,:)=q2(1,:)./q2(3,:);
% q2(2,:)=q2(2,:)./q2(3,:);
% q2(3,:)=q2(3,:)./q2(3,:);
% q2(1,:)=q2(1,:)-Mean2(1);
% q2(2,:)=q2(2,:)-Mean2(2);
% q2(3,:)=q2(3,:)-Mean1(3);
% S1p=mean(sqrt(diag(q2'*q2)))/sqrt(2);
% q2(1:2,:)=q2(1:2,:)/S1p;
% T1p=[eye(2)/S1p,-Mean2(1:2)/S1p;0 0 1];

% [q1, T1] = normalise2dpts(q1);
%     [q2, T2] = normalise2dpts(q2);

% Finding H X1(2*4)
s1=size(q1,2);
B=[];
for i=1:s1
    b= kron(q1(:,i),vl_hat(q2(:,i))); 
    B =[B; b'];
end

[~,~,V] = svd(B);
Q = V(:,end);
HL = reshape(Q,3,3);

S = svd(HL);
H = HL/S(2)

% H = pinv(T2)*HL*T1;
%[U,S,V] = svd(X) produces a diagonal matrix S, of the same 
 %   dimension as X and with nonnegative diagonal elements in
  %  decreasing order, and unitary matrices U and V so that
   % X = U*S*V'.
end

