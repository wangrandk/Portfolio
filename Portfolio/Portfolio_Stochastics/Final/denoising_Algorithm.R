#Metropolis-Hastings algorithm for denoising
#we first read the noisy data
nx = 500
ny = 500
ntot = nx*ny

file= 'http://www2.imm.dtu.dk/courses/02443/projects/data/potts.txt'
x0 <- y <-  as.matrix(read.table(file))

#settings
beta=2
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



#plotting the noisy data
#movie press to continue
#image(seq(0,1,l=nx),seq(0,1,l=ny),y,
#      main="Chain at time 0",
#      xlab="x",ylab="y",
#      col=terrain.colors(8))  

#cat ("Press [enter] to continue")
#line <- readline()   

#we need the dispersion of the noise. Gaussian with dispersion
#sigma. lets make an histogram.
yvec=as.vector(y)

hist(yvec)
#Lets make a model and try different sigmas
# We can say A=B in model 1
A <- B <- 1/2
sigma=0.5 # try differnt values
h=seq(-4,4,0.01)
model1=A*dnorm(h,0,sigma)+B*dnorm(h,1,sigma)
png("sigma_noise.png")
plot(h,model1,type='l',col=2,lwd=2,
     main='data & model',xlab='y',ylab='density')
hist(yvec,breaks=seq(-4,4,0.25),add=T,prob=T)
dev.off()
#From now on sigma=1/2 


x=y;#this x is y the noisy map, but i am using y as 
    # the next iter
png("data_patch.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),y,
      main="Chain at time 0",
      xlab="x",ylab="y",
      col=terrain.colors(8))  

# ok, data is very big lets take a small patch 50x50
nx <- ny <- 50
ntot=nx*ny
smallx=x[1:nx,1:ny]
image(seq(0,1,l=nx),seq(0,1,l=ny),smallx,
      main="patch 50x50 t=0",
      xlab="x",ylab="y",
      col=terrain.colors(8))
dev.off()
x=smallx

#initializing things for the bucle
#z=matrix(nr=nx,nc=ny,)
mass=rep(0,niter)
mass[1]=sum(x)/ntot;
y=matrix(nx,ny,data=NA)
for(t in 2:niter){
  for(i in 1:nx){
    for(j in 1:ny){
      #we operate in each pixel every iteration
      #first we choose a candidate 1 or 0 with p=0.5
      xcand=rbinom(1,1,prob=0.5) # This is a symetric proposal?
                                 # can we say q(xcand)/q(x[i,j])=1?
      clone=x;clone[i,j]=xcand
      
      #we target the posterior p(x|y) \prop p(y|x) p(x) 
      #p(x)=prior encoded up
      #p(y|X=x)=Thats N(x,sigma)
          
      
      #compute the ratio R=f(xcand)*q(x)/f(x)*q(xcand)
      R=prior(clone,i,j,beta)/prior(x,i,j,beta)
      R=R*dnorm(xcand,x[i,j],sigma)/dnorm(x[i,j],xcand,sigma)
      #the probability p
      p=min(1,R)
      # toss an unfair coin to decide if candidate is accepted
      accept <- rbinom(n=1,size=1,prob=p)
      y[i,j] <- ifelse(accept==1, xcand, x[i,j])      
      
    }
    
  }
  #all the pixels have change this iteration, we put y on x
  x=y
  mass[t]=sum(x)/ntot # total mass of black points
  #if(t %% 100 == 0) {z[,,cont]=y;cont=con
  #Evolutionplot
  if(t %% (niter/10) ==0){ #time to see the changes
  par(mfrow=c(1,2))     
  image(seq(0,1,l=nx),seq(0,1,l=ny),smallx,
        main="Chain at time 0",
        xlab="x",ylab="y",
        col=terrain.colors(8))
  
   image(seq(0,1,l=nx),seq(0,1,l=ny),x,
         main=paste("Chain at time ",t),
         xlab="x",ylab="y", 
         col=terrain.colors(8))  
  #  cat ("Press [enter] to continue")
  #  line <- readline()    
  
  
  }
}


png("denoising.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),smallx,
      main="Chain at time 0",
      xlab="x",ylab="y",
      col=terrain.colors(8))
image(seq(0,1,l=nx),seq(0,1,l=ny),x,
      main=paste("Chain at time",niter),
      xlab="x",ylab="y",
      col=terrain.colors(8))
dev.off()

png("mass2.png")
plot(seq(1,niter,1),c(0,rep(1,niter-1)),type='n',
     main='mass of blacks (ones)', xlab='iter',ylab='mass')
lines(seq(1,niter,1),mass,type='l')
dev.off()