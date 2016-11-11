function h=DrawImageLine(Rows,Cols,l)

lLeft=[1 0 0];
lRight=[1 0 -Cols];
lUp=[0 1 0];
lDown=[0 1 -Rows];

xLeft=cross(l,lLeft)';   
xRight=cross(l,lRight)'; 
xUp=cross(l,lUp)';       
xDown=cross(l,lDown)';   

P=[];
if(sign(xLeft(2))*sign(xLeft(3))>0 && abs(xLeft(2))<abs(Rows*xLeft(3)))
    P=[P xLeft/xLeft(3)];
end
if(sign(xRight(2))*sign(xRight(3))>0 && abs(xRight(2))<abs(Rows*xRight(3)))
    P=[P xRight/xRight(3)];
end
if(sign(xUp(1))*sign(xUp(3))>0 && abs(xUp(1))<abs(Cols*xUp(3)))
    P=[P xUp/xUp(3)];
end
if(sign(xDown(1))*sign(xDown(3))>0 && abs(xDown(1))<abs(Cols*xDown(3)))
    P=[P xDown/xDown(3)];
end
hold on
h=plot(P(1,:),P(2,:));
hold off





