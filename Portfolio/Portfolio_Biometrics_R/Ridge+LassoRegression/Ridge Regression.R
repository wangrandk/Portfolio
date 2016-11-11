rm(list=ls())
library(chemometrics, warn.conflicts = FALSE)
data(PAC)

ridge_res <- plotRidge(y ~ X, data = PAC, lambda = seq(1, 20, by = 0.1))
ridge_res$lambdaopt  #4.3

# By real CV, e.g. LOO:
# Note that the ridgeCV function shown in the book does NOT do this for us
# It only looks into an allready chosen optimal lambda
# So we use the ridge.CV function from the parcor package:
library(parcor, warn.conflicts = FALSE)
par(mfrow=c(1, 1))
# First Full LOO
res_LOO <- ridge.cv(scale(PAC$X), PAC$y, lambda = seq(1, 20, by = 0.5), k = 209, plot.it = TRUE)
res_LOO$lambda.opt #8.5

# Then 9 (random) versions of 10-fold CV:
par(mfrow=c(3,3))
for ( i in 1:9){
res_CV10 = ridge.cv(scale(PAC$X),PAC$y,lambda=seq(1,20,by=0.5),k=10,plot.it=TRUE)
title(main=res_CV10$lambda.opt)
}

# Let's do our own "repeated double 10-fold CV":
K=10
lambda.opts <- rep(0, K)
for ( i in 1:K ){
res_CV10 <- ridge.cv(scale(PAC$X), PAC$y,lambda = seq(1, 30, by = 0.5),k = 10, plot.it = FALSE)
lambda.opts[i] <- res_CV10$lambda.opt
}
median(lambda.opts)

par(mfrow = c(1, 1))
boxplot(lambda.opts)

# Now let's try the ridgeCV to investigate the choice(s) more carefully:
# As suggested by the book
res <- ridgeCV(y ~ X, data = PAC, lambdaopt = 4,repl = 20)
#SEP  Standard Error of Prediction computed for each column of "residuals"
#sMAD  MAD of Prediction computed for each column of "residuals"

# Look at the coefficients:
ridge_lm <- lm.ridge(y ~ X, data = PAC, lambda = 4)
# Coefficients on raw X-scale:
plot(coef(ridge_lm))
# Coefficients on standardized X-scale:
plot(ridge_lm$coef)

##prediction####
# here we take the original data - just for illustration:
PAC_test=PAC
# First by ridge regression:
ridge_lm <- lm.ridge(y ~ X, data = PAC, lambda = 4)
# Coefficients on raw X-scale: (WITH intercept)
beta_ridge <- coef(ridge_lm)
yhat_ridge <- beta_ridge[1] + PAC_test$X %*% beta_ridge[-1]
residuals <- PAC$y - yhat_ridge
MSEP <- mean(residuals^2)
MSEP
sqrt(MSEP)
plot(PAC_test$y, yhat_ridge, ylim = c(180, 520))
