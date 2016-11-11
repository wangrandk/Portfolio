function x = GaussNaiveorig(A,b)
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
for k = 1:n-1
  for i = k+1:n
    factor = A(i,k)/A(k,k);
    A(i,k) = 0;
    A(i,k+1:n) = A(i,k+1:n)-factor*A(k,k+1:n);
    b(i) = b(i)-factor*b(k);
  end
end

% back substitution
x = zeros(n,1);
x(n) = b(n)/A(n,n);
for i = n-1:-1:1
  x(i) = (b(i)-A(i,i+1:n)*x(i+1:n))/A(i,i);
end