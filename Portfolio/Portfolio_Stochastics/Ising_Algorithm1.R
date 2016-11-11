#Gibbs sampler for the Ising model
rm(list=ls())
#settings
beta=1
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

#initial data random binary
set.seed(2) 
x=matrix(nr=nx,nc=ny,data=rbinom(n=ntot,size=1,prob=0.5))
xini=x;
#movie press to continue
image(seq(0,1,l=nx),seq(0,1,l=ny),xini,
      main="Chain at time 0",
      xlab="x",ylab="y",
      col=c("white","black"))  

cat ("Press [enter] to continue")
line <- readline()   


#initializing things for the bucle
#z=matrix(nr=nx,nc=ny,)
mass=rep(0,niter)
mass[1]=sum(x)/ntot;
y=matrix(nx,ny,data=NA)

for(t in 2:niter){
  for(i in 1:nx){
    for(j in 1:ny){
      #we operate in each pixel every iteration
      xcand=1-x[i,j] # the opposite value 
      #we look at the neighbours
      xneigh=neighbours(x,i,j)
      nneigh=length(xneigh)
      A=sum(xneigh);B=nneigh-A
      favor <- ifelse(xcand==1,A,B)
      against=nneigh-favor
      
      # p from potts algorithm 1
      c=exp(beta*favor)+exp(beta*against)
      p=exp(beta*favor)/c #should be in [0,1]
      
      #toss unfair coin and decide 
      y[i,j] <- ifelse(rbinom(1,1,p),xcand,x[i,j])
      
    }
    
  }
  #all the pixels have change this iteration
  x=y
  mass[t]=sum(x)/ntot # total mass of black points
  #if(t %% 100 == 0) {z[,,cont]=y;cont=con
  #Evolutionplot
  if(t %% (niter/10) ==0){ #time to see the changes
    image(seq(0,1,l=nx),seq(0,1,l=ny),x,
          main=paste("Chain at time ",t),
          xlab="x",ylab="y",
          col=c("white","black"))  
    cat ("Press [enter] to continue")
    line <- readline()    
  }
  
}


png("fig1.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),xini,
      main="Chain at time 0",
      xlab="x",ylab="y",
      col=c("white","black"))
image(seq(0,1,l=nx),seq(0,1,l=ny),x,
      main=paste("Chain at time",niter),
      xlab="x",ylab="y",
      col=c("white","black"))
dev.off()

png("mass.png")
plot(seq(1,niter,1),c(0,rep(1,niter-1)),type='n',
     main='mass of blacks (ones)', xlab='iter',ylab='mass')
lines(seq(1,niter,1),mass,type='l')
dev.off()