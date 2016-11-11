rm(list=ls())
## II ####
n=100; p=2;
X <- matrix(nr=n,nc=p,data=NA)
for (i in 1:n){
X[i,]<-runif(2,min=0,max=1)
}
h <- function(x1,x2){sqrt(x1^2 + x2^2)}
plot(X[,1],X[,2])
I <- mean(h(X[,1],X[,2]))

## Average distance to the centre
## of a point uniform in the unit disc
p = 3 ; n = 10000
## declare matrix for storage and init with dummy values outside the disc,define a square
X = matrix(nrow=n,ncol=p,data=1)
for(i in 1:n)
{
  while(sum(X[i,]^2)>1) { X[i,] = runif(n=p,min=-1,max=1) }  
} # when the p is out side the circle, draw a new until they <=1
plot(X[,1],X[,2],col=2)
plot(X[,1])
hist(X[,1],prob=T)
R = sqrt(apply(X=X^2,MARGIN=1,FUN=sum))
I = mean(R) # h(x): unbiased 


library(rgl)
plot3d(X, col="red", size=3)
library(Rcmdr)
scatter3d(X[,1],X[,2],X[,3])
library(scatterplot3d)
scatterplot3d(X)
var(X)

p = 2 ; n = 10000
X = matrix(nrow=n,ncol=p,data=1)
for(i in 1:n)

  while(sum(X[i,]^2)>1) { X[i,] = rnorm(n=p)} #g(x)
 
plot(X[,1],X[,2],col=2)
plot(X[,1])
hist(X[,1],prob=T)
h = sqrt(apply(X=X^2,MARGIN=1,FUN=sum)) #h(x)
f <- dunif(X,min=-1,max=1)
#I = mean(h %*% (f / (X))) # h(x): unbiased 
I = mean(h)

##exercise Monte Carlo integration I ####
p = 1 ; n = 100000
X =rep(0,n)
for(i in 1:n) {X[i] =runif(n=p,min=0,max=1)} #g(x)
hist(X,prob=T)
h <-function(X){ (cos(50*X) + sin(20*X))^2} #h(x)
png('integral.png')
s=seq (0 ,1 ,0.001)
plot (s,h(s),type ='l',col =1, xlab ="x", ylab ="h(x)")
dev.off()

I = mean(h(X))
integrate(h,0,1)

##exercise Monte Carlo integration II ####
rm(list=ls())
p = 2 ; n = 10000
X = matrix(nrow=n,ncol=p,data=1)
for(i in 1:n)
{
  while(sum(X[i,]^2)>1) { X[i,] = runif(n=p,min=-1,max=1) }
} # g(x)

png("Ball.png")
#png("ising1_inter1to10.png")
# par(mfrow=c(1,2),pty = "s",mex=.7,pin=c(1.9,1.9),cex=1.2)  
plot(X[,1],X[,2],col=2)
# plot(X[,1])
# hist(X[,1],prob=T)
library(rgl)
plot3d(X, col="red", size=3)
dev.off()

Cd =2^p; inliner =0;
I.Bd <- function (x){ifelse (sqrt(sum(x ^2))<1, 1,0)}
X = y = matrix (nr=n,nc=p, data =0) # allocate memory
index =rep (1,n)
X[ ,1]= runif (n , -1 ,1)
X[ ,2]= runif (n , -1 ,1)
for(i in 1:n){  
  inliner  = inliner  + I.Bd(X[i ,])
  if( I.Bd(X[i ,]) ==0) { index [i]=0}
}
for(i in 1:n){
  if( index [i]==1) {
    Y[i,]=X[i,]
  }
}
png ("Uniball_dimension=2.png ")
plot (X[,1],X[,2], main ='Sampling on C2 and keeping points in B2',xlab ='x1',yla='x2')
points (Y[,1] ,Y[,2] , col =2)
dev.off () 

Vd_true =pi ^(p/2)/ gamma (1+p/2)
Vd= Cd* inliner /n  # Cd* rario of (unit ball / hypercube)
h = sqrt(apply(X=Y^2,MARGIN=1,FUN=sum))# radius of each p in the unit circle
I = mean(h) # E[h(X)] mean of radius
pi*I^2

# Estimator of the variance of the Monte Carlo estimate
var <- 1/n^2 * sum((h-I)^2)

# approximate confidence interval: 
a=0.05  
1-a/2
q <- abs(qt(p=a/2, df=n)) # 0.975 confidence, 2 sided
CI <- c( Vd - 1.96 * sqrt(var), Vd + 1.96 * sqrt(var) )

##var####
p=10; Cd =2^p;  B=100; In = rep(0,B); col=1:p
I.Bd <- function (x){ifelse (sqrt(sum(x ^2))<1, 1,0)}
X = y = matrix (nr=n,nc=p, data =0) # allocate memory
#index =rep (1,n)
# X[ ,1]= runif (n , -1 ,1)
# X[ ,2]= runif (n , -1 ,1)

for(j in 1:B){
inliner =0;
for(k in 1:p){
  X[,k]= runif (n ,-1 ,1)}
for(i in 1:n){  
  inliner  = inliner  + I.Bd(X[i ,]);
  #if( I.Bd(X[i ,]) ==0) { index [i]=0}
}
In[j] = inliner;
}
Vd= Cd* In /n;
I = mean(Vd);
var <-  sum((Vd-I)^2) / (n^2) 
var(Vd)

##var using rnorm####
p=2; Cd =2^p;  B=100; In = rep(0,B); col=1:p
I.Bd <- function (x){ifelse (sqrt(sum(x ^2))<1, 1,0)}
X = y = matrix (nr=n,nc=p, data =0) # allocate memory
#index =rep (1,n)
# X[ ,1]= runif (n , -1 ,1)
# X[ ,2]= runif (n , -1 ,1)

for(j in 1:B){
  inliner =0;
  for(k in 1:p){
    X[,k]= rnorm (n ,0,1)}
  for(i in 1:n){  
    inliner  = inliner  + I.Bd(X[i ,]);
    #if( I.Bd(X[i ,]) ==0) { index [i]=0}
  }
  In[j] = inliner;
}
Vd= Cd* In /n;
I = mean(Vd);
var <-  sum((Vd-I)^2) / (n^2) 
var(Vd)
library(MASS)
mvrnorm(n=10, rep(0, 2), Sigma=1)

## II optimization####
h <- function(x){.2*dnorm(x,m=-2,sd=.3) +
                   .5*dnorm(x,m=1,sd=.5) +
                   .5*dnorm(x,m=3,sd=.7)}
n <- 70
U <- runif(n=n,min=-5,max=5)
istar <- which.max(h(U))
xstar <- U[istar]
hstar <- h(xstar)

##Exercises I ####
# uniform simulation
h <- function(x){3*dnorm(x,m=-2,sd=.2) +
                  6*dnorm(x,m=1,sd=.5) +
                   1*dnorm(x,m=3,sd=.3)}
n <- 100
U <- runif(n=n,min=-5,max=5)
s=seq(-4,4,0.1)
plot(s,h(s),type='l')

istar <- which.max(h(U))
xstar <- U[istar]
hstar <- h(xstar)
png('uniform-max.png')
plot(s,hh(s),type='l')
points(U,rep(0,n),col=2)
abline(v=xstar,col=3,lwd=3)
# points(xn,yn,col=2)
# points(xn,rep(0,length(xn)),col=3)
dev.off()

# non-uniform simulation: rejection
n <- 1000
h <- function(x){3*dnorm(x,m=-2,sd=.2) +
                   6*dnorm(x,m=1,sd=.5) + 1*dnorm(x,m=3,sd=.3)}
C = 2
s <- seq(-4,4,0.1);
x = runif(n,-4,4)
y = runif(n,0,1);

hh <- function(x){return(h(x)/integrate(h,-5,5)$value)}
accept <- y<hh(x) # uniform dist under the hh(x) curve
xn = x[accept]
yn = y[accept]
istar <- which.max(hh(xn))
h(xn)[istar] #5.9840
xn[istar] # maximum 
png('non-uniform-rejection.png')
plot(s,hh(s),type='l')
points(xn,rep(0,length(xn)),col=2)
# points(x,y)
# points(xn,yn,col=2)
# points(xn,rep(0,length(xn)),col=3)
abline(v=xn[istar],col=3, lwd=3)
dev.off()
# R inbuilt
optimize(h,lower=-4, upper = 4, maximum = T)


##Exercises II: Annealing  ####
rm(list=ls())
h = function(x,y)
{
  3* dnorm(x,m=0,sd=.5)*dnorm(y,m=0,sd=.5) +
    dnorm(x,m=-1,sd=.5)*dnorm(y,m=1,sd=.3) +
    dnorm(x,m=1,sd=.5)*dnorm(y,m=1,sd=.3)
}
png('contour.png')
x = y = seq(-3,3,0.01)
H = outer(x,y,h)
image(x,y,H,main='contour plot h(x)')
contour(x,y,H,add=TRUE)
dev.off()

image(x,y,H)
X = cbind(x,y)
# lines(X,type='l',lwd=.5)
# n = 100
# points(X[1,1],X[1,2],col=4,pch=16)
# points(X[n,1],X[n,2],col=3,pch=16)


# Annealing 
n <- 10000 ;p=2; X <- matrix(nr= n, nc=p,data=NA);totalACP=0
 X[1,] <- runif(n=2,min=-3,max=3) # Init
#X[1,] = rnorm(n=2,m=0,sd=1);
for(i in 1:(n-1)) # Iterate random update
{
  t = 1/log(i)
  Y = rnorm(n=2,m=0,sd=.1) # propose candidate value
  Xstar = X[i,] + Y
  if (Xstar<-3 || Xstar>3) {
    Y = rnorm(n=2,m=0,sd=.1);
    Xstar = X[i,] + Y
  } 
  delta = h((Xstar[1]),(Xstar[2]))-h(X[i,1],X[i,2])
  p = min(exp(delta/t),1) #exp of slop,only accept positive slop, looking for when h(Xstar) is bigger than h(X). get big prob to move to Xstar.As h(X) gets bigger, X gets centered to 0. the smaller the exp, the smaller the prob that X moves to Xstar.
  accept = as.logical(rbinom(n=1,size=1,prob=p))
  #X[i+1, accept] = Xstar[accept]
  #X[i+1,!accept] = X[i,!accept]
 
  X[i+1,] = ifelse(accept, Xstar, X[i,])
  totalACP[i]=accept
}
sum(totalACP)
#small prob = stay as X, big prob = move to Xstar.
summary(X)

plot(X,type='b')
hist(X[,1],prob=T,breaks=50)
hist(X[,2],prob=T,breaks=50)
lines(density(X),col=2)

acf(X)
png('Annealing.png')
H = outer(x,y,h)
image(x,y,H)
lines(X,type='l',lwd=.8,col=3)
points(X[1,1],X[1,2],col=4,pch=16)
#points(X[,1],X[,2],col=1,pch=8)
points(X[n,1],X[n,2],col=3,pch=16)
dev.off()
max(X)
min(X)
plot(h(X[,1],X[,2]))
