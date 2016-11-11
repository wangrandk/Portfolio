clear all
clc
[t_100 x1_100 x2_100 x3_100]= beregningstiderne(100);
sort(t_100);
%T2 = array2table(t_100, 'VariableNames',{'x1_100' 'x2_100' 'x3_100'});
%T_100 = [T2;T];
[t_200, x1_200, x2_200, x3_200]= beregningstiderne(200);
[t_400, x1_400, x2_400, x3_400]= beregningstiderne(400);
[t_800, x1_800, x2_800, x3_800]= beregningstiderne(800);
t = [t_100;t_200;t_400;t_800];
T = array2table(t,'VariableNames',{'backslash' 'inv' 'Cramer'});
save  T
save  T.txt t -ascii