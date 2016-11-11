# Simulation of data:
set.seed <- 123.234

y <-  1:7 + rnorm(7, sd = 0.2)
x1 <- 1:7 + rnorm(7, sd = 0.2)
x2 <- 1:7 + rnorm(7, sd = 0.2)
x3 <- 1:7 + rnorm(7, sd = 0.2)
x4 <- 1:7 + rnorm(7, sd = 0.2)
data1 <- matrix(c(x1, x2, x3, x4, y), ncol = 5, byrow = F)
# For data1: (The right order will change depending on the simulation)
res <- lm(y ~ x1 + x2 + x3 + x4)
summary(res)
res <- lm(y ~ x2 + x3 + x4)
summary(res)
res <- lm(y ~ x2 + x3)
summary(res)
res <- lm(y ~ x3)
summary(res)
pairs(matrix(c(x1, x2, x3, x4, y), ncol = 5, byrow = F),
      labels = c("x1", "x2", "x3", "x4", "y"))
# For data2:
y  <- 1:7 + rnorm(7, sd = 0.2)
x1 <- 1:7 + rnorm(7, sd = 0.2)
x2 <- 1:7 + rnorm(7, sd = 0.2)
x3 <- 1:7 + rnorm(7, sd = 0.2)
x4 <- 1:7 + rnorm(7, sd = 0.2)
data2 <- matrix(c(x1, x2, x3, x4, y), ncol = 5, byrow = F)

res <- lm(y ~ x1 + x2 + x3 + x4)
summary(res)
res <- lm(y ~ x1 + x2 + x4)
summary(res)
res <- lm(y ~ x2 + x4)
summary(res)
res <- lm(y ~ x2)
summary(res)
pairs(matrix(c(x1, x2, x3, x4, y), ncol = 5, byrow = F),
      labels = c("x1", "x2", "x3", "x4", "y"))
xmn1 <- (data1[,1] + data1[,2] + data1[,3] + data1[,4])/4
xmn2 <- (data2[,1] + data2[,2] + data2[,3] + data2[,4])/4

rm1 <- lm(data1[,5] ~ xmn1)
rm2 <- lm(data2[,5] ~ xmn2)
summary(rm1)
summary(rm2)
# Almost all variance explained in first component:
princomp(data1[,1:4])
# The loadings of the first component:
princomp(data1[,1:4])$loadings[,1]
cf1 <- summary(lm(data1[,5] ~ data1[,1] + data1[,2] + data1[,3] + 
                    data1[,4]))$coefficients[,1]

cf <- summary(rm2)$coefficients[,1]
# Simulation of prediction:
error <- 0.2
y  <- rep(1:7, 1000) + rnorm(7000, sd = error)
x1 <- rep(1:7, 1000) + rnorm(7000, sd = error)
x2 <- rep(1:7, 1000) + rnorm(7000, sd = error)
x3 <- rep(1:7, 1000) + rnorm(7000, sd = error)
x4 <- rep(1:7, 1000) + rnorm(7000, sd = error)
yhat <- cf1[1] + matrix(c(x1, x2, x3, x4), ncol = 4, 
                        byrow = F) %*% t(t(cf1[2:5]))

xmn <- (x1 + x2 + x3 + x4)/4
yhat2 <- cf[1] + cf[2] * xmn
yhat3 <- cf[1] + cf[2] * x3

barplot(c(sum((y-yhat)^2)/7000, sum((y-yhat2)^2)/7000, sum((y-yhat3)^2)/7000),
        col = heat.colors(3), names.arg = c("Full MLR","Average","x3"),
        cex.names = 1.5, main = "Average squared prediction error")
# Spectral Example

x <- (-39:60)/10
spectra <- matrix(rep(0, 700), ncol = 100)
for (i in 1:7) spectra[i,] <- i * dnorm(x) + 
  i * dnorm(x) * rnorm(100, sd = 0.02)
y <- 1:7 + rnorm(7, sd = 0.2)

matplot(t(spectra), type = "n", xlab = "Wavelength", ylab = "")
matlines(t(spectra))
meansp <- apply(spectra, 2, mean)
lines(1:100, meansp, lwd = 2)
spectramc<-scale(spectra,scale=F)
matplot(t(spectramc),type="n",xlab="Wavelength",ylab="")
matlines(t(spectramc))
spectramcs<-scale(spectra,scale=T,center=T)
matplot(t(spectramcs),type="n",xlab="Wavelength",ylab="")
matlines(t(spectramcs))
# Doing the PCA on the correlation matrixs with the eigen-function: 
pcares <- eigen(cor(spectra))

loadings1 <- pcares$vectors[,1] #[100 100]
scores1 <- spectramcs%*%t(t(loadings1)) #[7 100]*[100 1]=[7 1]

pred <- scores1 %*% loadings1 #[7 100]
 <-apply(spectra, 2, sd)

## 1-PCA Predictions transformed to original scales and means:
predorg <- pred * matrix(rep(stdsp, 7), byrow=T, nrow=7) + 
  matrix(rep(meansp, 7), nrow=7, byrow=T)
par(mfrow = c(3, 3), mar = 0.6 * c(5, 4, 4, 2))
matplot(t(spectra), type = "n", xlab = "Wavelength",
        ylab = "", main = "Raw spectra", las = 1)
matlines(t(spectra))

matplot(t(spectramc), type = "n", xlab = "Wavelength",
        ylab = "", main = "Mean corrected spectra", las = 1)
matlines(t(spectramc))

matplot(t(spectramcs), type = "n", xlab = "Wavelength",
        ylab = "", main = "Standardized spectra", las = 1)
matlines(t(spectramcs))

matplot(t(spectra), type = "n", xlab = "Wavelength",
        ylab = "", main = "Mean Spectrum", las = 1)
lines(1:100, meansp, lwd = 2)
plot(1:100, -loadings1, ylim = c(0, 0.2), xlab = "Wavelength",
     ylab = "", main = "PC1 Loadings", las = 1)

matplot(t(pred), type = "n", xlab = "Wavelength",
        ylab = "", main = "Reconstruction using PC1", las = 1)
matlines(t(pred))

matplot(t(spectra), type = "n", xlab = "Wavelength",
        ylab = "", main = "Standard deviations", las = 1)
lines(1:100, stdsp, lwd = 2)

plot(1:7, scores1[7:1], main = "PC1 Scores", xlab = "Samples", 
     ylab = "", las = 1)

matplot(t(predorg), type = "n", xlab = "Wavelength",
        ylab = "", main = "Reconstruction using PC1")
matlines(t(predorg))
par(mfrow = c(1, 1))
barplot(c(10, 5, 3, 3.1, 3.2, 4, 6, 9), names.arg = 0:7,
        xlab = "No components", ylab = "RMSEP", cex.names = 2,
        main = "Validation results")
# Example: using Salt data:
saltdata <- read.table("LESLIE_SALT.csv", header = TRUE, sep = ";", dec = ".")
saltdata$logPrice <- log(saltdata$Price)

# Define the X-matrix as a matrix in the data frame:
saltdata$X <- as.matrix(saltdata[, 2:8])

# First of all we consider a random selection of 4 properties  as a TEST set
saltdata$train <- TRUE
saltdata$train[sample(1:length(saltdata$train), 4)] <- FALSE

saltdata_TEST <- saltdata[saltdata$train == FALSE,]
saltdata_TRAIN <- saltdata[saltdata$train == TRUE,]
# Run the PCR with maximal/large number of components using pls package:
library(pls)
mod <- pcr(logPrice ~ X , ncomp = 7, data = saltdata_TRAIN, 
           validation="LOO", scale = TRUE, jackknife = TRUE)
# Initial set of plots:
par(mfrow = c(2, 2))
plot(mod, labels = rownames(saltdata_TRAIN), which = "validation")
plot(mod, "validation", estimate = c("train", "CV"), legendpos = "topright")
plot(mod, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")
scoreplot(mod, labels = rownames(saltdata_TRAIN))
# Choice of components:

# what would segmented CV give:
mod_segCV <- pcr(logPrice ~ X , ncomp = 7, data = saltdata_TRAIN, scale = TRUE,
                 validation = "CV", segments = 5, segment.type = c("random"), 
                 jackknife = TRUE)

# Initial set of plots:
plot(mod_segCV, "validation", estimate = c("train", "CV"), legendpos = "topright")
plot(mod_segCV, "validation", estimate = c("train", "CV"), val.type = "R2", 
     legendpos = "bottomright")
# Let us look at some more components:

# Scores:
scoreplot(mod, comps = 1:4, labels = rownames(saltdata_TRAIN))

#Loadings:
loadingplot(mod,comps = 1:4, scatter = TRUE, labels = names(saltdata_TRAIN))
# We choose 4 components
mod4 <- pcr(logPrice ~ X , ncomp = 4, data = saltdata_TRAIN, validation = "LOO",
            scale = TRUE, jackknife = TRUE)
par(mfrow = c(2, 2))
k=4
obsfit <- predplot(mod4, labels = rownames(saltdata_TRAIN), which = "validation")
Residuals <- obsfit[,1] - obsfit[,2]
plot(obsfit[,2], Residuals, type="n", main = k, xlab = "Fitted", ylab = "Residuals")
text(obsfit[,2], Residuals, labels = rownames(saltdata_TRAIN))

qqnorm(Residuals)

# To plot residuals against X-leverage, we need to find the X-leverage:
# AND then find the leverage-values as diagonals of the Hat-matrix: 
# Based on fitted X-values:
Xf <- scores(mod4)
H <- Xf %*% solve(t(Xf) %*% Xf) %*% t(Xf)
leverage <- diag(H)

plot(leverage, abs(Residuals), type = "n", main = k)
text(leverage, abs(Residuals), labels = rownames(saltdata_TRAIN))
# Let's also plot the residuals versus each input X:
par(mfrow=c(3,3))
for ( i in 2:8){
plot(Residuals~saltdata_TRAIN[,i],type="n",xlab=names(saltdata_TRAIN)[i])
text(saltdata_TRAIN[,i],Residuals,labels=row.names(saltdata_TRAIN))  
lines(lowess(saltdata_TRAIN[,i],Residuals),col="blue")
}
# Now let's look at the results  -  4) "interpret/conclude"
par(mfrow = c(2, 2))

# Plot coefficients with uncertainty from Jacknife:
obsfit <- predplot(mod4, labels = rownames(saltdata_TRAIN), which = "validation")
abline(lm(obsfit[,2] ~ obsfit[,1]))
plot(mod, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")

coefplot(mod4, se.whiskers = TRUE, labels = prednames(mod4), cex.axis = 0.5)
biplot(mod4)
# And then finally some output numbers:
jack.test(mod4, ncomp = 4)
# And now let's try to predict the 4 data points from the TEST set: 

preds <- predict(mod4, newdata = saltdata_TEST, comps = 4)
plot(saltdata_TEST$logPrice, preds)
rmsep <- sqrt(mean((saltdata_TEST$logPrice - preds)^2))
rmsep
