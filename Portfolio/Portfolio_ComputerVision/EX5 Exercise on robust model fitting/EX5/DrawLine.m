function h=DrawLine(Line)
l=Line;

hold on
a=axis;

ll=[-1/a(1) 0 1];   cl=cross(l,ll);     cl=cl'/cl(3);
lr=[-1/a(2) 0 1];   cr=cross(l,lr);     cr=cr'/cr(3);
lb=[0 -1/a(3) 1];   cb=cross(l,lb);     cb=cb'/cb(3);
lt=[0 -1/a(4) 1];   ct=cross(l,lt);     ct=ct'/ct(3);


P=[];
if(cl(2)>a(3) & cl(2)<a(4))
    P=[P cl];
end

if(cr(2)>a(3) & cr(2)<a(4))
    P=[P cr];
end

if(cb(1)>a(1) & cb(1)<a(2))
    P=[P cb];
end

if(ct(1)>a(1) & ct(1)<a(2))
    P=[P ct];
end

h=line(P(1,:),P(2,:));
hold off
