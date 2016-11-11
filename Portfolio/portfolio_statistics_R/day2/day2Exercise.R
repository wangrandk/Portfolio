plot(c(2,5),c(16,10),type="n", ylim=c(0,20),xlim=c(0,6))
points(c(2,5),c(16,10),pch=16)
lines(c(2,2),c(16,10))
lines(c(2,5),c(10,10))

##sport####
sp<-read.table("sport.txt",header=TRUE,skip=0)
summary(sp)
sp

#1
pairs(sp)
pairs(sp,panel=panel.smooth) #plot(sp,panel=panel.smooth)
plot(high.jump~year,sp,main="high.jump")
lm1<-lm(high.jump~year,sp)
summary(lm1)
par(mfrow=c(2,2))
plot(lm1,main="high.jump") #standerized res= resid/sd

plot(long.jump~year,sp,main="long.jump")
lm2<-lm(long.jump~year,sp)
summary(lm2)
par(mfrow=c(2,2))
plot(lm2,main="long.jump")

plot(Discus.Throw~year,sp,main="Discus.Throw")
lm3<-lm(Discus.Throw~year,sp)
summary(lm3)
par(mfrow=c(2,2))
plot(lm3,main="Discus.Throw")

#2. ##High Jump####             lower     upper
#   original: 16   88.2500                          68
#   pre:      16   86.54283    82.28511  90.80054   68
pred.data <- data.frame(year=seq(0,max(sp$year),length=20))
pred.int<-predict(lm1,int="prediction",newdata=data.frame(year=68))
pred.int<-predict(lm1,int="prediction",newdata=pred.data)
plot(high.jump~year,sp, ylim=range(sp$high.jump, pred.int, na.rm=T))
pred.x <- pred.data$year
matlines(pred.x, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm1, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red")

#2. ##Long Jump####     lower    upper
#original: 16 350.5000
#     pre: 16 351.3392 323.5179 379.1604
pred.data <- data.frame(year=seq(0,max(sp$year),length=20))
pred.int<-predict(lm2,int="prediction",newdata=data.frame(year=68))
pred.int<-predict(lm2,int="prediction",newdata=pred.data)
plot(long.jump~year,sp, ylim=range(sp$long.jump, pred.int, na.rm=T))
pred.x <- pred.data$year
matlines(pred.x, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm2, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red")

#2. ##Discus.Throw####     lower      upper
#original: 16 2550.500
#     pre: 16 2461.04      2281.204  2640.877
pred.data <- data.frame(year=68)
pred.int<-predict(lm3,int="prediction",newdata=data.frame(year=68))
pred.int<-predict(lm3,int="prediction",newdata=pred.data)
plot(Discus.Throw~year,sp, ylim=range(sp$Discus.Throw, pred.int, na.rm=T))
pred.x <- pred.data$year
matlines(pred.x, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm3, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red")

#3  ##Long Jump####       fit      lwr      upr
                  #     351.3392 323.5179 379.1604
#pred.data <- data.frame(year=seq(0,max(sp$year),length=25))
pred.int<-predict(lm2,int="prediction",newdata=data.frame(year=104))
plot(long.jump~year,sp, ylim=range(sp$long.jump, pred.int, na.rm=T))
pred.x <- pred.data$year
matlines(pred.x, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm2, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red")




##Case: Brain####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day2")
bw<-read.table("brainweight.txt",header=TRUE)
summary(bw)
bw
#1 
pairs(bw)
pairs(bw,panel=panel.smooth)
cor.test(body,brain) # high correlation:0.9341638

plot(brain~body,bw)

#2 log transform
plot(log(brain)~log(body),bw)
pairs(log(bw))
pairs(log(bw),panel=panel.smooth)
cor.test(log(body),log(brain)) # higher correlation:0.9595748

#3 model fitting
lm1<-lm(body~brain,data=bw)

lm1<-lm(log(body)~log(brain),data=bw)
lm2<-lm(log(brain)~log(body),data=bw)
summary(lm1)
summary(lm2)
par(mfrow=c(2,2))
plot(lm1)
plot(lm2)

#4 outlier? no

#5 evaluate the fit




##Case: Process####
process<-read.table("process.txt",header=TRUE)
summary(process)
process

#1
pairs(process)
pairs(process,panel=panel.smooth)

#2 airflow and waterfemp influence most becasue of outlier and significant coefficients
lm1<-lm(loss~airflow,process)
summary(lm1)
par(mfrow=c(2,2))
plot(lm1)

lm2<-lm(loss~watertemp,process)
summary(lm2)
par(mfrow=c(2,2))
plot(lm2)

lm3<-lm(loss~acidconc,process)
summary(lm3)
par(mfrow=c(2,2))
plot(lm3)

#3 multiple linear regression
lm1<-lm(loss~.,process)
summary(lm1)

lm2<-update(lm1,~.-acidconc)
summary(lm2)

# same as above by using 'step'
lm2<-step(lm1) # select a fomula-based model by AIC
summary(lm2,cor=T)
plot(lm2)

# drop outlier 21
lm3<-lm(loss~.,process[-21,])
summary(lm3)
plot(lm3)

lm4<-update(lm3,~.-acidconc)
summary(lm4)
plot(lm4)
#4 
cor(process)

# Correlation of Coefficients:
#          (Intercept) airflow
# airflow   -0.31              
# watertemp -0.34       -0.78 

#5 acidconc should be excluded, it is not significant
plot(process$watertemp,lm4$residuals)


##Case: Cheese####
cheese<-read.table("cheese.txt",header=TRUE)
summary(cheese)
cheese

#1 scatterplots
pairs(cheese)
pairs(cheese,panel=panel.smooth)

#1 correlation
library(polycor)
hetcor(cheese) # taste vs H2S has highest cor0.76
cor(cheese)
#1 simple regression

lm1<-lm(taste~Acetic,cheese)
summary(lm1)
plot(lm1)

lm2<-lm(taste~H2S,cheese)
summary(lm2)
plot(lm2)

lm3<-lm(taste~Lactic,cheese)
summary(lm3)
plot(lm3)

#2 they are transformed in order to make a better fit and fulfill the assumptions in linear regression

#3 it makes a multiple regression model
# intercept and Acetic are not significant
mlm<-lm(taste~Lactic+H2S+Acetic,cheese)
mlm<-lm(taste~Lactic+H2S,cheese)
summary(mlm)

#4What model would you prefer for prediction? multiple reg, 
mlm<-lm(taste~Lactic+H2S,cheese)
par(mfrow=c(2,2))
plot(mlm)



#5 Predict the 'taste' of a cheese where (log) acetic is 5.3, (log) h2s is 8.0 and lactic is 3.0
pred.int<-predict(mlm,int="prediction",newdata=data.frame(Acetic=5.3,H2S=8,Lactic=3))
plot(taste~Lactic+H2S+Acetic,cheese, ylim=range(cheese$taste, pred.int, na.rm=T))
summary(cheese)
dim(cheese)



