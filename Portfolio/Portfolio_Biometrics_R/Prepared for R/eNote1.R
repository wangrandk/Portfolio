## Adding numbers in the console
2+3
y <- 3
x <- c(1, 4, 6, 2)
x
x <- 1:10
x
x <- seq( 0, 1, by = 0.1)
x
## Sample Mean and Median
x <- c(168, 161, 167, 179, 184, 166, 198, 187, 191, 179)
mean(x)
median(x)
## Sample variance and standard deviation
var(x)
sqrt(var(x))
sd(x)
## Sample quartiles
quantile(x, type = 2)
## Sample quantiles 0%, 10%,..,90%, 100%:
quantile(x, probs = seq(0, 1, by = 0.10), type = 2)
par(mar=c(3.5,3.5,3.5,3.5))
## A histogram of the heights:
 hist(x)
par(mar=c(3.5,3.5,3.5,3.5))
## A density histogram of the heights:
hist(x, freq = FALSE, col = "red", nclass = 8)
par(mar=c(3.5,3.5,3.5,3.5))
plot(ecdf(x), verticals = TRUE)
## A Pareto diagram based on the class counts from the hist-function:
library(qcc)
myhist <- hist(x,plot=FALSE)
mycounts=myhist$counts
names(mycounts)=myhist$breaks[-1]
pareto.chart(mycounts)
par(mar=c(2.5,3.5,2.5,3.5))
## A basic boxplot of the heights: (range=0 makes it "basic")
boxplot(x, range = 0, col = "red", main = "Basic boxplot")
text(1.3, quantile(x), c("Minimum","Q1","Median","Q3","Maximum"), col="blue")
par(mar=c(2.5,1.5,2.5,1.5))
par(mfrow=c(1,2))
boxplot(c(x, 235), col = "red", main = "Modified boxplot")
text(1.4, quantile(c(x, 235)), c("Minimum","Q1","Median","Q3","Maximum"),
     col = "blue")

boxplot(c(x, 235), col = "red", main = "Basic boxplot", range = 0)
text(1.4, quantile(c(x, 235)),c("Minimum","Q1","Median","Q3","Maximum"),
     col = "blue")
Males <-  c(152, 171, 173, 173, 178, 179, 180, 180, 182, 182, 182, 185,
            185 ,185, 185, 185 ,186 ,187 ,190 ,190, 192, 192, 197)
Females <-c(159, 166, 168 ,168 ,171 ,171 ,172, 172, 173, 174 ,175 ,175,
            175, 175, 175, 177, 178)
boxplot(list(Males, Females), col = 2:3, names = c("Males", "Females"))
studentheights <- read.table("studentheights.csv", sep = ";", dec = ".",
                             header = TRUE)
## Have a look at the first 6 rows of the data:
head(studentheights)
## Get a summary of each column/variable in the data:
summary(studentheights)
par(mar=c(2.5,3.5,2.5,3.5))
boxplot(Height ~ Gender, data = studentheights, col=2:3)
par(mar=c(4.5,3.5,3.5,2.5))
## To make 2 plots on a single plot-region:
par(mfrow=c(1,2))
## First the default version:
plot(mtcars$wt, mtcars$mpg)
## Then a nicer version:
plot(mpg ~ wt, xlab = "Car Weight (1000lbs)", data = mtcars,
     ylab = "Miles pr. Gallon", col = factor(am),
     sub = "Red: manual transmission", main = "Inverse fuel usage vs. size")
## Barplot:
barplot(table(studentheights$Gender), col=2:3)
## Pie chart:
pie(table(studentheights$Gender), cex=1, radius=1)
# Reading data from chapter 2:
X1=c(57, 58, 60, 59, 61, 60, 62, 61, 62, 63, 
     62, 64, 63, 65, 64, 66, 67, 66, 68, 69)
X2=c(93, 110, 99, 111, 115, 122, 110, 116, 122, 128, 134,
    117, 123, 129, 135, 128, 135, 148, 142, 155)
mean(X1)
mean(X2)
sd(X1)
sd(X2)
# Only centering:
X_d1=X1-mean(X1)
X_d2=X2-mean(X2)

# Standardization
X_s1=X_d1/sd(X1)
X_s2=X_d2/sd(X2)
# Table 2.1:
Tab21=cbind(X1,X2,X_d1,X_d2,X_s1,X_s2)
Tab21
library(xtable)
first5obs <- Tab21[1:5,]
xtable(first5obs)
xtable(first5obs)
methods(xtable)
print(xtable(first5obs), type = "html")
## print(xtable(first5obs), type = "html", file = "myhtmltable.html")
# Raw data in matrix X: 
X <- cbind(X1, X2)
# Using scale function to only center:
X_d <- scale(X, scale = F)
# Using scale function to  center and standardize:
X_s <- scale(X)
# Means by  columns:
round(apply(Tab21, 2, mean), 2)

# Standard deviations by columns:
round(apply(Tab21, 2, sd), 2)
par(mfrow=c(1, 2)) # To make two plots in one page in a 1x2 structure 
plot(X1, X2, las = 1)
plot(X_s1, X_s2, las = 1)
abline(h = 0, v = 0) # Adding horizontal and vertical lines at zeros
arrows(0, 0, 1, 1)  # Adding the arrow
# Correlation using function:
cor(X)
# Correlation using matrix-multiplication:
t(X_s)%*%X_s/19
# How to find the arrow direction from data:
eigen(cor(X))
# Using notation from Chapter 2:
W=eigen(cor(X))$vectors
W # In PCA: loadings
# The projected values: (Fig. 2.8, Fig 2.10)
z1=X_s %*% W[,1]
z2=X_s %*% W[,2]

plot(z1, z2, ylim = c(-3, 3), xlim = c(-3, 3))
par(mfrow=c(1, 2)) 
var(z1)
var(z2)
hist(z1, xlim = c(-3, 3))
hist(z2, xlim = c(-3, 3))
eigen(cor(X))$values
# And the D-matrix is the diagonal of the square-roots of these:
D=diag(sqrt(eigen(cor(X))$values))
D # In Pca: The explained variances
# And the z1 and z2 can be standardized by these sds:
z_s1=z1/sd(z1)
z_s2=z2/sd(z2)

cbind(z_s1, z_s2)
# Or the same could be extracted from the matrices:
Z_s=X_s %*% W %*% solve(D)
Z_s # In PCA: The standardized scores

var(Z_s)
# So we have done the SVD, check:
cbind(Z_s %*% D %*% t(W), X_s)
# Importing data:
educ_scores=read.table("EDUC_SCORES.txt",header=TRUE,sep=",",row.names=1)
educ_scores
X <- educ_scores[,1:3]
# Scatterplot Matrices using pairs: 
pairs(X)
# Scatterplot Matrices using pairs WITH color coding of groups 
Gender <- factor(educ_scores[,4]) # Defining column 4 as a grouping factor
pairs(X, main = "Scatterplots - Gender grouping",
      col = c("red", "blue")[Gender])
# Scatterplot Matrices from the lattice Package 
library(lattice)
Gender <- factor(educ_scores[,4]) # Defining column 4 as a grouping factor
splom(X, groups = Gender)
library(GGally)
ggpairs(X)
# 3D Scatterplot
library(scatterplot3d)
scatterplot3d(X, main="3D Scatterplot")
# 3D Scatterplot with Coloring and Vertical Drop Lines
scatterplot3d(X, pch = 16, highlight.3d = TRUE,
              type = "h", main = "3D Scatterplot")
# 3D Scatterplot with Coloring and Vertical Lines
# and Regression Plane 
s3d <- scatterplot3d(X, pch = 16, highlight.3d = TRUE,
                    type = "h", main = "3D Scatterplot")
fit <- lm(X[,3] ~ X[,1] + X[,2]) 
s3d$plane3d(fit)
# Spinning 3d Scatterplot
library(rgl)
plot3d(X, col="red", size=3)
#import:
saltdata <- read.table("LESLIE_SALT.csv", header = TRUE, 
                       sep = ";", dec = ".")
head(saltdata) # List the top ofo the data set
summary(saltdata) # Summarize each variable in the data set
dim(saltdata) # Show number of rows and columns in the data set
pairs(saltdata)
# Scatterplot Matrices from the glus Package 
library(cluster)
library(gclus)
dta <- saltdata # get data - just put your own data here!
dta.r <- abs(cor(dta)) # get correlations
dta.col <- dmat.color(dta.r) # get colors
# reorder variables so those with highest correlation
# are closest to the diagonal
dta.o <- order.single(dta.r) 
cpairs(dta, dta.o, panel.colors = dta.col, gap =.5,
       main = "Variables Ordered and Colored by Correlation" )
# 8 Normal probility plots on the same plot page:
par(mfrow=c(2,4))
for (i in 1:8) qqnorm(saltdata[,i])
# Adding the log-price:
saltdata$logPrice=log(saltdata$Price)
# 9 histograms with color:
par(mfrow=c(3,3))
for (i in 1:9) hist(saltdata[,i],col=i)
# scatterplot for logprice: with Added fit lines
# And identifying the observation numbers
attach(saltdata)

par(mfrow=c(1,1))
plot(logPrice~Size,type="n")
text(Size,logPrice,labels=row.names(saltdata))
abline(lm(logPrice~Size), col="red")
detach(saltdata)
# For all of them:
attach(saltdata)
par(mfrow=c(2,4))
for (i in 2:8) {
 plot(logPrice~saltdata[,i],type="n",xlab=names(saltdata)[i])
 text(saltdata[,i],logPrice,labels=row.names(saltdata))
 abline(lm(logPrice~saltdata[,i]), col="red")
} 
detach(saltdata)
# Saving directly to a pgn-file:
attach(saltdata)
png("logprice_relations.png",width=800,height=600)
par(mfrow=c(2,4))
for (i in 2:8) {
  plot(logPrice~saltdata[,i],type="n",xlab=names(saltdata)[i])
  text(saltdata[,i],logPrice,labels=row.names(saltdata))
  abline(lm(logPrice~saltdata[,i]), col="red")
} 
dev.off()
detach(saltdata)
# Correlation (with 2 decimals)
round(cor(saltdata),2)
# Making a table for viewing in a browser - to be included in e.g. Word/Powerpoint 
# Go find/use the cortable.html file afterwards 
library(xtable)
capture.output(print(xtable(cor(saltdata)),type="html"),file="cortable.html")
ggpairs(saltdata)
saltdata$County <- factor(saltdata$County) 
saltdata$Flood  <- factor(saltdata$Flood) 
 # First for each County:
p <- ggplot(saltdata, aes(Distance, logPrice, colour = County, 
                          label = row.names(saltdata)))
p <- p + geom_text()
p <- p + geom_smooth(method = lm, fullrange=T)
print(p)
 # Then  for each Flooding condition:
p <- ggplot(saltdata, aes(Distance, logPrice, colour = Flood, 
                     label = row.names(saltdata))) 
p <- p + geom_text()
p <- p + geom_smooth(method = lm, fullrange=T)
print(p)
# Or all combinations on separate plots:
p <- ggplot(saltdata, aes(Distance, logPrice, label = row.names(saltdata)))
p <- p + geom_text()
p <- p + geom_smooth(method = lm, fullrange=T)
p <- p + facet_wrap(~ County + Flood) 
print(p)
with(saltdata, table(County,Flood))
library(reshape2)
saltdata2 <- melt(saltdata, measure.vars=c(3,4,5,6, 8))
summary(saltdata2)
p <- ggplot(saltdata2, aes(value, logPrice))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method = lm)
p <- p + facet_wrap(~ variable, scales="free") 
print(p)
p <- ggplot(saltdata2, aes(value, logPrice))
p <- p + geom_point(shape=1)
p <- p + geom_smooth(method="loess")
p <- p + facet_wrap(~ variable, scales="free") 
print(p)
#import:
educ_scores=read.table("EDUC_SCORES.txt", header = TRUE,
                       sep = ",", row.names = 1)
educ_scores
#Select the relevant columns:
X <- educ_scores[,1:3]
X
# a)
?apply()
apply(X,2,mean)
# b)
?scale
Xd=scale(X,scale=F)
Xd
# c)
apply(X,2,sd)
Xs=scale(X)
Xs
# d)
?cov
t(Xd)%*%Xd
7*cov(X)
# e) 
(t(Xd)%*%Xd)/7
cov(X)
# f) 
(t(Xs)%*%Xs)/7
cor(X)
#import:
saltdata <- read.table("LESLIE_SALT.csv", header = TRUE, 
                       sep = ";", dec = ".")
head(saltdata) # List the top ofo the data set
summary(saltdata) # Summarize each variable in the data set
dim(saltdata) # Show number of rows and columns in the data set
