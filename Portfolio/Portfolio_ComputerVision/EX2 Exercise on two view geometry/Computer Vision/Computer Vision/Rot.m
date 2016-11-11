function R=Rot(Omega,Phi,Kappa)

R=zeros(3,3);

R(1,1)=cos(Phi)*cos(Kappa);
R(2,1)=-cos(Phi)*sin(Kappa);
R(3,1)=sin(Phi);
R(1,2)=cos(Omega)*sin(Kappa)+sin(Omega)*sin(Phi)*cos(Kappa);
R(2,2)=cos(Omega)*cos(Kappa)-sin(Omega)*sin(Phi)*sin(Kappa);
R(3,2)=-sin(Omega)*cos(Phi);
R(1,3)=sin(Omega)*sin(Kappa)-cos(Omega)*sin(Phi)*cos(Kappa);
R(2,3)=sin(Omega)*cos(Kappa)+cos(Omega)*sin(Phi)*sin(Kappa);
R(3,3)=cos(Omega)*cos(Phi);

R=R';