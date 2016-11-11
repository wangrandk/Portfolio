rm(list=ls())
setwd("C:\\Users\\RAN\\OneDrive\\Documents\\Time_Series_Analysis\\assignment04")

hc <- read.csv("veks.csv")$HC.f
hct<-ts(hc)
summary(hct)
ts.plot(hct)

lhct <- log(hct)
summary(lhct)
par(mfrow=c(3,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(lhct)
lines(7300:8782,lhct[7300:8782],col=3)
acf(lhct,lag.max = 30)
pacf(lhct,lag.max = 30)
cov(hct)

ndiffs(lhct, alpha=0.05, test=c("kpss","adf", "pp"), max.d=2)

dlhct1 <- diff(lhct,1)
nsdiffs(dlhct,24)
dlhct <- diff(dlhct1,24)
par(mfrow=c(3,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(dlhct)
acf(dlhct,lag.max = 60,na.action = na.omit)
pacf(dlhct,lag.max = 60,na.action = na.omit)

library(timeDate)
library(forecast)
auto.arima(lhct[7300:8782], d=NA, D=NA, max.p=5, max.q=5,
           max.P=2, max.Q=2, max.order=8, max.d=2, max.D=1, 
           start.p=1, start.q=1, start.P=1, start.Q=1, 
           stationary=FALSE, seasonal=TRUE,
           ic=c("aicc","aic", "bic"), stepwise=TRUE, trace=FALSE,
           approximation=(length(x)>100 | frequency(x)>12), xreg=NULL,
           test=c("kpss","adf","pp"), seasonal.test=c("ocsb","ch"),
           allowdrift=TRUE, lambda=NULL, parallel=FALSE, num.cores=2)

diagtool <- function(residuals){
  par(mfrow=c(3,1),mar=c(3,3,1,1),mgp=c(2,0.7,0))
  plot(residuals)
  acf(residuals,lag.max = 60)
  pacf(residuals,lag.max = 60)
}
diagtool(dlhct)

ar1model = arima(lhct[8000:8782], order = c(2,1,2), method ="ML",seasonal = list(order = c(0, 1, 1), period = 24))

ar2model = arima(lhct[8000:8782], order = c(3,1,1),method ="ML")
ar1model
ar2model
# Likelihood ratio test
pchisq(-2* ( ar1model$loglik - ar2model$loglik ), df=1,lower.tail = FALSE)

#model1
diagtool(ar1model$residuals)
tsdiag(ar1model,lag.max=80)
hist(ar1model$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(ar1model$sigma2)), col=2, lwd=2, add = TRUE)
qqnorm(ar1model$residuals)
qqline(ar1model$residuals,col=2)
plot(ar1model$resid,type="o")
par(mfrow=c(1,1))
cpgram(ar1model$residuals)


# sign test mean and sd:
(length(ar1model$residuals)-1)/2

### sd:
sqrt((length(ar1model$residuals)-1)/4) 
### 95% interval:
(length(ar1model$residuals)-1)/2 + 1.96 * sqrt((length(ar1model$residuals)-1)/4) * c(-1,1)
### test:
res <- ar1model$residuals
(N.sign.changes <- sum( res[-1] * res[-length(res)]<0 ))
#binom.test((length(ar1model$residuals)-1)/2,length(ar1model$residuals)-1)
binom.test(N.sign.changes, length(ar1model$residuals)-1)

#prediction 
p<-forecast(ar1model,h=6)
p
prem<-exp(p$mean)
preu<-exp(p$upper[,2])
prel<-exp(p$lower[,2])
#variance of prediction error 5.151
v<-((p$upper[,2] - p$mean[1:6])/1.96)^2 
v
pre
plot(forecast(ar1model,6))
par(mfrow=c(2,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
plot(p$residuals)
acf(p$residuals)
#1582:1587

plot(hct[8700:8800], type="n", xlab="Time", ylab="heat consumption",ylim=c(200,700), main="6 hour ahead heat consumption forecast") 
lines(hct[8700:8776])
points(83:88,prem,type="o",col=2)
lines(83:88,preu,type="l",lty=2,col=3)
lines(83:88,prel,type="l",lty=2,col=3)
legend("bottomleft", c("Observations", "Predictions", "Prediction bounds"), cex=0.8, col=c("black","red","green"), pch=c(16,16,-1), lty=c(0,0,1)) 



