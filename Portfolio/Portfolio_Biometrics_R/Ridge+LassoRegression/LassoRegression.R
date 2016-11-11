rm(list=ls())
# Now let's try to fit the lasso:

library(chemometrics, warn.conflicts = FALSE)
data(PAC)
# We could use the lars package:
#These are all variants of Lasso, and provide the entire sequence of coefficients and fits, starting from zero, to the least squares fit.
library(lars)
lasso_result <- lars(PAC$X, PAC$y)
plot(lasso_result$lambda)
plot(lasso_result$R2)
check<-cv.lars(PAC$X, PAC$y)

# Or from the chemometrics package:  "fraction" is the sum of absolute values of the regression coefficients for a particular Lasso parameter
res_lasso <- lassoCV(y ~ X, data = PAC,fraction = seq(0, 1, by = 0.05), K = 10) #k number of segments
res_lasso$sopt #optimal value for fraction
# the Bs are shrank 0.3 as they were before.
res_coef <- lassocoef(y ~ X, data = PAC, sopt = res_lasso$sopt)

# In an auto-scaled version:
res_lasso_scaled <- lassoCV(y ~ scale(X), data = PAC,fraction = seq(0, 1, by = 0.05), K = 10)
res_lasso_scaled$sopt
res_coef_scaled <- lassocoef(y ~ scale(X), data = PAC,sopt = res_lasso_scaled$sopt)
# The actual coefficients can be looked at by: (on raw X-scale - I believe.:-)...)
res_coef <- res_coef_scaled$coefficients
plot(res_coef)
beta_lasso <- res_coef

##prediction####
PAC_test=PAC
yhat_lasso <- predict(lasso_result, newx = PAC_test$X, s = 0.3,mode = "fraction")$fit
residuals <- PAC_test$y - yhat_lasso
MSEP <- mean(residuals^2)
MSEP

sqrt(MSEP)
plot(residuals)
lines(lowess(residuals,PAC_test$lasso), col="blue")
plot(PAC_test$y, yhat_lasso)


