rm(list=ls())
setwd("C:\\Users\\RAN\\OneDrive\\Documents\\Time_Series_Analysis\\assignment05")
sat <- read.table("Satelliteorbit.csv",sep=",",header=TRUE)

r <- read.csv("Satelliteorbit.csv")[[1]]
theta<- read.csv("Satelliteorbit.csv")[[2]]
n=50
A<-matrix(c(1, 0, 0, 0, 1, 1, 0, 0, 1), nrow=3,ncol=3,byrow=TRUE) 
C<-matrix(c(1, 0, 0,0, 1, 0), nrow=2,ncol=3,byrow=TRUE)

sigma1<-matrix(c(500^2, 0, 0, 0, 0.005^2, 0, 0, 0, 0.005^2), nrow=3,ncol=3,byrow=TRUE)
sigma2<-matrix(c(2000^2, 0, 0,0, 0, 0.03^2), nrow=2,ncol=2,byrow=TRUE)

#initial condition
X <- matrix(nrow=3,ncol=n)
X[,1] = rbind(mean(r),mean(theta),.03)
Y <- matrix(nrow=2,ncol=n)
Y <- rbind(r,theta) 
sigmaxx<-diag(c(1,.01,.01))

library(MASS)
set.seed(286)
for (I in 2:n){
  #pre
  Xpre <- matrix(nrow=3,ncol=n)
  Xpre[,I] <- A %*% X[,I-1] 
  sigmaxx_pre <-A %*% sigmaxx %*% t(A) + sigma1
  sigmayy=C %*% sigmaxx_pre %*% t(C)+sigma2
  
  #updating
  k = sigmaxx_pre %*% t(C) %*% solve(sigmayy);
  X[,I]<-Xpre[,I] + k %*% (Y[,I-1] - C%*%Xpre[,I])
  sigmaxx <-sigmaxx_pre - k %*%C %*% sigmaxx_pre
  Y[,I-1] <- C %*% X[,I-1] + mvrnorm(mu=cbind(0,0),Sigma=sigma2)
}

matplot(cbind(X[1,],rbind(r,theta)[1,]),type="o",pch=c(1,1),col=1:2, main="Distance")
legend("bottomright", c("Reconstruction", "Original"), cex=0.8, col=c("black","red"), pch=c(16,16), lty=c(0,0)) 
matplot(cbind(Y[2,],rbind(r,theta)[2,]),type="o",pch=c(1,1),col=1:2,main="Angle")
legend("bottomright", c("Reconstruction", "Original"), cex=0.8, col=c("black","red"), pch=c(16,16), lty=c(0,0)) 


