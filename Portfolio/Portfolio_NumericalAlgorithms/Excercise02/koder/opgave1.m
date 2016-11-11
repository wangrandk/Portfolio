clear all 
close all 
clc
%det kan også gøres på en anden måde dvs: s + x(i) er en flop gang med
%antal tal i [1.2 4.6 2.3 5 7.9 pi] hvilken er 6*1=6
%1.1
x=[1.2 4.6 2.3 5 7.9 pi];
s = 0;
 for i=1:length(x)
 s = s + x(i);
 end
 floops11=length(x);
 %1.2 i denne opgave for n+1 for g (g = g + x(i) er n og g = g/n er 1);
 %for RMS er 2n+2( RMS + x(i)^2 er 2*n og sqrt(RMS/n) er 2 floops) dvs alt
 %i alt 2n+2+n+1=3*n+3
 g = 0; RMS = 0;
 n = length(x); % n = antal elementer i x 
 for i=1:n
 g = g + x(i);
RMS = RMS + x(i)^2;
 end
 g = g/n;
RMS = sqrt(RMS/n);
floops12=(3*n)+3;
 % svaret er floops12=21 dvs 7 + 14 (g=7 og RMS=14) for x=6
 
 %1.3                                               floop
 %for i = 1 : n-1                         
 %factor = A(i+1,i) / A(i,i);                        1
 %A(i+1,i) = 0;                                      -
 %A(i+1,i+1) = A(i+1,i+1) - factor*A(i,i+1);          2    
 %b(i+1) = b(i+1) - factor*b(i);                      2
 %end                                         i alt =5
% 5 flops i alt og det er n-1 => 5*(n-1)
n=5;
floops13=5*(n-1);
%svaret er 5*(5-1)=20



 
 
 