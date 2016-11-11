#Metropolis-Hastings algorithm for denoising
rm(list=ls())
#we first read the noisy data
nx = 500
ny = 500
ntot = nx*ny

file= 'http://www2.imm.dtu.dk/courses/02443/projects/data/potts.txt'
x0 <- y <-  as.matrix(read.table(file))

#settings
beta=1.5
niter=10
set.seed(3)

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
#function Potts, normalised?!?!
prior <- function(x,i,j,beta){
  xneig=neighbours(x,i,j)
  nneig=length(xneig)
  match=0
  for(k in 1:nneig){match <-ifelse(xneig[k]==x[i,j],match+1,match)}
  c=(exp(beta*match)+exp(beta*(nneig-match)))
  sol=exp(beta*match)/c
  return(sol)
} 

sigma=0.5 # see find_sigma_noise.R

x <- y;#this x is y the noisy map, but i am using y as 
# the next iter. 

#we need a binary image to operate with prior. Lets make
#our initial element for the chain x1 binarizing the noisy data
for(i in 1:nx){
  for(j in 1:ny){
    x[i,j] <- ifelse(x[i,j]>0.5,1,0) #overwritting x  
  }
}
x1 <- x
#x1 is saved for the plot
#initializing things for the bucle
#z=matrix(nr=nx,nc=ny,)
PixDiff <- mass <- rep(0,niter)
mass[1]=sum(x)/ntot;

y=matrix(nx,ny,data=NA)

image(seq(0,1,l=nx),seq(0,1,l=ny),x1,
      main="Chain at time 0",
      xlab="x",ylab="y",
      col=c("white","black"))

for(t in 2:niter){
  print(c("time= ",as.character(t)))
  for(i in 1:nx){
    for(j in 1:ny){
      #we operate in each pixel every iteration
      #first we choose a candidate 1 or 0 with p=0.5
      #xcand=rbinom(1,1,prob=0.5) # This is a symetric proposal?
      # can we say q(xcand)/q(x[i,j])=1?
      xcand=1-x[i,j]
      clone=x;clone[i,j]=xcand
      
      #we target the posterior p(x|y) \prop p(y|x) p(x) 
      #p(x)=prior encoded up
      #p(y|X=x)=Thats N(x0,sigma) x0 is the noisy map see above
      
      
      #compute the ratio R=f(xcand)*q(x)/f(x)*q(xcand)
      R=prior(clone,i,j,beta)/prior(x,i,j,beta)
      R=R*dnorm(x0[i,j],xcand,sigma)/
        dnorm(x0[i,j],x[i,j],sigma)
      #the probability p
      p=min(1,R)
      # toss an unfair coin to decide if candidate is accepted
      accept <- rbinom(n=1,size=1,prob=p)
      y[i,j] <- ifelse(accept==1, xcand, x[i,j])      
      
    }
    
  }
  #Count the different pixels with respect to previous elements
  #We can see the convergence here
  PixDiff[t]=sum(x!=y)
  #all the pixels have change this iteration, we put y on x  
  x=y
  mass[t]=sum(x)/ntot # total mass of black points
    
  #if(t %% 10 == 0) {z[,,cont]=y;cont=con
  #Evolutionplot every 10 iter
  if(t %% 1 ==0){ #time to see the changes
#     par(mfrow=c(1,2))     
    
    
    image(seq(0,1,l=nx),seq(0,1,l=ny),x,
          main=paste("Chain at time ",t, "PixDiff ",PixDiff[t]),
          xlab="x",ylab="y", 
          col=c("white","black"))  
    #  cat ("Press [enter] to continue")
    #  line <- readline()    
    
    
  }
}


png("denoising.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),x0,
      main="Noisy Data",
      xlab="",ylab="",
      col=terrain.colors(8))
image(seq(0,1,l=nx),seq(0,1,l=ny),x,
      main=paste("Reconstruction",niter),
      xlab="x",ylab="y",
      col=c("white","black"))
dev.off()

nb=1;betavec=c(beta)
png("data_MassPixDiff_kk.png",height=300)
par(mfrow=c(1,2)) 
plot(seq(1,niter,1),c(0,rep(1,niter-1)),type='n',
     main='mass of blacks (ones)', xlab='iter',ylab='mass')
for(b in 1:nb){lines(seq(1,niter,1),mass[,b],type='l',col=b,lwd=1.5)}
# legend
txt2=c("beta=1.5")
legend("bottomright",txt2, col=c(1),lty=c(1),cex=0.78)

plot(seq(1,niter,1),c(0,rep(0.2,niter-1)),type='n',
     main='Different Pixels with previous iter', xlab='iter',ylab='#/ntot')
for(b in 1:nb){lines(seq(1,niter,1),
                     PixDiff[,b]/ntot,type='l',col=b,lwd=1.5)}
dev.off()