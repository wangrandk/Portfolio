
################################################################
#####linear model with pred.int, conf.int, interaction plot ####
################################################################

climate<-read.table("climate.txt",header=T,sep ="\t")
campy<-read.table("case2regionsOnePerBatch.txt",header=T,sep ="\t")

View(campy)
summary(campy)
##clean the data####
c<-campy[,1:9]
c$result<-signif(c$pos/c$total,digits=3)
c$total<-NULL
c$pos<-NULL
c1<-c[-c(274,275),]
c2<-c1[!is.na(c1$relHum),]
c3<-c2[!is.na(c2$sunHours)&c2$sunHours!=0,]
summary(c3)
View(c3)
##use gam to cast a hint about how to transform the data####
par(mfrow=c(3,3))
Gam_model<-gam(result~s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=c3,optimizer="outer",gamma=1)
plot(Gam_model)

Gam_model<-gam(result~s(I(aveTemp^2))+s(I(maxTemp^2))+s(relHum)+s(I(sunHours^2))+s(precip),data=c3,optimizer="outer")
plot(Gam_model)
(Gam_model)
plot(Gam_model,pages=1,residuals=TRUE,) 
plot(Gam_model,pages=1,seWithMean=TRUE) 
gam.check(Gam_model)

##make a linear model with the advantages gain from  'gam'####
lm3 <- lm(sqrt(result) ~ (aveTemp + maxTemp + relHum + sunHours+ precip)^2+ I(aveTemp^2) + I(maxTemp^2) + I(sunHours^2),data=c3)
par(mfrow=c(2,2))
plot(lm3)
summary(lm3)
#reduce the model
lm4<-step(lm3)
drop1(lm4,test="F")
drop1(lm5<-update(lm4,~.-aveTemp:maxTemp),test="F")
plot(lm5)
summary(lm5)
summary(c3)summary

##########################################################################
##### 3 d plot ####
###################

#aveTemp VS maxTemp
par(mfrow=c(1,1))
aveT <- -5:21 
maxT <- 0:30
pred <- expand.grid(aveTemp= aveT, maxTemp = maxT)
formula(lm5)
pred$precip <- predict( lm(precip~aveTemp+maxTemp,c3),newdata=pred)
pred$relHum <- predict( lm(relHum~aveTemp+maxTemp,c3),newdata=pred)
pred$sunHours <- predict( lm(sunHours~aveTemp+maxTemp,c3),newdata=pred)
pred$ugernr<-73
head(pred)
summary(pred$relHum)
## To avoid this we insert NAs where fitted values should be ignored:
pred$fit <- predict(lm5,newdata = pred)^2
summary(pred$relHum)
head(pred$fit)
#plot just where the model makes sense physically
pred$fit[ pred$relHum <0] <- NA
pred$fit[ pred$relHum >100] <- NA
pred$fit[ pred$percip <0] <- NA
pred$fit[ pred$sunHours < 0] <- NA
pred$fit[ pred$fit < 0] <- NA
pred$fit[ pred$fit > 1 ] <- NA

z2 <- matrix(pred$fit, nrow=length(aveT))
image(aveT,maxT,z2)

#plot(maxTemp~aveTemp,data= c3,add=TRUE,pch=18,col="blue") # To show the observations
points(maxTemp~aveTemp,data= c3,pch=1,col="goldenrod1") # To show the observations
contour(aveT,maxT,z2,add=TRUE,labcex=1,lwd=2,col="darkred")

title("Interaction between average and maximal temperature")

###########
###########

#aveTemp VS relHum
summary(c3$relHum)
aveT <- -5:21 
relH <- 48:100
pred <- expand.grid(aveTemp= aveT, relHum = relH)
formula(lm5)
length(c3$relHum)
length(c3$aveTemp)
length(c3$precip)

pred$precip <- predict( lm(precip~aveTemp+relHum,c3),newdata=pred)
pred$maxTemp <- predict( lm(maxTemp~aveTemp+relHum,c3),newdata=pred)
pred$sunHours <- predict( lm(sunHours~aveTemp+relHum,c3),newdata=pred)
pred$ugernr<-73
head(pred)
summary(pred)
lm0<-lm(precip~aveTemp+relHum,c3)
## To avoid this we insert NAs where fitted values should be ignored:
pred$fit <- predict(lm5,newdata = pred)^2
summary(pred$fit)
#plot just where the model makes sense physically
pred$fit[ pred$relHum <0] <- NA
pred$fit[ pred$relHum >100] <- NA
pred$fit[ pred$percip <0] <- NA
pred$fit[ pred$sunHours < 0] <- NA
pred$fit[ pred$fit < 0] <- NA
pred$fit[ pred$fit > 1 ] <- NA

z2 <- matrix(pred$fit, nrow=length(aveT))
image(aveT,relH,z2)
image(aveT,relH,z2)

#plot(maxTemp~aveTemp,data= c3,add=TRUE,pch=18,col="blue") # To show the observations
points(relHum~aveTemp,data= c3,pch=1,col="goldenrod1") # To show the observations
contour(aveT,relH,z2,add=TRUE,labcex=1,lwd=2,col="darkred")

title("Interaction between average temperature \n  and relative humidity")

######
######### relHum:precip    4.380e-04  1.185e-04   3.696 0.000248 ***

#precip VS relHum
(c3$precip)
#aveT
prec <- 0:75 
relH <- 48:100
pred <- expand.grid(precip = prec, relHum = relH)
formula(lm5)
length(c3$relHum)
length(c3$aveTemp)
length(c3$precip)

pred$aveTemp <- predict( lm(aveTemp~precip+relHum,c3),newdata=pred)
pred$maxTemp <- predict( lm(maxTemp~precip+relHum,c3),newdata=pred)
pred$sunHours <- predict( lm(sunHours~precip+relHum,c3),newdata=pred)
pred$ugernr<-73
head(pred)

## To avoid this we insert NAs where fitted values should be ignored:
pred$fit <- predict(lm5,newdata = pred)^2

summary(pred$fit)

#plot just where the model makes sense physically
pred$fit[ pred$relHum <0] <- NA
pred$fit[ pred$relHum >100] <- NA
pred$fit[ pred$percip <0] <- NA
pred$fit[ pred$sunHours < 0] <- NA
pred$fit[ pred$fit < 0] <- NA
pred$fit[ pred$fit > 1 ] <- NA

z2 <- matrix(pred$fit, nrow=length(prec))
image(prec,relH,z2)


#plot(maxTemp~aveTemp,data= c3,add=TRUE,pch=18,col="blue") # To show the observations
points(relHum~precip,data= c3,pch=1,col="goldenrod1") # To show the observations
contour(prec,relH,z2,add=TRUE,labcex=1,lwd=2,col="darkred")

title("Interaction between precipitation \n  and relative humidity")

#precip VS sunHours

summary(c3$sunHours)

#relH
prec <- 0:75 
sunH <- 0:105
pred <- expand.grid(precip = prec, sunHours = sunH)
formula(lm5)
length(c3$relHum)
length(c3$aveTemp)
length(c3$precip)

pred$aveTemp <- predict( lm(aveTemp~precip+sunHours,c3),newdata=pred)
pred$maxTemp <- predict( lm(maxTemp~precip+sunHours,c3),newdata=pred)
pred$relHum <- predict( lm(relHum~precip+sunHours,c3),newdata=pred)
pred$ugernr<-73
head(pred)

## To avoid this we insert NAs where fitted values should be ignored:
pred$fit <- predict(lm5,newdata = pred)^2

summary(pred$fit)

#plot just where the model makes sense physically
pred$fit[ pred$relHum <0] <- NA
pred$fit[ pred$relHum >100] <- NA
pred$fit[ pred$percip <0] <- NA
pred$fit[ pred$sunHours < 0] <- NA
pred$fit[ pred$fit < 0] <- NA
pred$fit[ pred$fit > 1 ] <- NA

z2 <- matrix(pred$fit, nrow=length(prec))
image(prec,sunH,z2)


#plot(maxTemp~aveTemp,data= c3,add=TRUE,pch=18,col="blue") # To show the observations
points(sunHours~precip,data= c3,pch=1,col="goldenrod1") # To show the observations
contour(prec,sunH,z2,add=TRUE,labcex=1,lwd=2,col="darkred")


title("Interaction between precipitation \n  and hours of sunshine")

#######################
##### end of 3d plot ##
#######################

head(pred.int)
quantile(pred.int[,1])
pred.int<-predict(lm5,pred.data,int="prediction")
conf.int<-predict(lm5,pred.data,int="confidence")
summary(pred.int)
head(pred.int)
par(mfrow=c(2,2))

lec.fun<-function(data,reference,others=names(data)[names(data)!=reference],ref.values=seq(min(data[[reference]]),max(data[[reference]]),length=30)){
  pdata<-data.frame(reference=ref.values)
  names(pdata)<-reference
  for(i in others){
    lmtmp<-lm(as.formula(paste(i,"~",reference)),data)
    pdata[[i]]<-predict(lmtmp,newdata=pdata[reference])
  }
  return(pdata)
}

pred.data <- lec.fun(c3,reference="aveTemp",others=c("maxTemp","relHum","sunHours","precip","I(aveTemp^2)"),ref.values=-4:21)
pred.data

#pred.data<-data.frame(maxTemp=mean(c3$maxTemp),aveTemp=seq(-4,21,length=50))
pred.int<-predict(lm5, int="p",newdata=pred.data)
pred.int<-(pred.int)^2
plot(result ~ aveTemp,c3, ylim=range(c3$result, pred.int, na.rm=T))
matlines(pred.data$aveTemp,pred.int,lty=c(1,2,2),col=1,lwd=2)
conf.int<-predict(lm5, int="c",newdata=pred.data)
conf.int<-(conf.int)^2
matlines(pred.data$aveTemp,conf.int,lty=c(1,2,2),col=2,lwd=2)

legend("topleft",legend=c("Using means","Using linear models","95% pred.int.","95"),lty=c(1,2,2),col=c(1,1:2),lwd=2)

pred.int<-predict(lm5,newdata=pred.data,int="prediction") 
plot(result ~ aveTemp,c3, ylim=range(c3$result, pred.int, na.rm=T))
conf.int<-predict(lm(result ~ aveTemp^2,c3), int="confidence", newdata=pred.data)
matlines(pred.data$aveTemp^2, pred.int, lty=c(1,2,2), col="black")
matlines(pred.data$aveTemp^2, conf.int, lty=c(1,2,2), col="red")

pred.int<-predict(lm(result ~ maxTemp^2,c3) ,newdata=pred.data,int="prediction") 
plot(result ~ I(maxTemp^2) ,c3, ylim=range(c3$result, pred.int, na.rm=T))
matlines(pred.data$maxTemp^2, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ maxTemp^2,c3), int="confidence", newdata=pred.data)
matlines(pred.data$maxTemp^2, conf.int, lty=c(1,2,2), col="red")

pred.int<-predict(lm(result ~ relHum,c3) ,newdata=pred.data,int="prediction")
plot(result ~ relHum ,c3, ylim=range(c3$result, pred.int, na.rm=T)) 
matlines(pred.data$relHum, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ relHum,c3), int="confidence", newdata=pred.data)
matlines(pred.data$relHum, conf.int, lty=c(1,2,2), col="red")

plot(result ~ I(sunHours^2) ,c3, ylim=range(c3$result, pred.int, na.rm=T))
pred.int<-predict(lm(result ~ sunHours^2,c3) ,newdata=pred.data,int="prediction") 
matlines(pred.data$sunHours^2, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ sunHours^2,c3), int="confidence", newdata=pred.data)
matlines(pred.data$sunHours^2, conf.int, lty=c(1,2,2), col="red")

library(tree)
model<-tree(result~ aveTemp+maxTemp+sunHours+relHum+precip,data=c3)
par(mfrow=c(1,1))
plot(model)
text(model)

###################################
#####linear model with Regions ####
###################################

climate<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/case2regionsOnePerBatch.txt",header=T,sep ="\t")
View(campy)
summary(campy)
View(climate)
names(climate)
X <- climate[,1:7] ## Climatic data seq(0, 10, 2)
totalR <- as.numeric(as.matrix(climate[,seq(10,24,2)])) ## All the totals
View(totalR)
posR <- as.numeric(as.matrix(climate[,seq(11,25,2)])) ## All the positive
# Merging it all together:
dat <- data.frame(X,totalR=totalR,posR=posR,region=factor(paste("R",rep(1:8,each=nrow(X)),sep="")))
summary(dat5)
View(dat5)
str(dat)

#reduce NA and 0
dat1<-dat[-c(274,275),]
summary(dat3)
dat2<-dat1[!is.na(dat1$relHum),]
dat3<-dat2[!is.na(dat2$sunHours),]
dat4<-dat3
dat4$pros<-signif(dat3$posR/dat3$totalR,digits=3)
#dat4<-dat4[,-c(8,9)]
dat5<-dat4[!is.na(dat4$pros),]
pairs(dat5)

library(mgcv)
# factor region
b <- gam(pros~ region + s(year)+s(week)+s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=dat5,method="GCV.Cp")
par(mfrow=c(2,4))
plot(b)
gam.check(b)

##check most sig variable####
library(tree)
model<-tree(pros~.,data=dat5)
par(mfrow=c(1,1))
plot(model)
text(model)
##smoothing aveTemp####
pwl<-function(x,x0){  
  return( (x > x0) * (x-x0) )
}

b1 <- gam(pros~ region + s(year)+s(week)+s(aveTemp)+s(maxTemp)+s(pwl(aveTemp,11.25))+s(relHum)+s(sunHours)+s(precip),data=dat5,method="GCV.Cp")
par(mfrow=c(2,4))
plot(b1)

b2 <- gam(pros~ region + s(year)+s(pwl(week,26.5))+s(week)+s(aveTemp)+s(maxTemp)+s(pwl(aveTemp,11.25))+s(relHum)+s(sunHours)+s(precip),data=dat5)
plot(b2)
plot(b,pages=1,residuals=TRUE) 
plot(b,pages=1,seWithMean=TRUE) 
gam.check(b)

# model with original posR
lm1<-lm(pros~ region *(year+ pwl(week,26.5)+ week+ aveTemp+maxTemp+pwl(aveTemp,11.25)+relHum+sunHours+precip),data=dat5)
lm2<-step(lm1) 
drop1(lm2,test="F")
## This time I'll reuse names for models while reducing:
drop1(lm3<-update(lm2,~.-relHum),test="F")
drop1(lm3<-update(lm2,~.-relHum - region:year),test="F")
par(mfrow=c(2,2))
plot(lm3)
#this model shows pattern in the residual plots, thus it is better to stop here, and try to use other approach.
