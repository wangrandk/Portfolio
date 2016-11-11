rm(list=ls())
#data <- as.matrix(read.table("potts.txt",header = FALSE, sep = ""))
nx <- 50; ny <- 50; n <- nx*ny
xmax <- 1; ymax <- 1;     
#st1=0;st2=1; state <- rep(0,n)#state[1:n] <- ifelse(data[1:n]<=.5, st1,st2)
#state <-matrix(nx,ny,data=state); #state<-as.numeric(state);#state <- pmax(state,t(state))/N;
#beta = log(1+sqrt(2)) +0.0001; #not affect boundary
niter =100;  beta =2

#permutation: choose pixels at random with constraint-no replacement.
#r=c=rep(0,5000);
#for (i in 1:5000){
#   r[i] = sample.int(50,1,replace=F);
#   c[i] = sample.int(50,1,replace=F);
#}

# nbr <- function(x,i,j){
#   nx=length(x[,1]); ny=length(x[1,])
#   if(i!=1 && i!=nx && j!=1 && j!=ny)
#   {cc =x[i,j]; b=x[i+1,j]; t=x[i-1,j]; l=x[i,j-1]; rr=x[i,j+1];
#   array = c(b,t,l,rr);
#   return(array)
#   }
# }
f <- function(x,i,j){
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

library(compiler)
nbr <- cmpfun(f)

set.seed(3)
x=matrix(nr=nx,nc=ny,data=rbinom(n=n,size=1,prob=0.5));
xini = x;

png("Ising1_iter100_beta1.5.png",height= 1000, width=800)
#png("ising1_inter1to10.png")
par(mfrow=c(4,3),pty = "s",mex=.7,pin=c(1.9,1.9),cex=1.2)  
image(seq(0,1,l=nx),seq(0,1,l=ny),xini,
      main="Chain at time 0",
      xlab="x",ylab="y",
      col=c("white","black")) 


mass=rep(0,niter)
mass[1]=sum(x)/n;
y=matrix(nx,ny,data=NA)
#yy=matrix(nx,ny,data=NA)
for (t in 2:niter) {
  for (i in 1:nx) {
    for (j in 1:ny) {
      nabo = nbr(x,i,j)
      #c =x[i,j]; b=x[i+1,j]; t=x[i-1,j]; l=x[i,j-1]; rr=x[i,j+1];
    # xin = x[r[j],c[j]]
    # b = x[r[j]+1,c[j]] 
    #t = x[r[j]-1,c[j]]  
    #l = x[r[j],c[j]-1] 
    #rr= x[r[j],c[j]+1] 
    u = runif(1)
    #array = c(b,t,l,rr);
    n0 = sum(nabo==0);
    n1 = sum(nabo==1);
    p = exp(beta*n1)/(exp(beta*n0) + exp(beta*n1));
    if (u<p) {y[i,j] = 1} else {y[i,j]= 0}    
    #if (u<p) {y[r[j],c[j]] = 1} else {y[r[j],c[j]] = 0}    
    }  
  }
  x=y
  mass[t]=sum(x)/n # total mass of black points
  if(t %% (niter/10) ==0){ #time to see the changes
    image(seq(0,1,l=nx),seq(0,1,l=ny),x,
          main=paste("Chain at time ",t),
          xlab="x",ylab="y",
          col=c("white","black"))  
   # cat ("Press [enter] to continue")
    #line <- readline() 
  }
}
dev.off()

png("fig1.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),xin,
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
