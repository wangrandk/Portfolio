#climate<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin02/climate.txt",header=T,sep ="\t")
climate<-read.table("C:/Users/Kasper/Dropbox/Applied Statistics/Case2/case2regionsOnePerBatch.txt",header=T,sep ="\t")
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
dat4<-dat4[,-c(8,9)]
dat5<-dat4[!is.na(dat4$pros),]
pairs(dat5)

library(mgcv)
# factor region
b <- gam(pros~ region + s(year)+s(week)+s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=dat5,method="GCV.Cp")
summary(b)
par(mfrow=c(2,4))
plot(b)
plot(b,pages=1,residuals=TRUE)  ## show partial residuals
plot(b,pages=1,seWithMean=TRUE) ## `with intercept' CIs
## run some basic model checks, including checking
## smoothing basis dimensions...
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

# 3) aveTemp > 11.25 1268 125.10 0.4941*
# 5) year > 2001.5 1068  62.75 0.1750 *
# 6) week < 26.5 419  34.31 0.3169 *
# 7) week > 26.5 849  71.16 0.5816 *

b1 <- gam(pros~ region + s(year)+s(week)+s(aveTemp)+s(maxTemp)+s(pwl(aveTemp,11.25))+s(relHum)+s(sunHours)+s(precip),data=dat5,method="GCV.Cp")
par(mfrow=c(2,4))
plot(b1)

b2 <- gam(pros~ region + s(year)+s(pwl(week,26.5))+s(week)+s(aveTemp)+s(maxTemp)+s(pwl(aveTemp,11.25))+s(relHum)+s(sunHours)+s(precip),data=dat5)
plot(b2)
plot(b,pages=1,residuals=TRUE) 
plot(b,pages=1,seWithMean=TRUE) 
gam.check(b)

# b3 <- gam(pros~ region + s(year)+s(pwl(year,2001.5))+s(pwl(week,26.5))+s(week)+s(aveTemp)+s(maxTemp)+s(pwl(aveTemp,11.25))+s(relHum)+s(sunHours)+s(precip),data=dat5)
# plot(b3)
 


# model with original posR
lm1<-lm(pros~ region *(year+ pwl(week,26.5)+ week+ aveTemp+maxTemp+pwl(aveTemp,11.25)+relHum+sunHours+precip),data=dat5)
lm2<-step(lm1) 
drop1(lm2,test="F")
## This time I'll reuse names for models while reducing:
drop1(lm3<-update(lm2,~.-relHum),test="F")
drop1(lm3<-update(lm2,~.-relHum - region:year),test="F")
par(mfrow=c(2,2))
plot(lm3)



# model with sqrt posR
dat4<-dat3
dat4$posR<-signif(sqrt(dat3$posR),4)
View(dat4)
lm4<-lm(posR~ year *week*	aveTemp*	maxTemp*	relHum*	sunHours*	precip*	totalR,dat4)
lm5<-step(lm4) 
plot(lm5)


campy$result<-signif(campy$pos/campy$total,digits=3)
campy$R1result<-signif(campy$R1pos/campy$R1total,digits=3)
campy$R2result<-signif(campy$R2pos/campy$R2total,digits=3)
campy$R3result<-signif(campy$R3pos/campy$R3total,digits=3)
campy$R4result<-signif(campy$R4pos/campy$R4total,digits=3)
campy$R5result<-signif(campy$R5pos/campy$R5total,digits=3)
campy$R6result<-signif(campy$R6pos/campy$R6total,digits=3)
campy$R7result<-signif(campy$R7pos/campy$R7total,digits=3)
campy$R8result<-signif(campy$R8pos/campy$R8total,digits=3)
View(campy)
summary(campy)
data<-campy[,c("year","week","aveTemp","relHum","sunHours","precip","result","R1result","R2result","R3result","R4result","R5result","R6result","R7result","R8result")]



