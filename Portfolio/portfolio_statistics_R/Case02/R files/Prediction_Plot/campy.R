climate<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/climate.txt",header=T,sep ="\t")
campy<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/case2regionsOnePerBatch.txt",header=T,sep ="\t")
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
c3<-c2[!is.na(c2$sunHours),]
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

# lm1.opt <- lm(y ~ x + pwl(x,x0.opt))
# summary(lm1.opt)
## Adding prediction interval for optimal break point
# matlines(xp,predict(lm1.opt,newdata=data.frame(x=xp),int="p"),col=3,lwd=3,lty=c(1,2,2))

par(mfrow=c(2,3))
Gam_model<-gam(result~s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=c3)
plot(Gam_model)

Gam_model_1<-gam(result~(s(aveTemp) + s(pwl(aveTemp,11.25))+s(maxTemp)+s(relHum)+s(sunHours)+s(precip)),data=c3)
plot(Gam_model_1)      

Gam_model_2<-gam(result~(s(aveTemp)+ s(pwl(aveTemp,11.25))+s(maxTemp)+s(relHum)+ s(sunHours) +s(pwl(sunHours,41))+s(precip)),data=c3)
plot(Gam_model_2)    

Gam_model_3<-gam(result~(s(aveTemp) +s(pwl(aveTemp,11.25))+s(I(maxTemp^3))+s(relHum)+ s(sunHours) +s(pwl(sunHours,41))+s(precip)),data=c3)
plot(Gam_model_3) 

lm3 <- lm(result~(aveTemp + pwl(aveTemp,11.25)+(I(maxTemp^3))+relHum+ sunHours+ pwl(sunHours,41)+precip),data=c3)
par(mfrow=c(2,2))
plot(lm3)
sqrt(c3$result)
##reduce the model####
lm4<-step(lm3)
drop1(lm4,test="F")
drop1(lm5<-update(lm4,~.-precip),test="F")
plot(lm5)
summary(lm5)
summary(c3)

##prediction####
pred.data<-data.frame(aveTemp=seq(-4,21,length=50),maxTemp=seq(1,30,length=50),relHum=seq(48,98,length=50),sunHours=seq(0,103,length=50))
head(pred.int)
quantile(pred.int[,1])

par(mfrow=c(2,2))
plot(result ~ aveTemp,c3, ylim=range(c3$result, pred.int, na.rm=T))
pred.int<-predict(lm(result ~ aveTemp,c3),newdata=pred.data,int="prediction") 
matlines(pred.data$aveTemp, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ aveTemp,c3), int="confidence", newdata=pred.data)
matlines(pred.data$aveTemp, conf.int, lty=c(1,2,2), col="red")

plot(result ~ maxTemp ,c3, ylim=range(c3$result, pred.int, na.rm=T))
pred.int<-predict(lm(result ~ maxTemp,c3) ,newdata=pred.data,int="prediction") 
matlines(pred.data$maxTemp, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ maxTemp,c3), int="confidence", newdata=pred.data)
matlines(pred.data$maxTemp, conf.int, lty=c(1,2,2), col="red")

plot(result ~ relHum ,c3, ylim=range(c3$result, pred.int, na.rm=T))
pred.int<-predict(lm(result ~ relHum,c3) ,newdata=pred.data,int="prediction") 
matlines(pred.data$relHum, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ relHum,c3), int="confidence", newdata=pred.data)
matlines(pred.data$relHum, conf.int, lty=c(1,2,2), col="red")

plot(result ~ sunHours ,c3, ylim=range(c3$result, pred.int, na.rm=T))
pred.int<-predict(lm(result ~ sunHours,c3) ,newdata=pred.data,int="prediction") 
matlines(pred.data$sunHours, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(lm(result ~ sunHours,c3), int="confidence", newdata=pred.data)
matlines(pred.data$sunHours, conf.int, lty=c(1,2,2), col="red")


library(tree)
model<-tree(result~.,data=c3)
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
