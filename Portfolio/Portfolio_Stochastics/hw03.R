rm(list=ls())
##1####
#Simulate a Markov chain with values in S = {0,1} such that P(xi=1|xi-1=0) = 1/sqrt(2) and P(xi = 1|xi-1 =1) = 1/pi Plot the result.

n <- 5000 ; x <- rep(NA,n)
x[1] <- rbinom(n=1,size=1,prob=1/2)
for(i in 2:n)
{
  x[i] <- ifelse(x[i-1]==0,
                 rbinom(n=1,size=1,prob=1/sqrt(2)),
                 rbinom(n=1,size=1,prob=1/pi))
}
png('Simple MC.png')
plot(x)
dev.off()

##2 Metropolis algorithm####
n <- 10000 ; X <- rep(NA,n)
X[1] <-rnorm(n=1,m=0,sd=1) # Init
f<- function(X) {dcauchy(X,location = 0, scale = 1) }
#f<- function(X,l=0,s=1) {1/(pi*s (1 + ((X-l)/s)^2))}
for(i in 1:(n-1)) # Iterate random update
{
  Y <- rnorm(n=1,m=0,sd=1) # propose candidate value
  # compute Metropolis ratio
  R <- (f(Y) * dnorm(X[i],m=0,sd=1)) / (f(X[i]) * dnorm(Y,m=0,sd=1))
  # compute acceptance probability
  p <- min(1,R)
  # toss an unfair coin to decide if candidate accepted
  accept <- rbinom(n=1,size=1,prob=p)
  X[i+1] <- ifelse(accept==1, Y, X[i])
}
png('Metropolis.png',height= 260, width=600)
par(mfrow=c(1,3),pty = "s",mex=.7,pin=c(1.9,1.9),cex=1.2)
plot(X,type='b')
hist(X,prob=T,breaks=50)
lines(density(X),col=2)
acf(X)
dev.off()

## 3 Metropolis-Hastings algorithm  ####
n <- 500 ; X <- rep(NA,n)
X[1] <- rnorm(n=1,m=0,sd=1) # Init
sigma <- 3
f<- function(X) {dcauchy(X,location = 0, scale = 1) }
for(i in 1:(n-1)) # Iterate random update
{
  Y <- rnorm(n=1,mean=X[i],sd=sigma) # propose candidate value
  # compute Metropolis ratio
  R <- (f(Y) * dnorm(X[i],mean=Y,sd=sigma)) /
    (f(X[i]) * dnorm(Y,mean=X[i],sd=sigma))
  # compute acceptance probability
  p <- min(1,R)
  # toss an unfair coin to decide if candidate is accepted
  accept <- rbinom(n=1,size=1,prob=p)
  X[i+1] <- ifelse(accept==1, Y, X[i])
}
png('Metropolis_Hastings.png',height= 260, width=600)
par(mfrow=c(1,3),pty = "s",mex=.7,pin=c(1.9,1.9),cex=1.2)
plot(X,type='b')
hist(X,prob=T,breaks=50,xlim=c(-10,10))
lines(density(X),col=2)
acf(X)
dev.off()


## 4 Rejection & Metropolis-Hastings ####
# Rejection: probability of rejection increases exponentially as dimension increases
n = 1000;
u1 = runif(n);
u2 = runif(n); # majorating density
#C <- max(dbeta(h,2,5,ncp=0)) + 0.1
C=2;
z = u2*C*dbeta(u1,1/2,1/2) # Y = Ug(X)
h = seq(-.1,1.1,0.01)
png('RejectionMethod.png',height= 260, width=600)
par(mfrow=c(1,2),pty ="s",mex=.7,pin=c(1.9,1.9),cex=1.2)
plot(u1,z,col=2,main='beta(1/2,1/2) Rejection')
#points(u1,z,col=2,cex=.8)
z1 <- z <dbeta(u1,1/2,1/2)

points(u1[z1],z[z1],col=1,cex=.8)
lines(h,dbeta(h,1/2,1/2),col=3,lwd=3)
acf(z[z1])
dev.off()

# MH: dimension insensitive
n <- 1000 ; X <- rep(NA,n)
X[1] <-runif(n=1, min = 0, max = 1) # Init
sigma <- 1
f<- function(X) {dbeta(X,.5, .5,ncp = 0) }
for(i in 1:(n-1)) # Iterate random update
{
  Y <- runif(n=1, min = 0, max = 1) # propose candidate value
  # compute Metropolis ratio
  R <- (f(Y) * dunif(X[i])) / (f(X[i]) * dunif(Y))
  # compute acceptance probability
  p <- min(1,R)
  # toss an unfair coin to decide if candidate is accepted
  accept <- rbinom(n=1,size=1,prob=p)
  X[i+1] <- ifelse(accept==1, Y, X[i])
}
png('MH_beta.png',height= 260, width=700)
par(mfrow=c(1,3),pty ="s",mex=.7,pin=c(1.9,1.9),cex=1.2)
plot(X,main='beta(1/2,1/2) H-M')
hist(X,prob=T,breaks=50)
s <- seq(0,1,.1)
lines(s,dbeta(s,.5,.5),col=3,lwd=3)
#lines(density((X)),col=2)
acf(X)
dev.off()

## 5####
#5 In the three examples above, estimate the auto-correlation functions of the simulated process (use the R function acf).

## 6####
iter<-10000; n <- 1000 ;mu = 0; sigma<-.5
#f<- functin(X){mvrnorm(n = X, mu, Sigma, tol = 1e-6, empirical = FALSE, EISPACK = FALSE)}
X <- rep(NA,n);
Y <- rep(NA,n-1);
X[1] <- rnorm(n=1,mu,sigma)    # Initial

for(i in 1:(n-1)) # Iterate random update
{ # Two-stage Gibbs sampler
  Y[i] <- rnorm(n=1,mean=sigma*X[i], sqrt(1-sigma^2)) # propose candidate values
  X[i+1] = rnorm(n=1,mean=sigma*Y[i], sqrt(1-sigma^2)) 
}
png('Gibbs_bivariate.png',height= 700, width=700)
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
plot(X[-n],Y) 
#plot(X)
ccf(X[-n],Y)
var(cbind(X[-n],Y))
hist(X,prob=T)
lines(seq(-3,3,.1),dnorm(seq(-3,3,.1),mean(X),sd(t(X))), col=2)
hist(Y,prob=T)
lines(seq(-3,3,.1),dnorm(seq(-3,3,.1),mean(Y),sd(t(Y))), col=2)
#lines(density(X),col=2)
dev.off()

  # compute Metropolis ratios
  R <- (f(Y) * dnorm(x=XX[i,],mean=sigma*XX[i,], sigma= 1-sigma^2)) / (f(XX[i,]) * dnorm(x=Y,mean=sigma*XX[i,], sigma= 1-sigma^2))
  # For q chosen to be equal to f , R = 1.
  # compute acceptance probabilities
  p = rep(1,nchains)
  p[R<1] = R[R<1]
  # toss an unfair coin to decide if candidates are accepted
  accept <- as.logical(rbinom(n=nchains,size=1,prob=p))
  XX[i+1,accept] = Y[accept]
  XX[i+1,!accept] = XX[i,!accept]
}
plot(XX[,1],type="l")
for(ichain in 1:10)
{ lines(XX[,ichain],col=ichain) }
par(mfrow=c(2,2))
for(iter in c(1,10,1000,10000))
{
  hist(XX[iter,],breaks=seq(-15,15,0.1),
       main=paste('Iteration',iter),xlab='x',prob=TRUE)
  lines(seq(-10,10,0.01),f(seq(-10,10,0.01)),col=2)
}
y = c(rexp(n=100000,rate=1),-rexp(n=100000,rate=1))
lines(density(y),col=3,lty=2,lwd=3)
var(y)
for(iter in c(1,10,1000,10000))
{ print(paste("Iteration",iter,"; Variance=",var(XX[iter,]))) }
plot(XX,type='b')
hist(XX,prob=T,breaks=50)
lines(density(XX),col=2)
acf(XX)
