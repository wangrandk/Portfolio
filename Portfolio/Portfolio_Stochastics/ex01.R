rm(list=ls())
## Linear congruential method ####
a = 31; b =1 ; M =3189
n = 1000 # nb of iterations
x = numeric(length=n)
x[1] = 0
for(i in 2:n)
{
  x[i] = (a*x[i-1] + b) %% M
}
x = x/M


png('hist.png')
par(mfrow=c(2,2))
par(mar=c(4,4,1,1))
hist(x,prob=TRUE)
u = seq(0,1,0.01)
lines(u,dunif(u),col=2) # density f(x) = 1/(max-min) punif(u)=u; dunif(u)=1
# h=2
plot(x[1:98],x[3:100])
plot(x[1:98],x[3:100],type='l')
#plot(x,type='l')
acf(x)
dev.off()

cov(x[1:98],x[3:100]) #[1] -0.0007267802

ks.test(x,"punif",alternative="two.sided")
#t whether two underlying one-dimensional probability distributions differ. 
# punif:Uniform Distribution function. (cumulative distribution function)
# a large p-value indicates accept H0: no difference between simulated RandomNumbers and theoretical 
##R code####
x1<-runif(n=100,min=0,max=1)
hist(x1,prob=TRUE,freq=F)
u = seq(0,1,0.01)
lines(u,dunif(u),col=2)

U=runif(3*10^4)
 U=matrix(data=U,nrow=3) #matrix for sums
 X=-log(U) #uniform to exponential
X1=2* apply(X,2,sum)

system.time(test1());
Z0 <- rchisq(10000, df = 0, ncp = 2.)
graphics::stem(Z0)

n <- 2000
k <- seq(0, n, by = 20)
plot (k, dbinom(k, n, pi/10, log = TRUE), type = "l", ylab = "log density",
      main = "dbinom(*, log=TRUE) is better than  log(dbinom(*))")
lines(k, log(dbinom(k, n, pi/10)), col = "red", lwd = 2)

b<-dbinom(0:90,90,.3)
plot(b,type='l')

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
