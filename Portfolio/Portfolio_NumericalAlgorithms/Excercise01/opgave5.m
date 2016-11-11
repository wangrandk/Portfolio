close all; clear all; clc;
%5.1
x1 = 5;
y1 = 1;
g=9.82;
E1 = Etot(x1,y1,g);
%Det laves en Etot funktion for at definere vores samlet energy, denne
%funktion er laves udfra de ændring i kordinater vi havde.
%5.2
% Definerer mine 2 vektorer x1 og y1.
x1 = linspace(2,8,1000);
y1 = linspace(-15,-5,1000);

% Laver tom matrix
E = zeros(length(x1),length(y1));

% Laver matrix med værdierne for den samlede energi ved forskellige x og
% y.
for i = 1:size(x1,2)
    for j = 1:size(y1,2)
% Samlet funktion med Potentiel energi, fjeder og Potentiel energi, masse: (vektor)
E(i,j) = Etot(x1(i),y1(j),g);
    end
end

% Opretter figur:
figure(1);

% Laver mesh med værdierne for x1 og y1 ud af 1. og 2. aksen og energien op
% af 3. aksen. 
mesh(x1,y1,E)

%5.3
result1 = fminsearch(@(L) Etot(L(1),L(2),g),[10,10]);
%det ses at fmin i L1 ligger i 19.82 og L2 ligger i 14.91
%5.4
g=0;
result2 = fminsearch(@(L) Etot(L(1),L(2),g),[10,10]);
%det ses at E1 er minus og E2 plus for g=0, viser det sig at Ef er positiv
%værdig, trods Em som er poteniell energi er negativ værdi. det viser når
%man sætter g=0, ligger kassen i vores kordinat system.det kan også ses at
%hvis man bibeholder g=9.82, kan man også teste systemet med ændring i
%massen af kasse. 
%5.5
g=9.82;
syms L1 L2;
f= Etot(L1,L2,g);
fx=diff(f,L1);fy=diff(f,L2);
[a,b]=solve(fx,fy);
double([a,b])
%det opstår 2 række tal hvilket den enest er samme som result1
%[19.82,14.91] og den anden minimum er [19.82 -5.09]







