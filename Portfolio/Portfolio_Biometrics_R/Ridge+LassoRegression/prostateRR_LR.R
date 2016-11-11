rm(list=ls())
prostate <- read.table("prostatedata.txt", header = TRUE,sep = ";", dec = ",")

prostate$X<-as.matrix(prostate[,2:9])
prostate_TEST <- prostate[prostate$train == FALSE,]
prostate_TRAIN <- prostate[prostate$train == TRUE,]
##RR####
library(parcor, warn.conflicts = FALSE)
par(mfrow=c(1, 1))
# First Full LOO
res_LOO <- ridge.cv(scale(prostate_TRAIN$X), prostate_TRAIN$lpsa, lambda = seq(1, 20, by = 0.5), k = 20, plot.it = TRUE)
res_LOO$lambda.opt  # 3

# Let's do our own "repeated double 10-fold CV":
K=10
lambda.opts <- rep(0, K)
for ( i in 1:K ){
  res_CV10 <- ridge.cv(scale(prostate_TRAIN$X), prostate_TRAIN$lpsa, lambda = seq(1, 30,by = 0.5),k = 10, plot.it = FALSE)
  lambda.opts[i] <- res_CV10$lambda.opt
}
median(lambda.opts) #3.5

# Now let's try the ridgeCV to investigate the choice(s) more carefully:
res <- ridgeCV(prostate_TRAIN$lpsa ~ prostate_TRAIN$X, data =prostate_TRAIN , lambdaopt = 3.5,repl = 20)

# Look at the coefficients:
ridge_lm <- lm.ridge(prostate_TRAIN$lpsa ~ prostate_TRAIN$X, data = prostate_TRAIN, lambda = 3.5)
# Coefficients on raw X-scale:
plot(coef(ridge_lm))
# Coefficients on standardized X-scale:
plot(ridge_lm$coef) #3,7 are close to 0

##RR_prediction####
# First by ridge regression:
ridge_lm <- lm.ridge(lpsa ~ X, data = prostate_TEST, lambda = 3.5)
# Coefficients on raw X-scale: (WITH intercept)
beta_ridge <- coef(ridge_lm)
plot(beta_ridge)
#                 Xlcavol     Xlweight         Xage        Xlbph         Xsvi         Xlcp 
#0.841904333  0.421807055  0.256676658 -0.003255383 -0.080144425  0.580579084  0.182835980 
#Xgleason       Xpgg45 
#0.034533508  0.001009314 
yhat_ridge <- beta_ridge[1] + prostate_TEST$X %*% beta_ridge[-1] #yhat=b0+bX
residuals <- prostate_TEST$lpsa - yhat_ridge
MSEP <- mean(residuals^2)
MSEP #0.3228073
sqrt(MSEP)
dev.copy(png,'Ridge Regression.png')
par(mfrow=c(1,1))
plot(prostate_TEST$lpsa, yhat_ridge,,main='Ridge Regression')
lines(lowess(yhat_ridge,prostate_TEST$lpsa), col="blue")
abline(lm(prostate_TEST$lpsa~yhat_ridge), col="red")
dev.off()
##Lasso####
library(lars)
lasso_result <- lars(prostate_TRAIN$X, prostate_TRAIN$lpsa,type="lasso")
par(mfrow=c(1,1))
plot(lasso_result$lambda,type='l')
plot(lasso_result$R2,type='l')
cv.lars(prostate_TRAIN$X, prostate_TRAIN$lpsa)

library(chemometrics, warn.conflicts = FALSE)
res_lasso <- lassoCV(lpsa ~ X, data = prostate_TRAIN,fraction = seq(0, 1, by = 0.05), K = 10) #k number of segments
res_lasso$sopt #optimal value for fraction
# the Bs are shrank 0.3 as they were before.
res_coef <- lassocoef(lpsa ~ X, data = prostate_TRAIN, sopt = res_lasso$sopt)
#5 coef are 0,3 are not.
$coefficients
#Xlcavol  Xlweight      Xage     Xlbph      Xsvi      Xlcp  Xgleason    Xpgg45 
#0.4424018 0.3485445 0.0000000 0.0000000 0.1793646 0.0000000 0.0000000 0.0000000 

# In an auto-scaled version:
res_lasso_scaled <- lassoCV(lpsa ~ scale(X), data = prostate_TRAIN,fraction = seq(0, 1, by = 0.05), K = 10)
res_lasso_scaled$sopt
res_coef_scaled <- lassocoef(lpsa ~ scale(X), data = prostate_TRAIN,sopt = res_lasso_scaled$sopt)
# The actual coefficients can be looked at by: (on raw X-scale - I believe.:-)...)
res_coef <- res_coef_scaled$coefficients
plot(res_coef)
beta_lasso <- res_coef
#prediction
yhat_lasso <- predict.lars(lasso_result, newx = (prostate_TEST$X), s = 0.3,mode = "fraction")$fit
residuals <- prostate_TEST$lpsa - yhat_lasso
MSEP <- mean(residuals^2)
MSEP
sqrt(MSEP)
qqnorm(residuals)
plot(residuals)
lines(lowess(residuals,prostate_TEST$plsa), col="blue")
dev.copy(png,'Lasso.png')
plot(prostate_TEST$lpsa, yhat_lasso,main='Lasso_5 coef are 0,3 are not')
lines(lowess(yhat_lasso,prostate_TEST$lpsa), col="blue")
abline(lm(prostate_TEST$lpsa~yhat_lasso), col="red")
dev.off()
##MLR####
mlr<-lm(lpsa ~ X, data = prostate_TRAIN)
par(mfrow=c(2,2))
mlr1<-step(mlr)
summary(mlr)
plot(mlr1)
#drop1(mlr,test="F")
logLik(mlr1)
2*4-2*logLik(mlr1) #2* total no. of varables - 2*loglik(model)
AIC(mlr1)
pred_mlr<-predict(mlr1,newdata=prostate_TEST,interval = 'prediction')
summary(pred_mlr)
jpeg('MLR.jpg')
par(mfrow=c(1,1))
plot(pred_mlr[,1],prostate_TEST$lpsa,main='MLR')
lines(lowess(pred_mlr[,1],prostate_TEST$lpsa), col="blue")
dev.off()
##PCR####
library(pls)
# what would segmented CV give:
segCV <- pcr(lpsa~X , ncomp = 8, data = prostate_TRAIN, scale = TRUE,validation = "CV", segments = 6, segment.type = "consecutive",jackknife = TRUE)
summary(segCV)
# Initial set of plots:
par(mfrow=c(1,1))
plot(segCV, "validation", estimate = c("train", "CV"), legendpos = "topright")
plot(segCV, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")
# We choose 8 components leave one out,
m2 <- pcr(lpsa~X , ncomp = 3, data = prostate_TRAIN, validation = "LOO",scale = TRUE, jackknife = TRUE)
summary(m2)
##validate using 3 component. predicted vs. residuals from the predplot function Hence these are the (CV) VALIDATED versions####
par(mfrow = c(2, 2))
#k=8
fit <- predplot(m2, labels = rownames(prostate_TRAIN), which = "validation")
Residuals <- fit[,1] - fit[,2]
plot(fit[,2], Residuals, type="n", main = k, xlab = "Fitted", ylab = "Residuals")
text(fit[,2], Residuals, labels = rownames(prostate_TRAIN))

qqnorm(Residuals)
png('PCR.png')
plot(m2,main='PCR')
lines(lowess(prostate_TRAIN$lpsa,fit[,1]),col='blue') #more linear than other methods
dev.off()
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

