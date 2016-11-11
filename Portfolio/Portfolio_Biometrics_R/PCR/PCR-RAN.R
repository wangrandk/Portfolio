rm(list=ls())
prostate <- read.table("prostatedata.txt", header = TRUE,sep = ";", dec = ",")
head(prostate)
#prostate1<-prostate[,-c(1)]

prostate$X<-as.matrix(prostate[,2:9])
prostate_TEST <- prostate[prostate$train == FALSE,]
prostate_TRAIN <- prostate[prostate$train == TRUE,]
View(prostate$X)
summary(prostate_TEST)
str(prostate)
# model selection
# validation
# interpretation
# etc.

##Run the PCR with maximal/large number of components using pls package:####
library(pls)
m1<-pcr(lpsa~X,ncomp=8,data=prostate_TRAIN,validation="LOO",scale=T,jackknife=T)
par(mfrow=c(2,2))
plot(m1,labels = rownames(prostate_TRAIN),which="validation")
plot(m1,"validation",estimate=c("train","CV"),val.type ="MSEP",legendpos="topright")
plot(m1,"validation",estimate=c("train","CV"),val.type ="R2",legendpos="bottomright")
pls::scoreplot(m1, labels = rownames(prostate_TRAIN))
pls::loadingplot(m1,comps=8,scatter=T,labels = names(prostate_TRAIN))
## Choice of components:####

# what would segmented CV give:
segCV <- pcr(lpsa~X , ncomp = 8, data = prostate_TRAIN, scale = TRUE,validation = "CV", segments = 6, segment.type = "consecutive",jackknife = TRUE)
summary(segCV)
# Initial set of plots:
par(mfrow=c(1,1))
plot(segCV, "validation", estimate = c("train", "CV"), legendpos = "topright")
plot(segCV, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")
#score plot:
pls::scoreplot(segCV, comps = 1:3, labels = rownames(prostate_TRAIN))
#Loadings:
pls::loadingplot(segCV,comps = 1:3, scatter = T, labels = names(prostate_TRAIN))

# We choose 3 components leave one out,
m2 <- pcr(lpsa~X , ncomp = 8, data = prostate_TRAIN, validation = "LOO",scale = TRUE, jackknife = TRUE)
summary(m2)
##validate using 3 component. predicted vs. residuals from the predplot function Hence these are the (CV) VALIDATED versions####
par(mfrow = c(2, 2))
k=8
fit <- predplot(m2, labels = rownames(prostate_TRAIN), which = "validation")
Residuals <- fit[,1] - fit[,2]
plot(fit[,2], Residuals, type="n", main = k, xlab = "Fitted", ylab = "Residuals")
text(fit[,2], Residuals, labels = rownames(prostate_TRAIN))

qqnorm(Residuals)
plot(m2)
# To plot residuals against X-leverage, we need to find the X-leverage:
# AND then find the leverage-values as diagonals of the Hat-matrix:
# Based on fitted X-values:
Xf <- scores(m2)
H <- Xf %*% solve(t(Xf) %*% Xf) %*% t(Xf)
leverage <- diag(H)

plot(leverage, abs(Residuals), type = "n", main = k)
text(leverage, abs(Residuals), labels = rownames(prostate_TRAIN))

#plot the residuals versus each input X:
par(mfrow=c(3,3))
for ( i in 2:9){
  plot(Residuals~prostate_TRAIN[,i],type="n",xlab=names(prostate_TRAIN)[i])
  text(prostate_TRAIN[,i],Residuals,labels=row.names(prostate_TRAIN))
  lines(lowess(prostate_TRAIN[,i],Residuals),col="blue")
}
dim(Residuals)

# "interpret/conclude"
par(mfrow = c(2, 2))

# Plot coefficients with uncertainty from Jacknife:
fit <- predplot(m2, labels = rownames(prostate_TRAIN), which = "validation")
abline(lm(fit[,2] ~ fit[,1]))
plot(m2, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")

coefplot(m2, se.whiskers = TRUE, labels = prednames(m2), cex.axis = 1.5)
biplot(m2,var.axes = TRUE)

jack.test(m2, ncomp = 3)

# predict the TEST set:
preds <- predict(m2, newdata = prostate_TEST, comps = 8)
plot(prostate_TEST$lpsa, preds)
abline(lm(preds~ prostate_TEST$lpsa))
summary(prostate_TEST$lpsa)
