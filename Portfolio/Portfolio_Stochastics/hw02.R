##Question 1 ####
rm(list=ls())
n = 1:1000
h = seq(-5,5,0.01)
f = 1/(pi * (1+h^2)) ##pdf
png('Cauchy.png')
plot(h,f,type='l',col=2,main="A sample from Cauchy [0,1] distribution") # target
u = runif(n)
x = tan(pi*u - pi/2) ## F cdf Empirical
hist(x,breaks=seq(min(x),max(x)+1,0.3),add=TRUE,prob=TRUE)
dev.off()

##Question 2 ####
n = 1000;
u1 = runif(n); #X
u2 = runif(n); # majorating density
#C <- max(dbeta(h,2,5,ncp=0)) + 0.1
C=3;
z = u2*C*dbeta(u1,2,5,ncp=0) # Y = Ug(X)
h = seq(-.1,1.1,0.01)
png('RejectionMethod.png')
plot(u1,z,main="A sample from beta[2,5]")
lines(h,dbeta(h,2,5,ncp=0),type='l',ylim=c(0,7),col=2,cex=1.9)
accept <- z <= dbeta(u1,2,5,ncp=0)
points(u1[accept],z[accept],col=2,cex=.8)
dev.off()

## Question 3####
n=1000; x = rnorm(n,0,1); u=runif(n); C=2;    
g = dexp(abs(x)); 
#a = 1; g = a/2*exp(-a*abs(x)); 
y =u * C*g;
h = seq(-5,5,.1)
png('DoubleExponentialDistribution.png');
plot(x,y)
lines(h,dexp(abs(h)),col=2)
i = y<=g;
points(x[i],y[i],col=2);
dev.off

##Question 4 #####
n=10;l=1;w=1; iter=9; 
#test = matrix(nrow=n,ncol=iter,data=NA);
test =numeric(n)

png('IntersectionProb.png',height= 1000, width=1000)
par(mfrow=c(3,3),pty = "m",mex=.7,pin=c(3,3),cex=0.9)
# for(i in 1:9){
# plot(x,y,xlim=c(-1,2),ylim=c(-2,2),type='n');
# abline(v=0);abline(v=1)
# }
prob = rep(0,iter)
for(j in 1:iter){
 
  plot(x,y,xlim=c(-1,2),ylim=c(-2,2),type='n')
  abline(v=0);abline(v=1)
for(i in 1:n){
  end = runif(2,0,w);
  a = runif(1,0,2*pi);
  head = numeric(2)
  head[1] = end[1] + cos(a)
  head[2] = end[2] + sin(a)
  x = c(end[1],head[1])
  y = c(end[2],head[2])
  lines(x,y,type='l',col=i, xlim=c(-1,2),ylim=c(-2,2),lwd=2)
  legend(1.2,2,1:n,lwd=rep(2.5,n),col=1:n,cex=.9)
  test[i]= head[1]>l || head[1]<0; 
  } 
prob[j] = mean(test);
#title(prob[j])
title(main = paste("Probability ", prob[j]),cex=1.2)
}
dev.off()
prob1 = mean(prob)

##Question 5 #####
N=10000; lambda = 10;
X = rpois(N,lambda);
X1 = rpois(N,lambda);
# k = X>12;
# X[y]
k <- which(X>12)
d<- diff(k)  #waiting time 
m1=mean(d)

kk <- which(X>X1)
dd <-diff(kk)
m2=mean(dd)

#unconditional
png('poission_conditional_unconditional.png',height=250,width=550)
par(mfrow=c(1,2),pty = "s",mex=.8,pin=c(2,2),cex=.9)
hist(d,breaks=seq(min(d),max(d),0.01),main="Conditional on x=12") # most waiting time<=5
abline(v=m1,col=2);
hist(dd,breaks=seq(min(dd),max(dd),0.01),main="Unconditional")
abline(v=m2,col=2)
dev.off()

prob = lambda/N;
#k1 = X<=12;
k1 <- which(X<12);
dge <- dgeom(k, prob, log = FALSE) # probability that the kth trial (out of k trials) is the first success
# prob that the first success requires k number of trials 
dge <- (1-prob)^(k-1) * prob
png('Geom.png')
plot(dge,type = "o", main = "The Geometric Distribution")
hist(dge,breaks=20,prob=TRUE)
dev.off

##Question 6 #####
n=200; lambda = 10; p = lambda/n; nn=2000;
X1 = rpois(n,lambda);mean(X1); X2 = rpois(nn,lambda);mean(X2);
median(X1); median(X2)
B <- 2000
X1.theo <- X1.boot <- matrix(nrow=n,ncol=B)

for(b in 1:B)
{
  noise=rnorm(n,0,1/sqrt(n))
  X1.theo[,b] <- rpois(n,lambda);
  X1.boot[,b] <- sample(x=X2,size=n,replace=TRUE)
}
median.theo <- apply(X1.theo,MARGIN=2,FUN=median)
median.boot <- apply(X1.boot,MARGIN=2,FUN=median)
png("median.png",height=250,width=550)
par(mfrow=c(1,2))
hist(median.theo,prob=TRUE)
lines(density(median.theo),col=2,lwd=2); 
lines(density(median.boot),lwd=2,col=3);
hist(median.boot,prob=TRUE)
lines(density(median.theo),col=2,lwd=2); 
lines(density(median.boot),lwd=2,col=3);
dev.off()
var(median.theo)
var(median.boot)
lambda/n # truth


##Question 7 #####
#standardize Gaussian: N(0,1), cov() = 0.7

sd =1 ; rho = .7
Sigma = matrix(nr=2,nc=2,data=c(sd,rho,rho,sd))
Sigma
## Choleski factorisation
U = chol(Sigma) ; L = t(U)
L
L %*% U ## just checking
# simulation
n = 50000
x1 = rnorm(n) ; x2 = rnorm(n)
X = rbind(x1,x2)
Y = L %*% X
Y = t(Y)

plot(Y,asp=1) # one data unit in the x direction is equal in length to asp * one data unit in the y direction.
## cheking that the empirical var-covar matrix is close to the target. ij = Cov(Xi ;Xj )
cov(Y)
Sigma
## cheking that empirical bivariate density
require(MASS)
png('empirical bivariate density.png',height=270,width=450)
par(mfrow=c(1,2))
image(kde2d(x1,x2),asp=TRUE) ; points(X,cex=.3,col=3)
contour(kde2d(x1,x2),add=TRUE)
image(kde2d(Y[,1],Y[,2]),asp=TRUE) ; points(Y,cex=.3,col=3)
contour(kde2d(Y[,1],Y[,2]),add=TRUE)
dev.off()
## extrate y2|y1 =0.5
Y2 = Y[,2] 
Y1 = Y[,1] 
Y2 = Y2[Y1>=.49 & Y1<=.51]
Y1 = Y1[Y1>=.49 & Y1<=.51]
Y2 = t(Y2)
Y1 = t(Y1)
YYY = rbind(Y1,Y2)
m2 = mean(Y2)
v2 = var(t(Y2))

png('EmpiricalHist_normalDensity.png')
hist(Y2,breaks=10,prob=TRUE,main="EmpiricalHist_normalDensity",xlim=c(-3,3)) #empirical
lines(density(Y2, kernel = "gaussian"),col=3,lwd=2)
lines(seq(-3,3,0.1),dnorm(seq(-3,3,0.1),m2,sd(t(Y2))),col=2,,lwd=2)
dev.off()
