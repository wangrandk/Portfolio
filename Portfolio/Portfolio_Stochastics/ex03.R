rm(list=ls())
##Markov chain####
n <- 50 ; x <- rep(NA,n)
x[1] <- rbinom(n=1,size=1,prob=1/2)
for(i in 2:n)
{
  x[i] <- ifelse(x[i-1]==0,
                 rbinom(n=1,size=1,prob=2/3),
                 rbinom(n=1,size=1,prob=1/5))
}
plot(x)


##Random Walk####
## A random walk on Z
n <- 500 ; x <- rep(NA,n)
x[1] <- rbinom(n=1,size=1,prob=1/2)
for(i in 2:n)
{
  x[i] <- sample(size=1,x=c(x[i-1]-1,x[i-1],x[i-1]+1,prob=rep(1/3,3)))
}
png('randomWalk.png')
plot(x,type='b')
dev.off()
##Markov chain on a continuous space####
n <- 5000 ; x <- rep(NA,n)
x[1] <- rnorm(1)
for(i in 2:n) { x[i] <- x[i-1] + rnorm(1)}
plot(x,type='b')
hist(x,prob=T)
var(rnorm(100))
plot(rnorm(1000),type='l')
hist(rnorm(1000))

##Iterative methods####
n <- 5000 ; X <- rep(NA,n);a=1;
X[1] <- rnorm(1) # Init
f <- function(X,a=1){ a/2*exp(-a*abs(X))}
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
plot(X,type='b')
hist(X,prob=T,breaks=50)
lines(density(X),col=2)
acf(X)

##General Metropolis algorithm####

## Metropolis-Hastings algorithm  ####
X[1] <- runif(n=1,min=0,max=1) # Init
sigma <- 1 #too small sigma cause big p,converge slow to target f. too large sigma cause small p,converge slow to target f.
for(i in 1:(n-1)) # Iterate random update
{
  Y <- rnorm(n=1,mean=X[i],sd=sigma) # propose candidate value
  # compute Metropolis ratio
  R <- (f(Y) * dnorm(X[i],mean=Y,sd=sigma))/
    (f(X[i]) * dnorm(Y,mean=X[i],sd=sigma))
  # compute acceptance probability
  p <- min(1,R)
  # toss an unfair coin to decide if candidate is accepted
  accept <- rbinom(n=1,size=1,prob=p)
  X[i+1] <- ifelse(accept==1, Y, X[i])
}
plot(X,type='b')
hist(X,prob=T,breaks=50)
lines(density(X),col=2)
acf(X)


# M-H multiple chain
# define db exp density
f <- function(x,alpha=1){alpha/2*exp(-alpha*abs(x))}
niterations <- 10000; nchains=1000
XX <- matrix(nr=niterations,nc=nchains,data=NA)
XX[1,] <- runif(n=nchains) # anxilary difficult to choose
for(i in 1:(niterations-1)) # Iterate random update
{
  print(i)
  Y <- rnorm(n=nchains,mean=XX[i,],sd=.5) # propose candidate values
  # compute Metropolis ratios
  R <- (f(Y) * dnorm(x=XX[i,],mean=Y,sd=.5)) / (f(XX[i,]) * dnorm(x=Y,mean=XX [i,],sd=.5))
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

## Two-stages Gibbs sampler I ####



