#import:
saltdata <- read.table("LESLIE_SALT.csv", header = TRUE,
                       sep = ";", dec = ".")
#import:
saltdata$logPrice <- log(saltdata$Price)
# Simple regression
lm1 <- lm(logPrice ~ Distance, data = saltdata)
summary(lm1)
# Full MLR model:
lm2 <- lm(logPrice ~ County + Size + Elevation + Sewer + Date
          + Flood + Distance, data = saltdata)
summary(lm2)
step(lm2, direction = "backward")
logLik(lm2)
2*9-2*logLik(lm2)
AIC(lm2)
lm2summary <- summary(lm2)
lm2summary$sigma
var_ml <- lm2summary$sigma^2*23/31
sum(log(dnorm(resid(lm2), sd = sqrt(var_ml))))
lm3 <- lm(formula = logPrice ~ Elevation + Sewer + Date + Flood + 
         Distance, data = saltdata)
summary(lm3)
# plot fitted vs. observed - identifying observation nr:
plot(saltdata$logPrice, lm3$fitted, type = "n")
text(saltdata$logPrice, lm3$fitted, labels = row.names(saltdata))
# Regression Diagnostics plots given automatically, either 4: 
par(mfrow = c(2, 2))
plot(lm3)
# Or 6:
par(mfrow = c(3, 2))
plot(lm3, 1:6)
# Plot residuals versus individual xs:
par(mfrow = c(2, 3))
for (i in 4:8) {
  plot(lm3$residuals ~ saltdata[,i], type = "n", xlab = names(saltdata)[i])
  text(saltdata[,i], lm3$residuals, labels = row.names(saltdata))  
lines(lowess(saltdata[,i], lm3$residuals), col = "blue")
} 
library(reshape2)
saltdata$residuals <- resid(lm3)
saltdata2 <- melt(saltdata, measure.vars=c(4:6,8))
p <- ggplot(saltdata2, aes(value, residuals))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method="loess")
p <- p + facet_wrap(~ variable, scales="free") 
print(p)
lm4 <- lm(formula = logPrice ~ Elevation + Sewer + Date + Flood + 
         Distance + poly(Elevation, 3)+ poly(Date, 3), data = saltdata)
summary(lm4)
lm5  <- lm(formula = logPrice ~ (Elevation + Sewer + Date + Flood + Distance) *
       (Elevation + Sewer + Date + Flood + Distance), data = saltdata)
summary(lm5)
lm6  <- lm(formula = logPrice ~ Elevation + Sewer + Date + Flood + Distance +
       Elevation*(Sewer + Date + Flood) + Flood*(Date + Sewer) + Sewer*Distance, 
       data = saltdata)
summary(lm6)
lm7  <- lm(formula = logPrice ~ Elevation + Sewer + Date + Flood + Distance +
       Elevation*Sewer + Sewer*Distance, 
       data = saltdata)
summary(lm7)
# How to remove a potential outlier and re-analyze:
# E.g. Let's try without observation no 2 and 10: 
# Remove and copy-paste:
saltdata_red=saltdata[-c(2,10),]
# Check:
dim(saltdata)
dim(saltdata_red)
#row.names(saltdata_red)

lm3_red=lm(formula = logPrice ~ Elevation + Sewer + Date + 
             Flood + Distance, data = saltdata_red)
summary(lm3_red)
par(mfrow = c(3, 2))
plot(lm3_red, 1:6)
# With confidence intervals:
predict(lm3, saltdata[c(3,7,9),], interval = 'confidence')
# With prediction intervals:
predict(lm3, saltdata[c(3,7,9),], interval = 'prediction')
prostate <- read.table("prostatedata.txt", header = TRUE, 
                       sep = ";", dec = ",")
head(prostate)
summary(prostate)
dim(prostate)
pairs(prostate)


# lm4<-step(lm3)
# drop1(lm4,test="F")
# drop1(lm5<-update(lm4,~.-aveTemp:maxTemp),test="F")
