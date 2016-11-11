function [t x1 x2 x3] = beregningstiderne( n )
 A = randi(100,n,n)/5;
 b = randi(100,n,1);
 
 tic
 x1=A\b
 toc 
 t(1)=toc;
 
 tic
 x2 = inv(A)*b;
 toc
 t(2)=toc;
  
 tic 
 D =det(A);
 for i=1:n
     A2=A;
     A2(:,i)= b;
     e=det(A2);
     x3(i,:)= (e/D);
 end
 toc
 t(3)=toc;

end

