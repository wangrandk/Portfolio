function x = GaussNaive(A,b)
% GaussNaive: naive Gauss elimination
%   x = GaussNaive(A,b): Gauss elimination without pivoting.
% input:
%   A = coefficient matrix
%   b = right hand side vector
% output:
%   x = solution vector

% Slightly modified by PCH to distinguish between operations on A and b,
% and to explicitly insert zeros below the diagonal in A.
% PCH + HHS, 25. sept., 2012.

[m,n] = size(A);
if m~=n, error('Matrix A must be square'); end

% forward elimination
for k = 1:n-1%n-1 flop
    j=min(k+10,n);
  for i = k+1:j %10 flops
    factor = A(i,k)/A(k,k);%1 flop
    A(i,k) = 0;
    A(i,k+1:j) = A(i,k+1:j)-factor*A(k,k+1:j);%10+10 flops
    b(i) = b(i)-factor*b(k);%2flops
  end% (10+10+2+1)* 10=230*(n-1)
end

% back substitution
x = zeros(n,1);
x(n) = b(n)/A(n,n); %1 flop
for i = n-1:-1:1 % n
    q=k-10; 
  x(i) = (b(i)-A(i,i+1:q)*x(i+1:q))/A(i,i);% 10+10+1
end %21*(n-1) flops

%i alt 230*(n-1)+21*n=251n-230 flops
