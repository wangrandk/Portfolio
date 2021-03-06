close all; clear all; clc;
S=100;
B=30;
L=80;
omega=1;
P = pris(S,omega,B,L);

% bruger fminsearch
[m1, Pmin1] = fminsearch( @ (x) pris(x(1),x(2),B,L),[100,1]);

clear 'S' 
clear 'omega'

%det er lavede en pris funktion. dermed den beregned pris er P=1.1746*1+^3
%for B=30. for at beregne den minimal pris, bruges fminsearch.ved L=80 og
%B=30 pmin=1.1214*10^3

%B2.
%definires gr�nsev�rdier
S = linspace(81,160,100);
omega = linspace(0.8,1.2,100);
%det laves en tom vektor
P1 = zeros(length(S),length(omega));

for i = 1:size(S,2)
    for j = 1:size(omega,2)
% Samlet funktion med Potentiel energi, fjeder og Potentiel energi, masse: (vektor)
P1(i,j) = pris(S(i),omega(j),B,L);
    end
end

% Opretter figur:
figure();

% Laver mesh med v�rdierne for S og omega. 
mesh(S,omega,P1)

%B.3
%fminsearch bruges til at finde minimum for funktionmed vektor
%tolerance er sat til 10^-5
optionB= optimset('TolX',1e-3,'display','iter');
%start g�t ligger omrking m
x0=[86.2,0.956];
[m2, Pmin2, ~, output] = fminsearch( @ (x) pris(x(1),x(2),B,L),x0,optionB);
%det skal bruges 30 itteriationer til at opn� pmin2 som er det samme som
%pmin1=1.1214*10^3

%B4
% Ved at kigge p� graffen ses at hmin ligger i x=0, ved at inds�tte dett, f�s hele 0 
%derfor kan det ikke bruges ligesom i opgaveA. Dette skyldes at vi i opgave B nu kigger p� et nyt 
% koordinatsystem. I stedet kan h_min findes ud fra sammenh�ngen: 
% h_min + h_max = B <=> h_min = B - h_max
% h_max beregnes p� samme m�de som f�r, men med S og omega sat til de
% v�rdier fundet for den billigste brokonstruktion.
%ved at kigge p� m v�rdien, bestemmes S og omega og rundes op
S = 87;
omega = 0.96;
% B = 30; % samme som tidligere
% L = 80; % samme som tidligere
% startg�t
x0 = 30;
% definerer vores funktion
f = @(T)  T/omega.*sinh((L.*omega)./(2.*T))-(1./2).*S;
% definerer options til fzero. 
%starter med et g�t p� tolerancen = 1e-3
optionB1=optimset('TolX',1e-3);
% bruger f zero til at finde T
T = fzero(f,x0,optionB1);
% definerer x = L/2
x = L/2;
h_max = (T/omega)*(cosh(omega*x/T)-1);
h_min = B - h_max;

