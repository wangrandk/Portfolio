%% Opgave B. Skydetræning
clear all; close all; clc
%% B.1)
% Se rapport
%% B.2)
% Se odefunb
%% B.3)
% Løser med ode45
% Vektoren [0 30] angiver at der skal simuleres i tidsrummet fra 0 til 30
% sek.
% Vektoren [ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ] angiver startbe-
% tingelserne. Startposition er x_0 = 0 og y_0 = 2 Starthastighed i x og y 
% retning, er dx/dt = cos(pi/180*30)*500 og dy/dt = sin(pi/180*30)*500
[T,Y] = ode45(@odefunb,[0 30],[0 2 cos(pi/180*30)*500 sin(pi/180*30)*500]);
figure(1)
plot(Y(:,1),Y(:,2),'r')
legend('projektils bane ved 500 m/s og 30 grader');
title('Projektilets bane for den røde kanon');
xlabel('x, position [m]');
ylabel('y, position [m]');
%% B.4)
% Kører først ode45 endnu en gang, hvor jeg gemmer resultatet i en struct 
% kaldet sol. 
sol = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ]);
% Finder nulpunkt i matlab:
% Projektil, y position (t):
y = @(t) deval(sol,t,2);
% Nulpunkt via fzero: (finder tidspunktet, hvor y=0, første gang) [sek]
t_0 = fzero(@(t) y(t),[0 30])
% Projektil, x position (t):
x = @(t) deval(sol,t,1);
% x position hvor projektilet slår ned (indsætter den fundne tid) [m]
x_value = x(t_0)
% Varierer nu nøjagtigheden af løsningen vha. "RelTol", så jeg kan ramme
% nedslagets x koordinat indenfor plus minus 0.5 m.
format long
% Sætter tolerancen til min numeriske løsning af differentialligningen:
options1 = odeset('RelTol',1e-1);
sol1 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ], options1 );
options2 = odeset('RelTol',1e-2);
sol2 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ], options2 );
options3 = odeset('RelTol',1e-3);
sol3 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ], options3 );
options4 = odeset('RelTol',1e-4);
sol4 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ], options4 );
options5 = odeset('RelTol',1e-5);
sol5 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*30)*500 sin(pi/180*30)*500 ], options5 );
y1 = @(t) deval(sol1,t,2);
y2 = @(t) deval(sol2,t,2);
y3 = @(t) deval(sol3,t,2);
y4 = @(t) deval(sol4,t,2);
y5 = @(t) deval(sol5,t,2);
t1 = fzero(@(t) y1(t),[0 30])
t2 = fzero(@(t) y2(t),[0 30])
t3 = fzero(@(t) y3(t),[0 30])
t4 = fzero(@(t) y4(t),[0 30])
t5 = fzero(@(t) y5(t),[0 30])
x1 = @(t) deval(sol1,t,1);
x2 = @(t) deval(sol2,t,1);
x3 = @(t) deval(sol3,t,1);
x4 = @(t) deval(sol4,t,1);
x5 = @(t) deval(sol5,t,1);
x_value1 = x(t1)
x_value2 = x(t2)
x_value3 = x(t3)
x_value4 = x(t4)
x_value5 = x(t5)
% Det ses at standard tolerancen med 1e-3 er passende.
%% B.5)
% Laver en funktion der finder x-koordinatens nedslag som funktion af v ud 
% fra det vi lavede i opgave B.4. Kalder denne funktion nedslag (se funk.) 
% Problemet kan nu løses som et nulpunktsproblem, idet vi ved at x=1000m.
% Altså skal vi løse nedslag(v)-1000 = 0.
% Dette gør vi med fzero, men først plottes nedslag(v)-1000, for at få gode
% startgæt. 
figure(2)
fplot(@(v) nedslag(v)-1000,[0,90])
legend('Funktionen nedslag(v)-1000');
title('Funktionen nedslag(v)-1000');
xlabel('v, vinkel [grader]');
ylabel('x - 1000, position [m]');
%%  Gætter nu på hhv. 10 og 35 grader:
v1 = fzero(@(v) nedslag(v)-1000,10)
v2 = fzero(@(v) nedslag(v)-1000,35)
% Finder de 2 vinkler v til at være: 16.03 og 43.34 grader.
% Kører ode45 endnu en gang, hvor jeg gemmer resultatet i en struct 
% kaldet sol. Checker mine fundne vinkler passer:
% Vinkel v=16.03
%% _____________________________________
sol_tjek1 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*v1)*500 sin(pi/180*v1)*500 ]);
% Finder nulpunkt i matlab:
% Projektil, y position (t):
y_tjek1 = @(t) deval(sol_tjek1,t,2);
% Nulpunkt via fzero: (finder tidspunktet, hvor y=0, første gang) [sek]
t_tjek1 = fzero(@(t) y_tjek1(t),[0 30]);
% Projektil, x position (t):
x_tjek1 = @(t) deval(sol_tjek1,t,1);
% x position hvor projektilet slår ned (indsætter den fundne tid) [m]
x_value_tjek1 = x_tjek1(t_tjek1)
% Vinkel v=43.34
%_____________________________________
sol_tjek2 = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*v2)*500 sin(pi/180*v2)*500 ]);
% Finder nulpunkt i matlab:
% Projektil, y position (t):
y_tjek2 = @(t) deval(sol_tjek2,t,2);
% Nulpunkt via fzero: (finder tidspunktet, hvor y=0, første gang) [sek]
t_tjek2 = fzero(@(t) y_tjek2(t),[0 30]);
% Projektil, x position (t):
x_tjek2 = @(t) deval(sol_tjek2,t,1);
% x position hvor projektilet slår ned (indsætter den fundne tid) [m]
x_value_tjek2 = x_tjek2(t_tjek2)
%_____________________________________
% Plotter til sidst de fundne løsninger:
[T1,Y1] = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*16.03)*500 sin(pi/180*16.03)*500 ]);
[T2,Y2] = ode45(@odefunb,[0 30],[ 0 2 cos(pi/180*43.34)*500 sin(pi/180*43.34)*500 ]);
figure(3)
plot(Y1(:,1),Y1(:,2),'r',Y2(:,1),Y2(:,2),'b')
legend('projektilets bane for v=16.03 grader','projektilets bane for v=43.34 grader');
title('De 2 vinkler, der rammer den blå kanon');
xlabel('x, position [m]');
ylabel('y, position [m]');
axis([0 1100 0 600]);
