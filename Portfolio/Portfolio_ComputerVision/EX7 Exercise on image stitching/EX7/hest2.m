function H = hest2(q1, q2)

%Check that the vectors have the same number of points
size_q1 = size(q1);
size_q2 = size(q2);
if (size_q1(1) ~= size_q2(1))
    error('Function requires equal number of points in q1 and q2.');
end

%Set the number of points
n = size_q1(1);

%Design Matrix
Chi = [];
for i = 1:n
    x1 = q1(i,:)';
    x2 = q2(i,:)';
    
    %Create x2_hat
    x2_hat = vl_hat(x2);
    
    a = kron(x1, x2_hat);
    
    %Update the design matrix
    Chi = [Chi; a'];
end

%Compute SVD of the design matrix
[U,S,V] = svd(Chi);

%Get the column vector corresponding to the smallest singular value.
HsL = V(:,9);

HL = reshape(HsL,3,3);

%Normalization
S = svd(HL);
H = HL/S(2);


    
