library(forecast)
dat <- read.table("assignment3data.txt")
x <- ts(dat,frequency=12,start=1995)
x <- x[1-87]
x1 <- x[1:78]
x2 <- x[-(1:78)]
x1 <- ts(x1, start=1995, frequency = 12)
x2 <- ts(x2, start=c(2001, 7), end=c(2002, 3), frequency = 12)
plot(x1,type='o',pch=16,, ylab="Nm. of passangers")
lines(x1,col=2)         
lines(x2,col=3)
legend("topleft", c("Observations x1", "Model control observations x2"), cex=0.8, col=c("red","green","blue"), lty=c(1,1)) 


diagtool <- function(residuals){
  par(mfrow=c(3,1),mar=c(3,3,1,1),mgp=c(2,0.7,0))
  plot(residuals)
  ## Calculate, but not plot, acf
  acfpl <- acf(residuals, lag.max = 30,plot=FALSE)
  ## Transform the lags from years to months
  acfpl$lag <- acfpl$lag * 12  
  ## Plot the acf 
  plot(acfpl, xlab="Lag (months)",axes = FALSE)
  axis(side = 1, at = c(1,4,8,12,16,20,24,28))
  axis(side=2, at = NULL)
  box()
  
  ## Calculate, but not plot, pacf
  pacfpl <- pacf(residuals, lag.max =30,plot=FALSE)
  ## Transform the lags from years to months
  pacfpl$lag <- pacfpl$lag * 12  
  ## Plot the pacf 
  plot(pacfpl, xlab="Lag (months)",axes = FALSE)
  axis(side = 1, at = c(1,4,8,12,16,20,24,28,32,36))
  axis(side=2, at = NULL)
  box()
}


diagtool(x1)
library(fUnitRoots)
adfTest(x1)
Dx1<- diff(x1,1,12)
Dx1
summary(Dx1)
diagtool((Dx1))
w=adfTest(Dx1)
library(forecast)
auto.arima(x1, d=NA, D=1, max.p=5, max.q=5,
           max.P=2, max.Q=2, max.order=5, max.d=2, max.D=1, 
           start.p=2, start.q=2, start.P=1, start.Q=1, 
           stationary=FALSE, seasonal=TRUE,
           ic=c("aicc","aic", "bic"), stepwise=TRUE, trace=FALSE,
           approximation=(length(x)>100 | frequency(x)>12), xreg=NULL,
           test=c("pp"), seasonal.test=c("ocsb","ch"),
           allowdrift=FALSE, lambda=NULL, parallel=FALSE, num.cores=NULL)

(m1 <- arima(x = x1, order=c(2,0,2),seasonal = list(order=c(1,1,1), period=12) ))
(m2 <- arima(x = x1, order=c(1,0,1),seasonal = list(order=c(1,1,0), period=12)) )
##,fixed=c(0,NA,0,NA,NA,NA)
tsdiag(m1)
tsdiag(m2)
confint(m1)
confint(m2)
qqnorm(m1$residuals)
qqline(m1$residuals,col=2)
diagtool(m1$residuals)
cpgram(m2$residuals)

qqnorm(m2$residuals)
qqline(m2$residuals,col=2)
diagtool(m2$residuals)
cpgram(m2$residuals)

hist(m2$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(m2$sigma2)), col=2, lwd=2, add = TRUE)

hist(m1$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(m1$sigma2)), col=2, lwd=2, add = TRUE)


# sign test mean and sd:
(length(m1$residuals)-1)/2
### sd:
sqrt((length(m1$residuals)-1)/4) 
### 95% interval:
(length(m1$residuals)-1)/2 + 1.96 * sqrt((length(m1$residuals)-1)/4) * c(-1,1)
### test:
res <- m1$residuals
(N.sign.changes <- sum( res[-1] * res[-length(res)]<0 ))

# sign test mean and sd:
(length(m2$residuals)-1)/2
### sd:
sqrt((length(m2$residuals)-1)/4) 
### 95% interval:
(length(m2$residuals)-1)/2 + 1.96 * sqrt((length(m2$residuals)-1)/4) * c(-1,1)
### test:
res <- m2$residuals
(N.sign.changes <- sum( res[-1] * res[-length(res)]<0 ))


library(forecast)
dat <- read.table("assignment3data.txt")
x <- ts(dat,frequency=12,start=1995)
x <- x[1-87]
x1 <- x[1:78]
x2 <- x[-(1:78)]
(m2 <- arima(x = x1, order=c(1,0,1),seasonal = list(order=c(1,1,0), period=12)) )
pred <- forecast(m2,h=9,level=95)
pred
str(pred)
plot (x1,xlim=c(1995, 2003), type="o")
plot(pred,col=1,type="o")
points(x2,col=3,type="o")
fcast <- forecast(m2,h=9,level=95)
plot(fcast,type="o")
points(prediction$pred,col=2,type="o")
points(x2,col=3,type="o")
str(x2)

plot(x, type="n", xlab="Time", ylab="Nm. of passangers", main="Forecast") 
lines((length(x1)+1):length(x),pred$upper, type="l", col="blue", lty=2) 
lines((length(x1)+1):length(x),pred$lower, type="l", col="blue", lty=2)  
points(x, type="o", col="black", pch=16, cex=0.6)
izModela <- c(fitted.Arima(m2), pred$mean) 
points(izModela, type="o", col="red", pch=16, cex=0.6)
legend("bottomleft", c("Observations", "Predictions", "Prediction bounds"), cex=0.8, col=c("black","red","blue"), pch=c(16,16,-1), lty=c(0,0,2)) 

plot(x, type="n", xlab="Observations", ylab="Nm. of passangers", main="Forecast") 

plot(1:8,pred$mean, type="o", col="red", pch=16,ylim=c(33000, 63000),xlab="Predictions", ylab="Nm. of passangers",)
lines(pred$upper, type="l", col="blue", lty=2) 
lines(pred$lower, type="l", col="blue", lty=2)  
points(x2, type="o", col="black",pch=16)
str(pred)
legend("bottomleft", c("Observations", "Predictions", "Prediction bounds"), cex=0.8, col=c("black","red","blue"), pch=c(16,16,-1), lty=c(0,0,2)) 

