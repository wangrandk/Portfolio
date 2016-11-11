rm(list=ls())
prostate <- read.table("prostatedata.txt", header = TRUE,
                       sep = ";", dec = ",")
head(prostate)
summary(prostate)
dim(prostate)

#a. kcavol seems having high correlation with lpsa.
cor(prostate)
library(GGally)
ggpairs(prostate[2:10])

for (i in 2:10){ 
  par(mfrow=c(3,3))
  qqnorm(prostate[,i],main=names(prostate)[i]) 

  par(mfrow=c(3,3))
  hist(prostate[,i],col=i,main =names(prostate)[i])
}

prostate1<-prostate[,-c(1,11)]
dim(prostate1)
summary(prostate1)
par(mfrow=c(1,1))
boxplot(prostate1)
lm1 <- lm(lpsa ~ ., data = prostate1)
summary(lm14)
par(mfrow=c(2,3))
plot(lm1,1:6)
lm12<-step(lm1) 
drop1(lm12,test="F")
drop1(lm13<-update(lm12,~.-age),test="F")
drop1(lm14<-update(lm13,~.-lbph),test="F")
#drop1(lm15<-update(lm14,~.-svi),test="F")
logLik(lm14)
2*5-2*logLik(lm14) #2* totol no. of varables - 2*loglik(model)
AIC(lm14)
# > AIC(lm14)
# [1] 213.9851
# Residual standard error: 0.7072
# > AIC(lm15)
# [1] 214.8515
# Residual standard error: 0.7139 
summary(lm14)
par(mfrow=c(2,2))
plot(lm14)
# Cook's distance identifies cases that are influential or have a large effect on the regression solution and may be distorting the solution for the remaining cases in the analysis.Generally these are points that are distant from other points in the data  
#R-squared = Explained variation / Total variation.
#R-squared does not indicate whether a regression model is adequate.
#residual standard error = variance/n = sigma^2/n
#d. lcavol is most significant that matches the answer in a.

#f.(1) residual check
par(mfrow = c(3, 3))
for (i in 1:8) {
  plot(lm14$residuals ~ prostate1[,i], type = "n", xlab = names(prostate1)[i])
  text(prostate1[,i], lm14$residuals, labels = row.names(prostate1))
  lines(lowess(prostate1[,i], lm14$residuals), col = "blue")
}

library(reshape2)
library(ggplot2)
prostate1$residuals<-resid(lm14)
prostate2 <- melt(prostate1, measure.vars=c(1:4,6,8))
p <- ggplot(prostate2, aes(value, residuals))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method = lm) #loess
p <- p + facet_wrap(~ variable, scales="free")
print(p)

prostate1$residuals<-resid(lm14)
prostate2 <- melt(prostate1, measure.vars=c(1:4,6,8))
p <- ggplot(prostate2, aes(value, residuals))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method = loess) #loess
p <- p + facet_wrap(~ variable, scales="free")
print(p)


summary(prostate3)
# prostate3$age<-sqrt(prostate3$age)
# prostate3$pgg45<-sqrt(prostate3$pgg45)
lm2 <- lm(lpsa ~ .^2, data = prostate1)
summary(lm2)
par(mfrow=c(2,3))
plot(lm2,1:6)
#Residual standard error: 0.6968
#f.(2) influential obs 30,55,37
#prostate3<-prostate1[-30,]
boxplot(prostate3[1:9])
#lm2 <- lm(lpsa ~ .^2, data = prostate3)
summary(lm3)
lm3<-step(lm2)
drop1(lm3,test="F")
# drop1(lm4<-update(lm3,~.-1),test="F")
# drop1(lm4<-update(lm3,~.-lcavol:gleason),test="F")
# drop1(lm5<-update(lm4,~.-lweight:svi),test="F")
# drop1(lm6<-update(lm5,~.-lcavol:pgg45),test="F")
# drop1(lm7<-update(lm6,~.-age:gleason),test="F")

drop1(lm4<-update(lm3,~.-lcavol:pgg45),test="F")
drop1(lm4<-update(lm3,~.-lcp:pgg45),test="F")
drop1(lm5<-update(lm4,~.-lcavol:pgg45),test="F")
# drop1(lm6<-update(lm5,~.-lcavol:pgg45),test="F")
# drop1(lm7<-update(lm6,~.-age:gleason),test="F")
#drop1(lm8<-update(lm7,~.-age:lcp),test="F")
summary(lm5)
par(mfrow=c(2,2))
plot(lm5)
AIC(lm5)
# AIC(lm7)
# [1] 192.473
# Residual standard error: 0.6051 better!!!
# > AIC(lm8)
# [1] 194.2455
# Residual standard error: 0.6133
#confident interval
library(reshape2)
library(ggplot2)
prostate1$residuals<-resid(lm5)
prostate2 <- melt(prostate1, measure.vars=c(1:4,6,8))
p <- ggplot(prostate2, aes(value, residuals))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method = lm) #loess
p <- p + facet_wrap(~ variable, scales="free")
print(p)

prostate1$residuals<-resid(lm5)
prostate2 <- melt(prostate1, measure.vars=c(1:4,6,8))
p <- ggplot(prostate2, aes(value, residuals))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method = loess) #loess
p <- p + facet_wrap(~ variable, scales="free")
print(p)

library(gplots)
filled.contour(prostate1, main="Protein-Protein Interaction Potential")






