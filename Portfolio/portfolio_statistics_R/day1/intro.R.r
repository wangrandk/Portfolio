## Course 02441: Applied Statistics and Statistical Software
## January 2011 by Lasse Engbo Christiansen
##
## This file contains examples given during lectures

###############################################
## Day 1: First R session
###############################################
a<-1:20
b<-runif(20)
c<-rnorm(20,mean=3,sd=4)
plot(a,b)
plot(a,c,type="o",pch=19)
points(a,rnorm(20,3,1),col=2,pch=19)
lines(a,rnorm(20,3,1),col="green",lwd=4)
boxplot(c(b,5),c,rnorm(20,3,1))
d<-rnorm(20,3,1)

mean(b)
mean(c)
var(b)
sd(d)
hist(b)
hist(d)
summary(d)

qqnorm(d)
qqline(d)
## It would be nice to have as a single function:
my.qq <- function(x){
  qqnorm(x)
  qqline(x)
}
class(my.qq)
my.qq(c)

plot(a,c)
points(a[c<2],c[c<2],pch=19,col=2)
abline(h=2,col="purple3",lwd=2)
colors()
?points
?abline

dat<-read.table("humerus.txt",header=TRUE)
summary(dat)
class(dat)
dat[1:4,] ## Indexing as matrix though it is a data.frame
names(dat)  ## Column names of data.frame
dat[,1]
dat$humerus  
dat[["humerus"]]
dat[[1]]
dat[,1]
str(dat)

class(a)
class(b)

which(dat[,2]==1)

e<-matrix(1:12,ncol=3)
e
e<-matrix(1:12,ncol=3,byrow=TRUE)
e[,-2]

dev.print(postscript,file="test.ps")
?postscript
dev.print(postscript,file="test.ps",horizontal=FALSE)

pdf("test2.pdf",width=8,height=3)
plot(a,c)
points(a[c<2],c[c<2],pch=19,col=2)
abline(h=2,col=4,lwd=10)
dev.off()

q()
#rm(list=ls())
