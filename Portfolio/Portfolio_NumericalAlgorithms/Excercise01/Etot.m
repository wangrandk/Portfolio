function [ E ] = Etot( x1, y1,g )
% [ E ] = etot( y1, y2 )
% Input y1 og y2 er en skalar. ex: L = [x1;y1];; % [m] % f.eks. y=[12;8]
% Fjederkonstanter:
k1 = 10; % [N/m]
k2 = 20; % [N/m]
% Fjederkonstant, vektor:
k = [k1;k2];
% Ustrukkede Længder:
l1 = 10; % [m] 
l2 = 10; % [m]
% Ustrukket længde, vektor:
l = [l1;l2];
% Masser:
m = 10; % [kg]

% Tyngdeaccelerationen:
%g = 9.82; % [m/s^2]
% Strækning, vektor:
L = [x1;y1];
% Positioner:
L1 = x1+10;
L2 =  y1+1;
% Position, vektor:
y = [L1;L2];
% Samlet funktion med Potentiel energi, fjeder og Potentiel energi, masse: (vektor)
E = sum ( 0.5*(k.*(abs(L)-l).^2)- m*g*y );  
end

