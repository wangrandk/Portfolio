rm(list=ls())
pectin <- read.table("Pectin_and_DE.txt", header = TRUE,sep = ";", dec = ",")
View(pectin)
pectin$NIR<-as.matrix(pectin[,-1])
pectin$train <-TRUE
pectin$train[sample(1:length(pectin$DE),23)]<- FALSE
pectin_TEST <- pectin[pectin$train==FALSE,]
pectin_TRAIN <- pectin[pectin$train==TRUE,]

library(lars)
# We could use the lars package:
#These are all variants of Lasso, and provide the entire sequence of coefficients and fits, starting from zero, to the least squares fit.
lasso_result <- lars(pectin_TRAIN$NIR, pectin_TRAIN$DE,type="lasso")
plot(lasso_result$lambda)
plot(lasso_result$R2)
cv.lars(pectin_TRAIN$NIR, pectin_TRAIN$DE,use.Gram=FALSE)

# Or from the chemometrics package:  "fraction" is the sum of absolute values of the regression coefficients for a particular Lasso parameter
res_lasso <- lassoCV(DE ~ NIR, data = pectin_TRAIN,fraction = seq(0, 1, by = 0.05), K = 20,use.Gram=FALSE) #k number of segments
res_lasso$sopt #optimal value for fraction
# the Bs are shrank 0.3 as they were before.
png('Lasso_pectin.png')
res_coef <- lassocoef(DE ~ NIR, data = pectin_TRAIN, sopt = res_lasso$sopt)
dev.off()

# In an auto-scaled version:
res_lasso_scaled <- lassoCV(DE ~ scale(NIR), data = pectin_TRAIN,fraction = seq(0, 1, by = 0.05), K = 20,use.Gram=FALSE)
res_lasso_scaled$sopt
res_coef_scaled <- lassocoef(DE ~ scale(NIR), data = pectin_TRAIN,sopt = res_lasso_scaled$sopt,use.Gram=FALSE)
# The actual coefficients can be looked at by: (on raw NIR-scale - I believe.:-)...)
res_coef <- res_coef_scaled$coefficients
plot(res_coef)
beta_lasso <- res_coef

##prediction####
yhat_lasso <- predict(lasso_result, newx = pectin_TEST$NIR, s = 0.4,mode = "fraction")$fit
residuals <- pectin_TEST$DE - yhat_lasso
MSEP <- mean(residuals^2)
MSEP

sqrt(MSEP)
plot(residuals)
lines(lowess(residuals,pectin_TEST$lasso), col="blue")
png('lasso_pectin_fit.png')
plot(pectin_TEST$DE, yhat_lasso,main='Lasso_pectin')
lines(lowess(yhat_lasso,pectin_TEST$DE), col="blue")
dev.off()
