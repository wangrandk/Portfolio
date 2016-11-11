function avg_top = compute_avg_top( similarity_matrix )
%function avg_top = compute_avg_top( similarity_matrix )
%
% Computes the score given a similarity matrix. Highest
% score is most similar. The result is a number where:  
%   4: No errors.
%   1: This number you get if you identify identical images. 
%   0: Really bad score.
%
% Please note that this script is ment for small matrices. Matlab 
% will probably completely refuse to handle the 10k times 10k matrix
% of the full set. 
%

% Henrik Stewenius. Use the code as you like and at your own risk. 

[n1,n2] = size( similarity_matrix); 
if( n1 ~= n2 ) 
  error('Matrix not square!'); 
end 
if( mod(n1,4) ) 
  error('Size not divisible by 4!'); 
end

N = n1/4; 
toprank = 0; 
for i=0:(N-1)
  for j=1:4
[dummy,I] = sort( -similarity_matrix(4*i+j,:));
     dummy = -dummy;
    I = I(1:4); 
t = (I>(4*i)) & (I<=(4*(i+1))) & (dummy(1:4) > dummy(5));
toprank = toprank + sum( t);
  end
end
avg_top = toprank/(4*N);
