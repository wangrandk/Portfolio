c1 = [0,1];
c2 = [0.5 0.5];
c3 = [1,0];
A = [1 0.7523 0.0394 1;
    0.7523 1 0.1481 1;
    0.0394 0.1481 1 1;
    1 1 1 0];
   
b = [0.1481;0.3125;0.7523;1]
w = A\b;
var = 1-dot(w,b)
%
%%
R=6;
for h = 0:R
    if abs(h)==0
        rh(h+1) = 0
    else if  0<abs(h)<=R
           rh(h+1) = c3(1)+c3(2)*(((3/2)*abs(h)/R) - ((1/2)*(abs(h)^3/(R^3))))
        else if R<abs(h)
                rh(h+1)= c1(1)+c1(2);
            end
        end
    end  
end
 ch=1- rh;
 out=[rh' ch']
 
 %%
A2=[1 0.3762 0.0197 1;
     0.3762 1 0.074 1;
    0.0197 0.0741 1 1;
    1 1 1 0];
b2 = [0.0741;0.1563;0.3762;1];
w2 = A2\b2;
var2 = 1-dot(w2,b2)
% 0.9450
A3=[1 0 0 1;
     0 1 0 1;
     0 0 1 1;
     1 1 1 0];            
b3 = [0;0;0;1];
w3 = A3\b3;
var3 = 1-dot(w3,b3) 
%1.3333
plot([var;var2;var3];
