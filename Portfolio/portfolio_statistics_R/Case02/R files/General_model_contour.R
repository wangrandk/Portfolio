#clear work space
rm(list = ls(all = TRUE))
# climate<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/climate.txt",header=T,sep ="\t")
# campy<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/case2regionsOnePerBatch.txt",header=T,sep ="\t")
####################
climate<-read.table("climate.txt",header=T,sep ="\t")
campy<-read.table("case2regionsOnePerBatch.txt",header=T,sep ="\t")

View(campy)
summary(campy)
c<-campy[,1:9]
#View(c)
pairs(c)
#plot.ts(climate)
#ts.plot(campy$relHum)
#lines(campy$maxTemp,type='l')
summary(c)
c$result<-signif(c$pos/c$total,digits=3)
#reduce maxTemp
#c<-c[,-4]
#reduce total and pos 
c$total<-NULL
c$pos<-NULL
#reduce Hum
c1<-c[-c(274,275),]
c2<-c1[!is.na(c1$relHum),]
c3<-c2[!is.na(c2$sunHours)&c2$sunHours!=0,]
summary(c3)
View(c3)

# ##smoothing variables####
# #install.packages("mgcv")
# library(mgcv)
# pwl<-function(x,x0){
#   return( (x > x0) * (x-x0) )
# }
# 
# optim<-optimize(function(zz){
#   sum( residuals(lm(y ~ x + pwl(x,zz)))^2 )
# },c(3,8))
# 
# (x0.opt<-optim$minimum)

par(mfrow=c(3,3))
Gam_model<-gam(result~s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=c3,optimizer="outer",gamma=1)
plot(Gam_model)

Gam_model<-gam(result~s(I(aveTemp^2))+s(I(maxTemp^2))+s(relHum)+s(I(sunHours^2))+s(precip),data=c3,optimizer="outer")
plot(Gam_model)
(Gam_model)
plot(Gam_model,pages=1,residuals=TRUE,) 
plot(Gam_model,pages=1,seWithMean=TRUE) 
gam.check(Gam_model)

# Gam_model_1<-gam(result~(s(aveTemp) + s(pwl(aveTemp,11.25))+s(maxTemp)+s(relHum)+s(sunHours)+s(precip)),data=c3)
# plot(Gam_model_1)      
# 
# Gam_model_2<-gam(result~(s(aveTemp)+ s(pwl(aveTemp,11.25))+s(maxTemp)+s(relHum)+ s(sunHours) +s(pwl(sunHours,33.7))+s(precip)),data=c3)
# plot(Gam_model_2)    
# 
# Gam_model_3<-gam(result~(s(aveTemp) +s(pwl(aveTemp,11.25))+s(I(maxTemp^3))+s(relHum)+ s(sunHours) +s(pwl(sunHours,33.7))+s(precip)),data=c3)
# plot(Gam_model_3) 

# lm3 <- lm(result~(aveTemp + pwl(aveTemp,11.25)+(I(maxTemp^3))+relHum+ sunHours+ pwl(sunHours,33.7)+precip),data=c3)

lm3 <- lm(sqrt(result) ~ (aveTemp + maxTemp + relHum + sunHours+ precip)^2+ I(aveTemp^2) + I(maxTemp^2) + I(sunHours^2),data=c3)
par(mfrow=c(2,2))
plot(lm3)
sqrt(c3$result)
#OUTPUT AS TABLE!!!!
summary(lm3)
##reduce the model####
lm4<-step(lm3)
drop1(lm4,test="F")
drop1(lm5<-update(lm4,~.-aveTemp:maxTemp),test="F")
# drop1(lm5<-update(lm4,~.-maxTemp - aveTemp:relHum),test="F")
# drop1(lm5<-update(lm4,~.-maxTemp - aveTemp:relHum -aveTemp ),test="F")

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

## To avoid this we insert NAs where fitted values should be ignored:
pred$fit <- predict(lm5,newdata = pred)^2
# ## As a first assumption: maxTemp should be within 0 to 10 degress higher than a given aveTemp
# pred$fit[ pred$maxTemp < pred$aveTemp] <- NA
# pred$fit[ pred$maxTemp > pred$aveTemp + 10 ] <- NA

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

## To avoid this we insert NAs where fitted values should be ignored:
pred$fit <- predict(lm5,newdata = pred)^2

#plot just where the model makes sense physically
pred$fit[ pred$relHum <0] <- NA
pred$fit[ pred$relHum >100] <- NA
pred$fit[ pred$percip <0] <- NA
pred$fit[ pred$sunHours < 0] <- NA
pred$fit[ pred$fit < 0] <- NA
pred$fit[ pred$fit > 1 ] <- NA

z2 <- matrix(pred$fit, nrow=length(aveT))
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






#########
#############   sunHours:precip  2.220e-04  5.076e-05   4.374 1.54e-05 ***


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






#####################
#####################
#####################







#######################
##### end of 3d plot ##
#######################
















pred.data<-data.frame(aveTemp=seq(-4,21,length=50),maxTemp=seq(1,30,length=50),relHum=seq(48,98,length=50),sunHours=seq(0,103,length=50))
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

##chi-square####
table(vit)
chisq.test(table(vit))
chisq.test(vit$status,vit$treatment)
par(mfrow=c(1,1))
mosaicplot(table(vit))
mosaicplot(table(vit),shade=TRUE)

