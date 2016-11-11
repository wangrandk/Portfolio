setwd("C:/Users/Verena/Desktop/Studium/14 SS/chemometrics")
pectin=read.table("Pectin_and_DE.txt",header=TRUE,sep=";",dec=",")

library(pls)

#define pectin data as matrix
pectin$NIR <- as.matrix(pectin[,-1])

#summary of pectin data
str(pectin)

length(pectin$DE)

# First of all we consider a random selection of 23
# observation as a TEST set
pectin$train <- TRUE
pectin$train[sample(1:length(pectin$DE),23)] <- FALSE
pectin_TEST <- pectin[pectin$train==FALSE,]
pectin_TRAIN <- pectin[pectin$train==TRUE,]
# The training X-data is 47 rows and 1039 columns:
dim(pectin_TRAIN$NIR)
#[1] 47 1039

# Pls:
mod_pls <- plsr(DE ~ NIR , ncomp = 30, data = pectin_TRAIN,
                validation = "LOO", scale = TRUE, jackknife = TRUE)


# Initial set of plots:
par(mfrow = c(2, 2))
plot(mod_pls, labels = rownames(pectin_TRAIN), which = "validation")
plot(mod_pls, "validation", estimate=c("train", "CV"),
     legendpos = "topright")
plot(mod_pls, "validation", estimate=c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")
scoreplot(mod_pls, labels = rownames(pectin_TRAIN))


# segmented CV for PLS:
mod_segCV <- plsr(DE ~ NIR , ncomp = 10, data = pectin_TRAIN, scale = TRUE,
                  validation="CV", segments = 5, segment.type = c("random"),
                  jackknife = TRUE)
# Initial set of plots:
par(mfrow=c(2, 1))
plot(mod_segCV, "validation", estimate = c("train", "CV"),
     legendpos = "topright")
plot(mod_segCV, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")

# segmented CV for PCR:
mod_segCV <- pcr(DE ~ NIR , ncomp = 10, data = pectin_TRAIN, scale = TRUE,
                  validation="CV", segments = 5, segment.type = c("random"),
                  jackknife = TRUE)
# Initial set of plots:
par(mfrow=c(2, 1))
plot(mod_segCV, "validation", estimate = c("train", "CV"),
     legendpos = "topright")
plot(mod_segCV, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")

# We choose 4 components
mod4 <- plsr(DE ~ NIR , ncomp = 4, data = pectin_TRAIN, validation = "LOO", scale = TRUE, jackknife = TRUE)

# Validate:
# Validation using 4 components
# We take the predicted and hence the residuals from the predplot function
# Hence these are the (CV) VALIDATED versions!
par(mfrow=c(2, 2))
obsfit <- predplot(mod4, labels = rownames(pectin_TRAIN),
                   which = "validation")
Residuals <- obsfit[,1] - obsfit[,2]
plot(obsfit[,2], Residuals, type = "n", xlab = "Fitted", ylab = "Residuals")
text(obsfit[,2], Residuals, labels = rownames(pectin_TRAIN))
qqnorm(Residuals)

# To plot residuals against X-leverage:
Xf <- scores(mod4)
H <- Xf %*% solve(t(Xf) %*% Xf) %*% t(Xf)
leverage <- diag(H)
plot(leverage, abs(Residuals), type = "n", main = "4")
text(leverage, abs(Residuals), labels = rownames(pectin_TRAIN))

# Results
par(mfrow=c(2,2))
# Plot coefficients 
obsfit <- predplot(mod4, labels = rownames(pectin_TRAIN),
                   which = "validation")
abline(lm(obsfit[,2] ~ obsfit[,1]))
plot(mod4, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")
coefplot(mod4, se.whiskers = TRUE, labels = prednames(mod4), cex.axis = 0.5)
biplot(mod4)


#RMSEP: predict the 4 data points from the TEST set:
preds <- predict(mod4, newdata = pectin_TEST, ncomp = 4)
plot(pectin_TEST$DE, preds)
rmsep <- sqrt(mean((pectin_TEST$DE - preds)^2))
rmsep

# do general PCR stuff in order to see how accurate the model is with a varying number of components
mod_pcr <- pcr(DE ~ NIR , ncomp = 10, data = pectin_TRAIN,
               validation = "LOO", scale = TRUE, jackknife = TRUE)
# Initial set of plots:
par(mfrow=c(2,2))
plot(mod_pcr, labels = rownames(pectin_TRAIN), which = "validation")
plot(mod_pcr, "validation", estimate = c("train", "CV"),
     legendpos = "topright")
plot(mod_pcr, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")
pls::scoreplot(mod_pcr, labels = rownames(pectin_TRAIN))
