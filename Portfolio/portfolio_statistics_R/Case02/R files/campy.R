climate<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/climate.txt",header=T,sep ="\t")
campy<-read.table("C:/Users/Kasper/Dropbox/Applied Statistics/Case2/case2regionsOnePerBatch.txt",header=T,sep ="\t")
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

##smoothing variables####
library(mgcv)
pwl<-function(x,x0){
  return( (x > x0) * (x-x0) )
}

optim<-optimize(function(zz){
  sum( residuals(lm(y ~ x + pwl(x,zz)))^2 )
},c(3,8))

(x0.opt<-optim$minimum)

par(mfrow=c(3,3))
Gam_model<-gam(result~s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=c3,optimizer="outer",gamma=1)
plot(Gam_model)

Gam_model<-gam(result~s(I(aveTemp^2))+s(I(maxTemp^2))+s(relHum)+s(I(sunHours^2))+s(precip),data=c3,optimizer="outer")
plot(Gam_model)
(Gam_model)
plot(Gam_model,pages=1,residuals=TRUE,) 
plot(Gam_model,pages=1,seWithMean=TRUE) 
gam.check(Gam_model)


lm3 <- lm(sqrt(result) ~ (aveTemp + maxTemp + relHum + sunHours+ precip)^2+ I(aveTemp^2) + I(maxTemp^2) + I(sunHours^2),data=c3)
par(mfrow=c(2,2))
plot(lm3)
sqrt(c3$result)
##reduce the model####
lm4<-step(lm3)
drop1(lm4,test="F")
drop1(lm5<-update(lm4,~.-aveTemp:maxTemp),test="F")
# drop1(lm5<-update(lm4,~.-maxTemp - aveTemp:relHum),test="F")
# drop1(lm5<-update(lm4,~.-maxTemp - aveTemp:relHum -aveTemp ),test="F")
anova(lm3,lm5)
plot(lm5)
summary(lm5)
summary(c3)
summary(lm3)

pred.data<-data.frame(aveTemp=seq(-4,21,length=50),maxTemp=seq(1,30,length=50),relHum=seq(48,98,length=50),sunHours=seq(0,103,length=50))

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
par(mfrow=c(2,3))
#pred.data<-data.frame(maxTemp=mean(c3$maxTemp),aveTemp=seq(-4,21,length=50))
pred.int<-predict(lm5, int="p",newdata=pred.data)
pred.int<-(pred.int)^2
plot(result ~ aveTemp,c3, ylim=range(c3$result, pred.int, na.rm=T),main="aveTemp")
matlines(pred.data$aveTemp,pred.int,lty=c(1,2,2),col=1,lwd=2)
conf.int<-predict(lm5, int="c",newdata=pred.data)
conf.int<-(conf.int)^2
matlines(pred.data$aveTemp,conf.int,lty=c(1,2,2),col=2,lwd=2)
legend("topleft",legend=c("95% Pred.int","95% conf.int."),lty=c(2,2),col=c(1:2),lwd=1)

pred.data <- lec.fun(c3,reference="maxTemp",others=c("aveTemp","relHum","sunHours","precip","I(aveTemp^2)"),ref.values=1:30)
pred.int<-predict(lm5, int="p",newdata=pred.data)
pred.int<-(pred.int)^2
plot(result ~ maxTemp,c3, ylim=range(c3$result, pred.int, na.rm=T),main="maxTemp")
matlines(pred.data$maxTemp,pred.int,lty=c(1,2,2),col=1,lwd=2)
conf.int<-predict(lm5, int="c",newdata=pred.data)
conf.int<-(conf.int)^2
matlines(pred.data$maxTemp,conf.int,lty=c(1,2,2),col=2,lwd=2)
legend("topleft",legend=c("95% Pred.int","95% conf.int."),lty=c(2,2),col=c(1:2),lwd=1)

pred.data <- lec.fun(c3,reference="relHum",others=c("aveTemp","maxTemp","sunHours","precip","I(aveTemp^2)"),ref.values=48:98)
pred.int<-predict(lm5, int="p",newdata=pred.data)
pred.int<-(pred.int)^2
plot(result ~ relHum,c3, ylim=range(c3$result, pred.int, na.rm=T),main="relHum")
matlines(pred.data$relHum,pred.int,lty=c(1,2,2),col=1,lwd=2)
conf.int<-predict(lm5, int="c",newdata=pred.data)
conf.int<-(conf.int)^2
matlines(pred.data$relHum,conf.int,lty=c(1,2,2),col=2,lwd=2)
legend("topleft",legend=c("95% Pred.int","95% conf.int."),lty=c(2,2),col=c(1:2),lwd=1)

pred.data <- lec.fun(c3,reference="sunHours",others=c("aveTemp","maxTemp","relHum","precip","I(aveTemp^2)"),ref.values=0:103)
pred.int<-predict(lm5, int="p",newdata=pred.data)
pred.int<-(pred.int)^2
plot(result ~ sunHours,c3, ylim=range(c3$result, pred.int, na.rm=T),main="sunHours")
matlines(pred.data$sunHours,pred.int,lty=c(1,2,2),col=1,lwd=2)
conf.int<-predict(lm5, int="c",newdata=pred.data)
conf.int<-(conf.int)^2
matlines(pred.data$sunHours,conf.int,lty=c(1,2,2),col=2,lwd=2)
legend("topleft",legend=c("95% Pred.int","95% conf.int."),lty=c(2,2),col=c(1:2),lwd=1)

pred.data <- lec.fun(c3,reference="precip",others=c("aveTemp","maxTemp","relHum","sunHours","I(aveTemp^2)"),ref.values=0:75)
pred.int<-predict(lm5, int="p",newdata=pred.data)
pred.int<-(pred.int)^2
plot(result ~ precip,c3, ylim=range(c3$result, pred.int, na.rm=T),main="precip")
matlines(pred.data$precip,pred.int,lty=c(1,2,2),col=1,lwd=2)
conf.int<-predict(lm5, int="c",newdata=pred.data)
conf.int<-(conf.int)^2
matlines(pred.data$precip,conf.int,lty=c(1,2,2),col=2,lwd=2)
legend("topleft",legend=c("95% Pred.int","95% conf.int."),lty=c(2,2),col=c(1:2),lwd=1)



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

