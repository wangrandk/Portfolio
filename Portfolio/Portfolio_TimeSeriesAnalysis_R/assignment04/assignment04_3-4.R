rm(list=ls())
setwd("C:\\Users\\RAN\\OneDrive\\Documents\\Time_Series_Analysis\\assignment04")
Hc<-read.csv("veks.csv",skip=8039)[[10]]
Ta<-read.csv("veks.csv",skip=8039)[[7]]
GR<-read.csv("veks.csv",skip=8039)[[9]]
W<-read.csv("veks.csv",skip=8039)[[8]]
Hct <- ts(Hc, start=8040)
Tat <- ts(Ta, start=8040)
GRt <- ts(GR, start=8040)
Wt  <- ts(W, start=8040)



#Ta
par(mfrow=c(3,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(Tat)
acf(Tat)
pacf(Tat)

dTat<-diff(Tat)
par(mfrow=c(3,1))
ts.plot(dTat)
summary(dTat)
acf(dTat)
pacf(dTat)

#GR
par(mfrow=c(2,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(GR)
ts.plot(diff(log(GRt)))
dlGRt<-diff(log(GRt))
summary(dlGRt)
dlGRt<-na.omit(dlGRt)
acf(dlGRt,type=c("correlation"),na.action = na.omit)
pacf(dlGRt,na.action = na.omit)

#W
par(mfrow=c(2,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(Wt)
ts.plot(diff(Wt))
dWt<-diff(Wt)
summary(dWt)
dGRt<-na.omit(dWt)
acf(dWt)
pacf(dWt)

#Hcta
HcTa <- cbind(Hct,Tat)
lHcTa <- cbind(log(Hct),Tat)
lHc<-log(Hct)
HcTa
summary(HcTa)
head(HcTa)
ndiffs(Tat, alpha=0.05, test=c("kpss","adf", "pp"), max.d=2)
nsdiffs(HcTa,24)
ldHcTa <- cbind(diff(log(Hct)),diff(Tat))
lHcTa<-na.omit(lHcTa)
ldHcTa<-na.omit(ldHcTa)
plot(ldHcTa)
summary(HcTa)
head(HcTa)
HcTa<-na.omit(HcTa)
ts.plot(HcTa)
par(mgp=c(2,0.7,0), mar=c(3,3,3,1))
acf(HcTa,na.action = na.omit)
pacf(HcTa,na.action = na.omit)
ccf(Tat,Hct,na.action = na.omit)
#HcGR
HcGR <- cbind(Hct,GRt)
summary(HcGR)
head(HcGR)
plot(HcGR)
HcGR <- cbind(diff(log(Hct)),diff(log(GRt)))
summary(HcGR)
head(HcGR)
HcGR<-na.omit(HcGR)
plot(HcGR)
par(mgp=c(2,0.7,0), mar=c(3,3,3,1))
acf(HcGR,na.action = na.omit)
pacf(HcGR,na.action = na.omit)

#HcW
HcW <- cbind(Hct,Wt)
summary(HcW)
plot(HcW)
HcW <- cbind(diff(log(Hct)),diff(Wt))
summary(HcW)
head(HcW)
HcW<-na.omit(HcW)
plot(HcW)
par(mgp=c(2,0.7,0), mar=c(3,3,3,1))
acf(HcW,na.action = na.omit)
pacf(HcW,na.action = na.omit)
ccf(Hct,Wt,na.action=na.omit)

fit1<-auto.arima(lHcTa[,2], d=NA, D=NA, max.p=5, max.q=5,
                 max.P=5, max.Q=5, max.order=10, max.d=2, max.D=1, 
                 start.p=1, start.q=1, start.P=1, start.Q=1, 
                 stationary=TRUE, seasonal=FALSE,
                 ic=c("aicc","aic", "bic"), stepwise=TRUE, trace=FALSE,
                 approximation=(length(x)>100 | frequency(x)>12), xreg=NULL,
                 test=c("kpss","adf","pp"), seasonal.test=c("ocsb","ch"),
                 allowdrift=TRUE, lambda=NULL, parallel=FALSE, num.cores=NULL)
fit1 
summary(fit1) 
fit1$aic 

#input
ar1model = arima(lHcTa[,2], order = c(4,0,0),method ="ML")
ar1model
#output 
ar2model = arima(lHcTa[,1], order = c(4,0,1),method ="ML")
ar2model
diagtool <- function(residuals){
  par(mfrow=c(3,1),mar=c(3,3,1,1),mgp=c(2,0.7,0))
  plot(residuals)
  acf(residuals,lag.max = 60)
  pacf(residuals,lag.max = 60)
}
#model1
diagtool(ar1model$residuals)
tsdiag(ar1model,lag.max=80)
hist(ar1model$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(ar1model$sigma2)), col=2, lwd=2, add = TRUE)
qqnorm(ar1model$residuals)
qqline(ar1model$residuals,col=2)
plot(ar1model$resid,type="o")
par(mfrow=c(1,1))
cpgram(ar2model$residuals)
#model2
diagtool(ar2model$residuals)
tsdiag(ar2model,lag.max=80)
hist(ar2model$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(ar2model$sigma2)), col=2, lwd=2, add = TRUE)
qqnorm(ar2model$residuals)
qqline(ar2model$residuals,col=2)
plot(ar2model$resid,type="o")
par(mfrow=c(1,1))
cpgram(ar2model$residuals)
## Use it to PreWhite x:
pwx=ar2model$residuals
a1 <- ar1model$coef
## Use it to PreWhite y:
library(forecast)
pwy2 <- Arima(lHcTa[,1], model=ar1model)
par(mfrow=c(2,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
plot(pwy2$residuals)
ccf(pwx, pwy2$residuals, na.action=na.omit)
pacf(c(pwx, pwy2$residuals), na.action=na.omit)
#ccf suggest 0,-1,-3
z = cbind(Tat, lag(Tat,-1), lag(Tat,-3))
fit3<-arima(lHcTa[,1],order=c(4,0,1),xreg=z)
summary(fit3)
tsdisplay(residuals(fit3))

#residual test
diagtool(fit3$residuals)
tsdiag(fit3,lag.max=80)
hist(fit3$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(fit3$sigma2)), col=2, lwd=2, add = TRUE)
qqnorm(fit3$residuals)
qqline(fit3$residuals,col=2)
plot(fit3$resid,type="o")
par(mfrow=c(1,1))
cpgram(fit3$residuals)
fit3<-na.omit(fit3)



#prediction 
p<-predict(fit3,c(4,0,2),n.ahead = 6,se.fit = TRUE, interval ="confidence", level=95)
p
pre<-exp(p$pred)
p<-c(exp(p$pre),exp(p$se))
p
se<-exp(p$se) *  2
lower<-pre - se
upper<-pre + se
preu


plot(Hct[716:739], type="l",xlim=c(0,30),ylim=c(280,620), xlab="Time", ylab="heat consumption", main="Forecast") 
Hct
lines(25:30,pre,type="l", lty=1, col=2)
lines(25:30,lower,type="l",lty=2,col=3)
lines(25:30,upper,type="l",lty=2,col=3)
legend("bottomleft", c("Observations", "Predictions", "Prediction bounds"), cex=0.7, col=c("black","red","green"), pch=c(16,16,-1), lty=c(0,0,1)) 








