##Example 2.5.poission ####
Nsim=10^4; lambda=100
spread=3*sqrt(lambda)
t=round(seq(max(0,lambda-spread),lambda+spread,1))
prob=ppois(t, lambda)
plot(prob)
X=rep(0,Nsim)
for (i in 1:Nsim){
  u=runif(1)
  X[i]=t[1]+sum(prob<u) }
plot(X)
hist(X)
# R inbuilt faster:
X1<-rpois(Nsim,lambda)
system.time(rpois(Nsim,lambda),gcFirst = TRUE);
plot(X1)
hist(X1)
library(mnormt)
Sigma <- matrix(c(1,2,0,2,5,0.5,0,0.5,3), 3, 3)
sadmvn(low=c(1,2,3),upp=c(10,11,12),mean=rep(0,3),var=Sigma)
attr(,"error")

# student T 
X3<-rt(100)

##X~Neg(n, p),X has the mixture representation X|y~P(y) and Y~G(n, ??)
Nsim=10^4
n=8;p=.3
y=rgamma(Nsim,n,rate=p/(1-p))
X4=rpois(Nsim,y)
hist(X4,main="",freq=F,col="grey",breaks=40)
lines(1:50,dnbinom(1:50,n,p),lwd=2,col="sienna")

##Accept-Reject####
u=runif(1)*M
y=randg(1)
while (u>f(y)/g(y)){
  u=runif(1)*M
  y=randg(1)}

## Illustration of theorem on inversion####
h = seq(0,10,.01) ; lambda = 1/2
plot(h,dexp(h,rate=lambda),type='l',col=2,lwd=2,xlab='',ylab='',ylim=c(0,1)) ; abline(v=0);abline(h=0)
lines(h,pexp(h,rate=lambda),lty=1,lwd=2)
x = rexp(n=1,rate=lambda) ; y = pexp(x,rate=lambda)
points(x,0,col=2,lwd=2,pch=16,cex=2)
points(x,y,col=1,lwd=2,pch=16,cex=2) ;arrows(x0=x,y0=0,x1=x,y1=y,lty=2,angle=15)
points(0,y,col=3,lwd=2,pch=16,cex=2);arrows(x0=x,y0=y,x1=0,y1=y,lty=2,angle=15)
n = 100
h = seq(0,10,.01) ; lambda = 1/2
plot(h,dexp(h,rate=lambda),type='l',col=2,lwd=2,xlab='',ylab='',ylim=c(0,1)) ; abline(v=0);abline(h=0)
lines(h,pexp(h,rate=lambda),lty=1,lwd=2)
x = rexp(n=n,rate=lambda) ; y = pexp(x,rate=lambda)
points(x,rep(0,n),col=2,lwd=2,pch=1,cex=2)
points(x,y,col=1,lwd=2,pch=1,cex=2)
points(rep(0,n),y,col=3,lwd=2,pch=1,cex=2)

## Simulation of an exponential rv by inversion####
lambda = 1/2 ; n=1000 ; u = runif(n);h = seq(0,10,.1); 
plot(h,dexp(h,rate=lambda),
     type='l',lwd=3,col=3,xlab='',ylab='')
x = (-1/lambda) *log(1-u)
points(x,rep(0,n),col=3)
hist(x,breaks=seq(-0.1,max(x)+.1,.1),add=TRUE,prob=TRUE,col=3)
## the right way to code this in R without using rexp:
hist(qexp(runif(n)),breaks=seq(-0.1,max(x)+.1,.1))

## Points uniform between the graph and the x axis####
n = 300
y = rnorm(n) ;# pdf
u = runif(n)
C = 2;
z = u*C*dnorm(y) #cdf
h = seq(-3,3,0.01)
plot(h,dnorm(h),type='l',xlab='',ylab='',xlim=c(-4,4),ylim=c(0,1))
points(y,z,col=2,cex=.8)

## illustrate the previous useless idea####
n <- 15 ;x <- rnorm(n=n,mean=2,sd=1)
func1 <- function()
{
  col <- col + 1
  y <- rnorm(n=n,mean=2,sd=1)
  points(y,rep(0,n),col=col,cex=2)
  abline(v=mean(y),col=col,pch=16,cex=4)
  col
}
col <- 1
plot(x,rep(0,n),type="p",xlab="Data",
     ylab="",xlim=c(-1,4),cex=2)
abline(v=mean(x),col=1,pch=16,cex=4)
col <- func1()

##illustration of boostraping####
func2 <- function()
{
  col <- col + 1
  y <- sample(x=x,size=n,replace=TRUE)
  points(y,rep(0,n),col=col,cex=2)
  abline(v=mean(y),col=col,pch=16,cex=4)
  col
}
col <- 1
plot(x,rep(0,n),type="p",xlab="Data",
     ylab="",xlim=c(-1,4),cex=2)
abline(v=mean(x),col=1,pch=16,cex=4)
col <- func2()

##numerical comparison####
sd <- 1
n <- 200 ; x <- rnorm(n=n,mean=2,sd=sd)
B <- 10000
X.theo <- X.boot <- matrix(nrow=n,ncol=B)
for(b in 1:B)
{
  X.theo[,b] <- rnorm(n=n,mean=2,sd=1)
  X.boot[,b] <- sample(x=x,size=n,replace=TRUE)
}
mean.theo <- apply(X=X.theo,MARGIN=2,FUN=mean)
mean.boot <- apply(X=X.boot,MARGIN=2,FUN=mean)
par(mfrow=c(1,2))
hist(mean.theo,prob=TRUE)
lines(density(mean.theo),col=2,lwd=2); lines(density(mean.boot),lwd=2,col=3)
hist(mean.boot,prob=TRUE)
lines(density(mean.theo),col=2,lwd=2); lines(density(mean.boot),lwd=2,col=3)
var(mean.theo)
var(mean.boot)
sd^2/n # truth

##simulation of a bivariate Gaussian vector with the LU method####
## Define target density
sd =1 ; rho = .8
Sigma = matrix(nr=2,nc=2,data=c(sd,rho,rho,sd))
Sigma
## Choleski factorisation
U = chol(Sigma) ; L = t(U)
L
L %*% U ## just checking
# simulation
n = 1000
x1 = rnorm(n) ; x2 = rnorm(n)
X = rbind(x1,x2)
Y = L %*% X
Y = t(Y)
plot(Y,asp=1) # one data unit in the x direction is equal in length to asp * one data unit in the y direction.
## cheking that the empirical var-covar matrix is close to the target
var(Y)
Sigma
## cheking that empirical bivariate density
require(MASS)
image(kde2d(Y[,1],Y[,2]),asp=TRUE) ; points(Y,cex=.1,col=3)
contour(kde2d(Y[,1],Y[,2]),add=TRUE)
#  Kernel Density Estimation with an axis-aligned bivariate normal kernel, 

