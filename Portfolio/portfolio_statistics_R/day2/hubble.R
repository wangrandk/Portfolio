
###############################################
## Day 2: Example: Hubble's law
###############################################
hub<-read.table("hubble.txt",header=TRUE)
summary(hub)
plot(velocity~distance,hub)
lm1<-lm(velocity~distance,data=hub)
summary(lm1)
par(mfrow=c(2,2))
plot(lm1) ## OK
#intercept in not significant, so -1
lm2<-lm(velocity~distance-1,hub)
lm2<-update(lm1,~.-1) #for formula, "." 
summary(lm2)
par(mfrow=c(2,2))
plot(lm2) # standardized resid = resid/ standard var

## Looking at prediction interval and conf interval:
par(mfrow=c(1,1))
abline(lm2,col=3,lwd=3)
pred.data <- data.frame(distance=seq(0,max(hub$distance),length=100))
pred.int<-predict(lm2,int="prediction",newdata=pred.data)
plot(velocity~distance,hub, ylim=range(hub$velocity, pred.int, na.rm=T))
pred.x <- pred.data$distance
matlines(pred.x, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm2, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red")

# v[y]= v[x * theta +e]= x v[theta] trans[x] + sigma^2 
# x v[theta] trans[x]  /Red
# x v[theta] trans[x] + sigma^2 //Black

## Predicting outside the range of the data
par(mfrow=c(1,1))
plot(velocity~distance,hub)
abline(lm1)
pred.data <- data.frame(distance=seq(0,max(hub$distance)*3,length=30))
pred.int<-predict(lm2,int="prediction",newdata=pred.data)
plot(velocity~distance,hub, ylim=range(hub$velocity, pred.int, na.rm=T),xlim=c(0,6))
pred.x <- pred.data$distance
matlines(pred.x, pred.int, lty=c(1,2,2), col="black",lwd=3)
conf.int<-predict(lm2, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red",lwd=3)

## How to get to the prediction interval
summary(lm2)
leg<-predict(lm1,int="prediction",newdata=pred.data,se.fit=TRUE)
str(leg)
cbind(leg[[1]][,1]-leg[[1]][,2],sqrt(leg$se.fit*leg$se.fit+leg$res*leg$res)*qt(0.975,22))

## Diagnostic plots
par(mfrow=c(2,2))
plot(lm2)

