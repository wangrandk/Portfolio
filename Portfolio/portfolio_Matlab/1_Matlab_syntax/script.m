%ran and shhivangi

d=[0.5:0.01:1].* 0.001;
d1=[1;8;15;22;29;36];
d1=d1';
%d=0.0005
%if((d>=0.0005) & (d<=1))
 %    v
%else  fprintf ( 1, 'the diameter is out of rang\n' );
%end
g=9.81;
Cd=0.901;
Pp=2.65;
Pw=1;
results= [d;velFunc(g,Cd,Pp,Pw,d)];
formatSpec='diameter is %4.5f meter,  velocity is %1.5f m/s \n ';
fprintf ( formatSpec, results)
