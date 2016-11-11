#Projekt 1:
#load data:
rm(list = ls(all = TRUE))
par(mfrow=c(1,1))
data <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/SPR.txt",header=T)

par(mfrow=c(2,3))
plot(Response~En)
#look at linear model for data:
par(mfrow=c(2,2))
lm1 <- lm(Response~(Enzyme*EnzymeConc*DetStock*CaStock),data)
summary(lm1)
plot(lm1)
# not so good. Need transformation. but which one?
##################################################
#transformations:
data$Log.response <- log(data$Response)
data$Sqrt.response <- sqrt(data$Response)
data$Sq.response <- data$Response^2

#plot for reponse no transformation:
x1 <- data$Response
h1<-hist(x1, breaks=8, col="red", xlab="Response", 
        main="Histogram with Normal Curve") 
xfit1<-seq(min(x1),max(x1),length=40) 
yfit1<-dnorm(xfit1,mean=mean(x1),sd=sd(x1)) 
yfit1 <- yfit1*diff(h1$mids[1:2])*length(x1) 
lines(xfit1, yfit1, col="blue", lwd=2)
#plot for log response:
x2 <- data$Log.response
h2<-hist(x2, breaks=8, col="red", xlab=" Log Response", 
         main="Histogram with Normal Curve") 
xfit2<-seq(min(x2),max(x2),length=40) 
yfit2<-dnorm(xfit2,mean=mean(x2),sd=sd(x2)) 
yfit2 <- yfit2*diff(h2$mids[1:2])*length(x2) 
lines(xfit2, yfit2, col="blue", lwd=2)
#plot for sqrt response:
x3 <- data$Sqrt.response
h3<-hist(x3, breaks=8, col="red", xlab="Sqrt Response", 
         main="Histogram with Normal Curve",ylim=c(0,35)) 
xfit3<-seq(min(x3),max(x3),length=40) 
yfit3<-dnorm(xfit3,mean=mean(x3),sd=sd(x3)) 
yfit3 <- yfit3*diff(h3$mids[1:2])*length(x3) 
lines(xfit3, yfit3, col="blue", lwd=2)

# plot for sq response:
x4 <- data$Sq.response
h4<-hist(x4, breaks=15, col="red", xlab="Square Response", 
         main="Histogram with Normal Curve") 
xfit4<-seq(min(x4),max(x4),length=40) 
yfit4<-dnorm(xfit4,mean=mean(x4),sd=sd(x4)) 
yfit4 <- yfit4*diff(h4$mids[1:2])*length(x4) 
lines(xfit4, yfit4, col="blue", lwd=2)

#using sqrt transformation but it seems as log transformation might also could be possible.

