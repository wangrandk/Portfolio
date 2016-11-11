#analyses on different beta

rm(list=ls())
#settings
betavec=c(1.0,1.5,2.0)
#betavec=c(2.0,2.0)
nb=length(betavec)
niter=100
nx=34
ny=33 ;ntot=nx*ny

#function neighbours
neighbours <- function(x,i,j){
  #Clockwise ordering. if 8 we start in north pixel.
  nx=length(x[,1]); ny=length(x[1,])
  if(i==1 && j==1) nbrs=c(x[1,2],x[2,2],x[2,1]) #left-down
  if(i==1 && j==ny) nbrs=c(x[2,ny],x[2,ny-1],x[1,ny-1])#left-up
  if(i==1 && j!=1 && j!=ny) nbrs=c(x[1,j+1],x[2,j+1]
                                   ,x[2,j],x[2,j-1],x[1,j-1]) #left border
  
  if(i==nx && j==1) nbrs=c(x[nx-1,1],x[nx-1,2],x[nx,2])#right-down
  if(i==nx && j==ny) nbrs=c(x[nx,ny-1],x[nx-1,ny-1],
                            x[nx-1,ny])#right-up
  if(i==nx && j!=1 && j!=ny) nbrs=c(x[nx,j-1],x[nx-1,j-1]
                                    ,x[nx-1,j],x[nx-1,j+1],x[nx,j+1])#right border
  
  if(j==1 && i!=1 && i!=nx) nbrs=c(x[i-1,1],x[i-1,2]
                                   ,x[i,2],x[i+1,2],x[i+1,1]) #down border
  
  if(j==ny && i!=1 && i!=nx) nbrs=c(x[i+1,ny],x[i+1,ny-1]
                                    ,x[i,ny-1],x[i-1,ny-1],x[i-1,ny]) #up border
  #inner point 8 neigbhours first is north and then clockwise
  if(i!=1 && i!=nx && j!=1 && j!=ny) nbrs=c(x[i,j+1],x[i+1,j+1]
                                            ,x[i+1,j],x[i+1,j-1],x[i,j-1],x[i-1,j-1],x[i-1,j],x[i-1,j+1])
  
  return(nbrs)  
}

#function Potts,
prior <- function(x,i,j,beta){
  xneig=neighbours(x,i,j)
  nneig=length(xneig)
  match=0
  for(k in 1:nneig){match <-ifelse(xneig[k]==x[i,j],match+1,match)}
  c=(exp(beta*match)+exp(beta*(nneig-match)))
  sol=exp(beta*match)/c
  return(sol)
}


#initial data random binary
set.seed(3) 
x=matrix(nr=nx,nc=ny,data=rbinom(n=ntot,size=1,prob=0.5))
xini=x;

#initializing things for the bucle
#z=matrix(nr=nx,nc=ny,)
mass=matrix(nr=niter,nc=nb,rep(0,niter*nb))
mass[1,1:nb]=rep(sum(x)/ntot,nb);
mass1 <- mass2 <- mass
y1=matrix(nx,ny,data=NA) #for Gibbs
y=matrix(nx,ny,data=NA) #for M-H
x1 <- x2 <- x

#image(seq(0,1,l=nx),seq(0,1,l=ny),x,
#      main=paste("Gibss, time=",t,"beta=",betavec[b]),
#      xlab="x",ylab="y",
#      col=c("white","black"))  




for(b in 1:nb){
  for(t in 2:niter){
    for(i in 1:nx){
      for(j in 1:ny){
      #Gibbs sampler labeled 1
      xcand1=1-x1[i,j] 
      clone1=x1;clone1[i,j]=xcand1
      p1=prior(clone1,i,j,betavec[b]) 
      y1[i,j] <- ifelse(rbinom(1,1,p1),xcand1,x1[i,j])
      #M-H algorithm labeled 2
      xcand=1-x[i,j] # the opposite value
      clone=x;clone[i,j]=xcand
      beta=betavec[b]
      #compute the ratio R=f(xcand)*q(x)/f(x)*q(xcand)
      R=prior(clone,i,j,beta)/prior(x,i,j,beta)
      #the probability p
      p=min(1,R)
      # toss an unfair coin to decide if candidate is accepted
      accept <- rbinom(n=1,size=1,prob=p)
      y[i,j] <- ifelse(accept==1, xcand, x[i,j])      
    }
    
  }
  #all the pixels have change this iteration
  x1=y1   # Gibbs
  x=y     # H-M
  mass1[t,b]=sum(x1)/ntot # total mass of black points:
  mass2[t,b]=sum(x)/ntot
    
  #if(t %% 100 == 0) {z[,,cont]=y;cont=con
  #Evolutionplot
  if(t %% (niter/10) ==0){ #time to see the changes
    par(mfrow=c(1,2))  
    image(seq(0,1,l=nx),seq(0,1,l=ny),x1,
          main=paste("Gibss, time=",t,"beta=",betavec[b]),
          xlab="x",ylab="y",
          col=c("white","black"))  
    image(seq(0,1,l=nx),seq(0,1,l=ny),x,
          main=paste("M-H, time=",t,"beta=",betavec[b]),
          xlab="x",ylab="y",
          col=c("white","black"))  
      
  #  cat ("Press [enter] to continue")
  #  line <- readline()    
  }
  
}
x2 <- x1 <- x
            
}
            
            
png("mass_Ising.png",height=300)
par(mfrow=c(1,2))     
plot(seq(1,niter,1),c(0,rep(1,niter-1)),type='n',
main='mass of blacks (Gibbs)', xlab='iter',ylab='mass')
for (b in 1:nb){lines(seq(1,niter,1),mass1[,b],
                      type='l',col=b)}
# legend
txt2=c("beta=1.0","beta=1.5","beta=2.0")
legend("topright",txt2, col=c(1,2,3),lty=c(1,1,1),cex=0.9)
            
plot(seq(1,niter,1),c(0,rep(1,niter-1)),type='n',
     main='mass of blacks (M-H)', xlab='iter',ylab='mass')
for (b in 1:nb){lines(seq(1,niter,1),mass1[,b],
                                  type='l',col=b)}
# legend
txt2=c("beta=1.0","beta=1.5","beta=2.0")
legend("topright",txt2, col=c(1,2,3),lty=c(1,1,1),cex=0.9)
                       
dev.off()           