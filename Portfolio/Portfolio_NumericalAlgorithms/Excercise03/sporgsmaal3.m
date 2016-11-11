%% Spørgsmål 3. ODE metoder og skridtlængde
clear all; close all; clc
%% 3.1)
% Differentialligning:
dydt = @(t,y) y*t^3 -2*y; % (6)
% Interval: t1, t2
tspan = [0, 2];
% Begyndelsesværdi: y(0)=1
y0 = 1;
% Skridtlængde: h1, (grov)
h1 = 0.5;
% Skridtlængde: h2, (fin)
h2 = 0.25;
% Kalder m.fil med Euler's metode (grove værdier)
[t1,y1] = eulode(dydt, tspan, y0, h1);
% Kalder m.fil med Euler's metode (fine værdier)
[t2,y2] = eulode(dydt, tspan, y0, h2);
% Analytisk løsning til differentialligningen (6)
y = @(t) y0*exp(0.25*t.^4-2*t);
y1a = y(t1);
y2a = y(t2);
% Procentvis relative fejl:
epsilon1 = zeros(length(y1a),1);
for i = 1:length(y1a)
epsilon1(i) = abs((y1a(i)-y1(i))/y1a(i))*100;
end
epsilon2 = zeros(length(y2a),1);
for j = 1:length(y2a)
epsilon2(j) = abs((y2a(j)-y2(j))/y2a(j))*100;
end
% Tabel af numeriske løsning (grov) (t1,y1) viser tiden og den approksimerede
% værdi. Sammenholdt med den analytiske løsning.
disp([t1,y1a,y1,epsilon1])
% Tabel af numeriske løsning (fin) (t2,y2) viser tiden og den approksimerede
% værdi. Sammenholdt med den analytiske løsning. 
disp([t2,y2a,y2,epsilon2])
% Det ses ud fra de 2 tabeller, at den relative fejl er hhv. 100% og 85.15%
% til tiden t=2. 
% Plotter de 3 grafer sammen:
figure(1)
plot(t1,y1,'*r',t2,y2,'*b',t2,y2a,'-g');
legend('Euler h=0.5','Euler h=0.25','Analytisk løsning');
title('De 2 numeriske løsninger sammen med den analytiske løsning')
xlabel('time, t')
ylabel('y')
%% 3.2)
% Laver modificeret kode til Eulers metode, således at den implementerer
% Heun's metode. Den modificerede kode findes i m.filen heunode.m
%% 3.3) 
% Genbruger koden fra opgave 3.1) og kopierer det sidste ind, da det er 
% fuldstændig samme fremgangsmåde. 
% Kalder m.fil med Heun's metode (grove værdier)
[t1h,y1h] = heunode(dydt, tspan, y0, h1);
% Kalder m.fil med Heun's metode (fine værdier)
[t2h,y2h] = heunode(dydt, tspan, y0, h2);
% Procentvis relative fejl:
epsilon1h = zeros(length(y1a),1);
for i = 1:length(y1a)
epsilon1h(i) = abs((y1a(i)-y1h(i))/y1a(i))*100;
end
epsilon2h = zeros(length(y2a),1);
for j = 1:length(y2a)
epsilon2h(j) = abs((y2a(j)-y2h(j))/y2a(j))*100;
end
% Tabel af numeriske løsning (grov) (t1,y1) viser tiden og den approksimerede
% værdi. Sammenholdt med den analytiske løsning. Nu også med Heun's metode.
disp([t1,y1a,y1,epsilon1,y1h,epsilon1h])
% Tabel af numeriske løsning (fin) (t2,y2) viser tiden og den approksimerede
% værdi. Sammenholdt med den analytiske løsning. Nu også med Heun's metode. 
disp([t2,y2a,y2,epsilon2,y2h,epsilon2h])
% Det ses ud fra de 2 tabeller, at den relative fejl for Heun's metode er 
% hhv. 7.90% og 6.10% til tiden t=2. 
% Plotter de 5 grafer sammen:
figure(2)
plot(t1,y1,'*r',t2,y2,'*b',t2,y2a,'-g',t1h,y1h,'--y',t2h,y2h,'--c');
legend('Euler h=0.5','Euler h=0.25','Analytisk løsning','Heun h=0.5','Heun h=0.25');
title('Euler og Heuns metode sammen med den analytiske løsning')
xlabel('time, t')
ylabel('y')
%% 3.4)
for i = 3:6
    hi = 0.1*10^(3-i);
    % Kalder m.fil med Euler's metode
    [ti,yi] = eulode(dydt, tspan, y0, hi);
    % Kalder m.fil med Heun's metode 
    [tih,yih] = heunode(dydt, tspan, y0, hi);
    yia = y(ti);
    % Procentvis relative fejl:
    epsiloni = zeros(length(yia),1);
    epsilonih = zeros(length(yia),1);
    for j = 1:length(yia)
        epsiloni(j) = abs((yia(j)-yi(j))/yia(j))*100;
        epsilonih(j) = abs((yia(j)-yih(j))/yia(j))*100;
    end
    euler(i-2)= epsiloni(length(epsiloni)); %length = ti.
    heun(i-2) = epsilonih(length(epsilonih));
end
euler
heun
h = [0.1 0.01 0.001 0.0001];
figure(3)
plot(h,euler,'*r',h,heun,'*b');
legend('Euler O(h)','Heun O(h^2)');
title('Relative fejl på Euler og Heuns metode')
xlabel('skridtlængde, h')
ylabel('relative fejl, epsilon')