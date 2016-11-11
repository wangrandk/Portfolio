function [dist] = Hdist(H,q1,q2)

 if (size(q1,1) == 2 || size(q2,1) == 2)
    error('Points must be in homogeneous cordinates');
 end
 
 if (size(q2,2) == 3)
     q2 = q2(1:2,:);
 end

%q1 = q1/norm(q1);
%q2 = q2/norm(q2);

Phq2 = H*q2;
Phq2 = [Phq2(1,:)/Phq2(3,:);Phq2(2,:)/Phq2(3,:)];

Pq1 =  [q1(1,:)/q1(3,:);q1(2,:)/q1(3,:)];

a1 = norm(Phq2 - Pq1);

Phq1 = inv(H)*q1;
Phq1 = [Phq1(1,:)/Phq1(3,:);Phq1(2,:)/Phq1(3,:)];

Pq2 = [q2(1,:)/q2(3,:);q2(2,:)/q2(3,:)];

a2 = norm(Phq1 - Pq2);

dist = a1 + a2;

end

