clear all
load('data_ex4.mat')
t = decimate(t,50);
A_data =decimate(A_data,50);
B_data =decimate(B_data,50);
I_data =decimate(I_data,50);
D_data =decimate(D_data,50);
P_data =decimate(P_data,50);
S_data =decimate(S_data,50);
figure
subplot(3,2,1)
plot(t,A_data,'bo') 

subplot(3,2,2)
plot(t,B_data,'bo')

subplot(3,2,3)
plot(t,D_data,'bo')

subplot(3,2,4)
plot(t,I_data,'bo')

subplot(3,2,5)
plot(t,P_data,'bo')

subplot(3,2,6)
plot(t,S_data,'bo')