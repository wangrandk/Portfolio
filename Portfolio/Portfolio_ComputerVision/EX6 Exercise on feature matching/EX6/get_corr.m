function p = get_corr(patch1, patch2)
p1 = patch1(:);
p2 = patch2(:);

n = size(p1,1);

%m1 = (1/n)*sum(p1(:));
%m2 = (1/n)*sum(p2(:));

%s1 = (1/(n-1))*sum((p1 - m1).^2);
%s2 = (1/(n-1))*sum((p2 - m2).^2);
s1 = sum(p1(:));
s2 = sum(p2(:));

s11 = sum((p1(:)).^2);
s12 = sum((p1(:)).*(p2(:)));
s22 = sum((p2(:)).^2);

%c = (1/(n-1)).*sum((p1 - m1).*(p2 - m2));

c = (1/(n - 1))*(s12 - (1/n)*s1*s2);

%p = (s12 - (1/n)*s1*s2) / (sqrt((s11 - (1/n)*s1^2)*(s22 - (1/n)*s2^2)));

p = c/sqrt(dot(s1^2,s2^2));



end

