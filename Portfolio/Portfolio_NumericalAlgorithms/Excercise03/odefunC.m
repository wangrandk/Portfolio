function dzdt = odefunC( t,z0,l,dl,M,k,L0,g)

y1 = z0(1:401);
y2 = z0(402:end);
dzdt=[y2; ffun(l,y1,dl,M,k,L0,g)];
end
