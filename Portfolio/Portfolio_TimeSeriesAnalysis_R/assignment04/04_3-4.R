rm(list=ls())
setwd("C:\\Users\\RAN\\OneDrive\\Documents\\Time_Series_Analysis\\assignment04")

Hc <- read.csv("veks.csv")$HC.f
Ta<-read.csv("veks.csv")$Ta.f
GR<-read.csv("veks.csv")$GR.f
W<-read.csv("veks.csv")$W.f
Hct <- ts(Hc, start=0, frequency=24)
finalplot<-Hct[8750:8779]
Tat <- ts(Ta, start=0, frequency=24)
GRt <- ts(GR, start=0, frequency=24)
Wt <- ts(W, start=0, frequency=24)
##Tat<-20*Tat
plot(Hct,type="l")
lines(7300:8782,Hct[7300:8782],col=3)
Hct<- Hct[8035:8773]
Tat<-Tat[8035:8773]
summary(Tat)
GRt<-GRt[8035:8773]
Wt<-Wt[8035:8773]
ldata<-cbind(Hct,Tat)
par(mfrow=c(2,2),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(Hct)
ts.plot(Tat)
ts.plot(GRt)
ts.plot(Wt)
par(mfrow=c(3,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ccf(Hct,Tat)
ccf(Hct,GRt)
ccf(Hct,Wt)

par(mfrow=c(3,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ccf(Tat,Hct)
ccf(GRt,Hct)
ccf(Wt,Hct)


data <- cbind(Hct,Tat,GRt,Wt)
summary(data)
head (data)
data<-na.omit(data)


#Ta
par(mfrow=c(3,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(Tat)
acf(Tat)
pacf(Tat)

lTat<-log(Tat)
par(mfrow=c(3,1))
ts.plot(lTat)
summary(lTat)
acf(lTat)
pacf(lTat)

dlTat<-diff(lTat)
ts.plot(dlTat))
summary(dlTat)
acf(dlTat)
pacf(dlTat)


#GR
par(mfrow=c(2,1),mgp=c(2,0.7,0), mar=c(3,3,3,1))
ts.plot(GR)
ts.plot(log(GRt))
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
dlHct<-na.omit(dlHct)
HcTa <- cbind(diff(Hct),diff(Tat))
summary(HcTa)
head(HcTa)
plot(HcTa)


HcTa <- cbind(Hct,Tat)
#HcTa <- cbind(Hct,Tat)

summary(HcTa)
head(HcTa)
HcTa<-na.omit(HcTa)
plot(HcTa)
par(mgp=c(2,0.7,0), mar=c(3,3,3,1))
acf(HcTa,na.action = na.omit)
pacf(HcTa,na.action = na.omit)

#HcGR
HcGR <- cbind(Hct,GRt)
summary(HcGR)
head(HcGR)
plot(HcGR)

HcGR <- cbind(diff(log(Hct)),diff(log(GRt)))
summary(HcGR)
head(HcGR)
HcGR<-na.omit(HcGR)
plot(HcGR,na.action = na.omit)
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

#AR
var.auto <- ar(HcTa,order.max = 20)
var.auto # VAR(3)
summary(var.auto) # Only provides an overview of what is there ...

var.auto$aic # Which model order is best and by how much!

## How about the residuals?
acf(var.auto$resid,na.action = na.omit)
pacf(var.auto$resid,na.action = na.omit)

ks.test(var.auto$resid[,1]/sd(var.auto$resid[,1],na.rm = TRUE),"pnorm")
ks.test(var.auto$resid[,2]/sd(var.auto$resid[,2],na.rm = TRUE),"pnorm")
## Cannot reject independence nor normality

library(vars)

( var1 <- VAR(HcTa,p=3) )
## Not quite the same estimates  - due to different technique
summary(var1)


 (vars.ld <- VARselect(HcTa, type="const", lag.max = 6) )
( vars.l <- VARselect(HcTa, type="const", lag.max = 12) )

( var1ld <- VAR(HcTa, p=6) )
( var1l <- VAR(HcTa, p=2) )
summary(var1ld)
summary(var1l)

serial.test(x = var1ld)
serial.test(x = var1l)

arch.test(var1ld)
arch.test(var1l)

normality.test(var1ld)
normality.test(var1l)

vars.test <- function(x){
  norm <- sapply(normality.test(x)[[2]],function(xx) xx$p.value)
  arch <- arch.test(x)[[2]]$p.value
  ser <- serial.test(x)[[2]]$p.value
  return(c(norm,"arch"=arch,"serial"=ser))
}
#var1ld: serial.Chi-squared 0.00056

vars.test(var1ld)
vars.test(var1l)

par(mgp=c(2,0.7,0), mar=c(3,3,3,1))

plot(var1ld)
summary(var1l)
## Note that the roots (At top of summary) have the smae modulus.
## Here comes the actual roots:
roots(var1l,modulus=FALSE)
## [1] 0.7347993+0.3131011i 0.7347993-0.3131011i
## They are complex conjugated. So a VAR(1) model can produce oscilations 
## which is not the case for an AR(1) - An AR(2) is required and it can be written
## as a VAR(1) :-)
ldata<-HcTa
VARselect(ldata, type="const", lag.max = 6) 
VARselect(ldata, type="trend", lag.max = 6) 
VARselect(ldata, type="both", lag.max = 6) 
VARselect(ldata, type="none", lag.max = 100) 

var1b <- VAR(ldata, p=3, type="none") 
summary(var1b)
plot(var1b)

f<-predict(var1b,h=6)



str(f)
#prediction 
p<-forecast(var1b,h=6,level=95)

predm<-p$mean$Hct
prel<-p$lower$Hct
preu<-p$ upper$ Hct

plot(forecast(var1b,6))
ts.plot(hct)
#1582:1587

plot(hct[8700:8800], type="n", xlab="Time", ylab="heat consumption", main="Forecast") 
lines(hct[8700:8782])
points(83:94,prem,type="o",col=2)
lines(83:94,preu,type="l",lty=2,col=3)
lines(83:94,prel,type="l",lty=2,col=3)
legend("bottomleft", c("Observations", "Predictions", "Prediction bounds"), cex=0.5, col=c("black","red","green"), pch=c(16,16,-1), lty=c(0,0,1)) 
x<-Hct
s<-auto.arima(x, stepwise=FALSE,approx=FALSE, xreg=Tat)

plot(finalplot, type="l", xlab="Time", ylab="heat consumption", main="Forecast",xlim=) 
points(25:30,prem[1:6],type="o",col=2)
lines(25:30,preu[1:6],type="l",lty=2,col=3)
lines(25:30,prel[1:6],type="l",lty=2,col=3)
legend("bottomleft", c("Observations", "Predictions", "Prediction bounds"), cex=0.5, col=c("black","red","green"), pch=c(16,16,-1), lty=c(0,0,1)) 

