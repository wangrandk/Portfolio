#same with new figure
rm(list=ls())
#we first read the noisy data
nx = 500
ny = 500
ntot = nx*ny

file= 'http://www2.imm.dtu.dk/courses/02443/projects/data/potts.txt'
x0 <- y <-  as.matrix(read.table(file))

#settings
betavec=c(1.5,2)
nb=length(betavec)
niter=100

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



sigma=0.5 # I just did that in find_sigma_noise.R

x <- x0

#we need a binary image to operate with prior. Lets do that
#we will use noisy.dew in the sampling distribution
threshold=mean(x)
for(i in 1:nx){
  for(j in 1:ny){
    x[i,j] <- ifelse(x[i,j]>threshold,1,0)  
  }
}

x1 <- x #binarized image first element of the chain

#initializing things for the bucle
#z=matrix(nr=nx,nc=ny,)
PixDiff <- mass <- matrix(nr=niter,nc=nb,data=NA)
mass[1,]=sum(x)/ntot;
PixDiff[1,]=0 # we will set this one to PixDiff[2,]
y=matrix(nx,ny,data=NA)
reconst=matrix(nr=ntot,nc=nb,data=NA)

for(b in 1:nb){
  beta=betavec[b]
  x <- x1
  for(t in 2:niter){
    ptm <- proc.time()
    print(c("beta=",as.character(beta),"time= ",as.character(t)))
    for(i in 1:nx){
      for(j in 1:ny){
        #we operate in each pixel every iteration
        # binary images: candidate opposite value
        # unequivoity :: q(xcand)/q(x[i,j])=1?
        xcand=1-x[i,j]
        clone=x;clone[i,j]=xcand
        
        #we target the posterior p(x|y) \prop p(y|x) p(x) 
        #p(x)=prior encoded up
        #p(y|X=x)=Thats N(x,sigma) Y are our candidates :)!!
        
        
        #compute the ratio R=f(xcand)*q(x)/f(x)*q(xcand)
        R=prior(clone,i,j,beta)/prior(x,i,j,beta)
        R=R*dnorm(x0,xcand,sigma)/ #x0 is the noisy data y in the report
          dnorm(x0,x[i,j],sigma)
        #the probability p
        p=min(1,R)
        # toss an unfair coin to decide if candidate is accepted
        accept <- rbinom(n=1,size=1,prob=p)
        y[i,j] <- ifelse(accept==1, xcand, x[i,j])      
        
      }
      
    }
    #Count the different pixels with respect to previous elements
    #We can see the convergence here
    PixDiff[t,b]=sum(x!=y)
    #all the pixels have change this iteration, we put y on x
    x=y
    mass[t,b]=sum(x)/ntot # total mass of black points
 
    #if(t %% 10 == 0) {z[,,cont]=y;cont=con
    #Evolutionplot
    if(t %% 1 ==0){ #time to see the changes
      par(mfrow=c(1,2))     
      image(seq(0,1,l=nx),seq(0,1,l=ny),x1,
            main=paste("Chain Starter"),
            xlab="x",ylab="y",
            col=c("white","black"))
      
      image(seq(0,1,l=nx),seq(0,1,l=ny),x,
            main=paste("time ",t,"PixDiff/ntot",PixDiff[t,b]/ntot),
            xlab="x",ylab="y", 
            col=c("white","black"))  
      #  cat ("Press [enter] to continue")
      #  line <- readline()    
      
      
    }
  }
  #collecting the last elements
  reconst[,b]=as.vector(x)
  proc.time() - ptm
}
#removing the zeros of PixDiff[1,]
PixDiff[1,] = PixDiff[2,]

#plottings for me
png("reconst_data_100.png")
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
image(seq(0,1,l=nx),seq(0,1,l=ny),x0,
      main="Noisy data",
      xlab="",ylab="",
      col=terrain.colors(8))
for(b in 1:nb){
  lola=matrix(nr=nx,nc=ny,reconst[,b])
 image(seq(0,1,l=nx),seq(0,1,l=ny),lola,
      main=paste("reconst with",niter,"beta=",betavec[b]),
      xlab="",ylab="",
       col=c("white","black"))
}

dev.off()

png("data_MassPixDiff_100.png",height=300)
par(mfrow=c(1,2)) 
plot(seq(1,niter,1),c(0,rep(1,niter-1)),type='n',
     main='mass of blacks (ones)', xlab='iter',ylab='mass')
for(b in 1:nb){lines(seq(1,niter,1),mass[,b],type='l',col=b,lwd=1.5)}
# legend
txt2=c("beta=1.5","beta=2.0")
legend("bottomright",txt2, col=c(1,2),lty=c(1,1),cex=0.78)

plot(seq(1,niter,1),c(0,rep(0.4,niter-1)),type='n',
     main='PixDiff with prev iter, xlab='iter',ylab='#/ntot')
for(b in 1:nb){lines(seq(1,niter,1),
                     PixDiff[,b]/ntot,type='l',col=b,lwd=1.5)}
dev.off()