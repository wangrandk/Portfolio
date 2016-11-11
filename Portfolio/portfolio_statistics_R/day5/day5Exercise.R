##Case: Forbes####
F<-read.table("forbes.txt",header=T,sep ="\t")
summary(F)

#1. Investigate the relation between Log(Sales) predicted by Log(Assets)
lm1<-lm(log(Sales)~log(Assets),F)
summary(lm1)
anova(lm1)
par(mfrow=c(2,2))
plot(lm1)



#2. Include Sector as a discrete factor in the model - what is your conclusion?
lm2<-drop1(lm(log(Sales)~ log(Assets) + sector,F),test="F")
lm2<-lm(log(Sales)~ log(Assets) + sector,F)
summary(lm2)
par(mfrow=c(2,2))
par(mfrow=c(1,1))
plot(lm2$residuals)
F$lAssets<-log(F$Assets)
F$lSales<-log(F$Sales)
# relation between sloop is same, because there is no significant interaction.
plot(F$lAssets,F$lSales,col=as.numeric(F$sector),pch=19)
co<-coef(lm2)
abline(a=co[1],b=co[2],lwd=2,col=9)
abline(a=co[1]+co[3],b=co[2],lwd=2,col=2)
abline(a=co[1]+co[4],b=co[2],lwd=2,col=3)
abline(a=co[1]+co[5],b=co[2],lwd=2,col=4)
abline(a=co[1]+co[6],b=co[2],lwd=2,col=5)
abline(a=co[1]+co[7],b=co[2],lwd=2,col=6)
abline(a=co[1]+co[8],b=co[2],lwd=2,col=7)
abline(a=co[1]+co[9],b=co[2],lwd=2,col=8)
abline(a=co[1]+co[10],b=co[2],lwd=2,col=9)
legend("topleft", legend = levels(F$sector),lty=1,col=1:9,cex=.8)
pre.data<-







#3. 3. Are other variables significant?
lm3<-drop1(lm(log(Sales)~ log(Assets) + sector + log(Market.Value) + Employees + log(Profits+800) +  log(F$Cash.Flow+700),F),test="F")
lm3
mlm<-lm(NOISE~(.)^3,Filter)










##Case: KFM####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day5")
KFM<-read.table("kfm.txt",header=T)
summary(KFM)

pairs(KFM,panel=panel.smooth)
KFM$sex<-as.factor(KFM$sex)
#1. test predictors of the child's weight
lm1<-lm(weight~.,KFM)
summary.aov(lm1)

lm2<-lm(weight~sex * mat.weight,KFM)
summary(lm2)
summary.aov(lm2)

lm3<-lm(weight~ sex +mat.height+ mat.weight ,KFM)
summary(lm3)
summary.aov(lm3)

lm3<-lm(weight~ dl.milk  ,KFM)
drop1(lm(weight~ .,KFM),test="F")
#lm3<-lm(weight~(.)^3,KFM)
summary(lm3)
summary.aov(lm3)

par(mfrow=c(1,1))
plot(KFM$dl.milk,KFM$weight,pch=19,col=KFM$sex,xlim=c(4,11),ylim=c(4,7))
co<-coef(lm3)
abline(a=co[1],b=co[2],lwd=2)
abline(a=co[1]+co[2],b=co[3],lwd=2,col=2)

# KFM$sex=as.numeric(KFM$sex)
# lm4<-lm(~ dl.milk + ml.suppl + mat.weight + mat.height,KFM)
# summary(lm4)
# summary.aov(lm4)
# 
# lm4<-lm(sex~ dl.milk,KFM)
# summary(lm4)
# summary.aov(lm4)
# investigate whether the effect of dl.milk, ml.suppl, mat.weight and mat.height are different for boys and girls

lm4<-lm(weight~ dl.milk * sex * log(ml.suppl+1) * log(mat.weight) * log(mat.height) ,KFM)
#drop1(lm(weight~ .,KFM),test="F")
summary(lm4)
lms<-step(lm4)
summary(lms)
a<-drop1(lms,test="F")
anova(a)

b<-update(a,~.-sex:log(ml.suppl + 1):log(mat.weight):log(mat.height))
summary(b)

lm2<-update(lm1,~.-NW)
summary(lm2)
  
lm5<-lm(weight~dl.milk* sex,KFM)
summary(lm5)
anova(lm5)

lm6<-lm(weight~ mat.height * sex,KFM)
summary(lm6)
anova(lm6)

lm7<-lm(weight~ mat.weight * sex,KFM)
summary(lm7)
anova(lm7)

lm8<-lm(weight ~ mat.height,KFM[KFM$sex=="girl",])
summary(lm8)
anova(lm8)