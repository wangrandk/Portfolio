%% Spørgsmål 4. Epidemi i en befolkning
clear all; close all; clc
%% 4.1)
% Bruger Matlabs indbyggede funktion ode45 (til at løse
% differentialligninger) til at løse systemet i (10). For tiden t=0 til t=1
% og begyndelsesbetingelser og parametre:
% y1(0) = 99;
% y2(0) = 1;
% y3(0) = 0;
% c = 1;
% d = 5;
% Skal løse følgende differentialligningssystem (10). Differentiallignings-
% systemet er sat op i funktionen epidi.
% Løser med ode45
[T,Y] = ode45(@epidi,[0 1],[99 1 0]);
%% 4.2)
% Plotter:
figure(1)
plot(T,Y(:,1),'-',T,Y(:,2),'-.',T,Y(:,3),'.')
legend('y1 modtagelige','y2 inficerede','y3 immune');
title('Løsningen til differentialligningssystemet')
xlabel('time, t')
ylabel('y')
% Angiver hvor stor en procentdel der er inficerede, når denne procentdel
% er maksimal:
maks_inf = max(Y(:,2))

%% 4.3)
% Finder det tidspunkt tau_0 mellem t=0 og t=1 hvor der er lige så mange
% inficerede personer som der er immune personer. Kører først ode45 endnu
% en gang, hvor jeg gemmer resultatet i en struct kaldet sol. 
sol = ode45(@epidi,[0 1],[99 1 0]);
% Det kan ses rent grafisk at vi ønsker at finder intersection mellem y2 og
% y3. Svaret er ca. t=0.2 og 50% Laver en ny vektor, der er
% mere præcis i dette interval.
x = linspace(0,1,10^5);
y = deval(sol,x);
figure(2)
plot(x,y)
% Som man kan se er dette lidt mere præcist. 
maks_inf_pre = max(y(2,:)) % 10^2 : 80.0786 ; 10^3 :  80.0789 ; 10^4 : 80.0790 ; 10^5 : 80.0791 

% Finder nulpunkt i matlab:
% Inficerede:
y2 = @(t) deval(sol,t,2);
% Immune:
y3 = @(t) deval(sol,t,3);
% Nulpunkt via fzero:
nulp = fzero(@(t) y2(t)-y3(t),[0.15 0.25])
% Procentsatsen er altså:
y2(nulp)
y3(nulp)








