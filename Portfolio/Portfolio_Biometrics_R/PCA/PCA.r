JCFiris<-read.csv("Fisher_JCF.csv",header=T,sep =";",dec=",")
View(JCFiris)
summary(JCFiris)
head(JCFiris)
library(ChemometricsWithRData)
library(ChemometricsWithR)
data(iris)
View(iris)
head(iris)

##Basic  classic (univariate) explorative analysis####
par(mar=c(4,2,3,2),mfrow=c(2,2))
for (i in 1:4) boxplot(iris[,i] ~ iris[,5],
                       col = 1:3, main = names(iris)[i])

par(mar=c(4,2,3,2),mfrow=c(2,2))
for (i in 2:5) boxplot(JCFiris[,i] ~ JCFiris[,1],
                       col = 1:3, main = names(JCFiris)[i])
outlier<-JCFiris[JCFiris[,5]>100,]
# X PW PL SW  SL
# 42 virginica 21 54 31 699

JCFiris1<-JCFiris[-42,]
summary(JCFiris)
str(JCFiris1)
#replace with median
JCFiris[42,5]=58
par(mar=c(4,2,3,2),mfrow=c(2,2))
for (i in 2:5) boxplot(JCFiris[,i] ~ JCFiris[,1],
                       col = 1:3, main = names(JCFiris)[i])


pairs(iris,col = iris$Species)

cov(iris[,1:4])
cor(iris[,1:4])
##WITHOUT Standardization - ONLY with centering####
irisPC_without=PCA(scale(iris[,1:4], scale = FALSE))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(irisPC_without, col = iris$Species, main = "Scores")
loadingplot(irisPC_without, show.names = TRUE, main = "Loadings")
biplot(irisPC_without, score.col = iris$Species, main = "biplot")
screeplot(irisPC_without, type = "percentage", main = "Explained variance")

##with both####
irisPC <- PCA(scale(iris[,1:4]))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(irisPC, col = iris$Species, main = "Scores")
loadingplot(irisPC, show.names = TRUE, main = "Loadings")
biplot(irisPC, score.col = iris$Species, main = "biplot")
screeplot(irisPC, type = "percentage", main = "Explained variance")

##variance plot####
par(mfrow=c(1,2))
plot(1:length(irisPC$var), irisPC$var, cex = 2,
     ylab = "variance explained",xlab = "n PC")
lines(1:length(irisPC$var), irisPC$var)
plot(1:length(irisPC$var), cumsum(irisPC$var/sum(irisPC$var)), cex = 2,
     ylab = "(explained variance)/(total variance)",xlab = "n PC")
lines(1:length(irisPC$var), cumsum(irisPC$var/sum(irisPC$var)))
# Scores:
pairs(scores(irisPC), col = iris$Species)
# Loadings:
par(mfrow = c(4,4), mar = c(4,4,.1,.1))
for (i in 1:4) for (j in 1:4) loadingplot(irisPC,
                      show.names = TRUE,pc=c(i,j), cex.lab=0.7)
##ggplot for PCA####
ir.pca <- prcomp(iris[,1:4],
                 center = TRUE,
                 scale. = TRUE)
library(devtools)
# First time install: install_github("ggbiplot", "vqv")
library(ggbiplot)
g <- ggbiplot(ir.pca, obs.scale = 1, var.scale = 1,groups = iris[,5], ellipse = TRUE,circle = FALSE)
print(g)

library(chemometrics)
irisPCA <- princomp(iris[,1:4], cor = TRUE)
## Plots vs object number :
res <- pcaDiagplot(iris[,1:4], irisPCA, a = 2)
## Plot of the two agains each other:
par(mfrow=c(1,2))
plot(res$SDist, res$ODist, type = "n")
text(res$SDist, res$ODist, labels = row.names(iris))
## Explained variance for each variable
pcaVarexpl(iris[,1:4],a=2) #a  number of principal components

# Influence plot: residuals versus leverage
# for different number of components:
par(mfrow=c(2,2))
for (i in 1:4) {
  res=pcaDiagplot(iris[,1:4],a=i,irisPCA,plot=FALSE)
  plot(res$SDist,res$ODist,type="n")
  text(res$SDist,res$ODist,labels=row.names(iris))
}
## Random samples of a certain proportion of the original number of observations are left out####
par(mar = c(1,1,1,1), mfrow = c(3,3))
n=length(iris[,1])
leave_out_size=0.50
for (k in 1:9){
  irisPC=PCA(scale(iris[sample(1:n,round(n*(1-leave_out_size))),1:4]))
  loadingplot(irisPC, show.names = TRUE, main = "Loadings")
}
par(mar = c(4.5,1.5,4.5,1.5), mfrow = c(3,3))
for (k in 1:9){
  subsample <- sample(1:n,round(n*(1-leave_out_size)))
  irisPC <- PCA(scale(iris[subsample,1:4]))
  scoreplot(irisPC, col = iris$Species[subsample], main = "Scores")
}

## Spectral data####
data(yarn) # Part of chemometrics package
head(data)
?yarn
dim(yarn$NIR)
par(mfrow = c(2, 2), mar = c(4, 4, 1.2, 1.2))
# Plotting of the 21 individual NIR spectra"
max_X=max(yarn$NIR)
min_X=min(yarn$NIR)
plot(yarn$NIR[1,],type="n",ylim=c(min_X,max_X))
for (i in 1:21)  lines(yarn$NIR[i,],col=i)
# Plotting of the 21 individual NIR spectra - centered"
max_X=max(scale(yarn$NIR,scale=F))
min_X=min(scale(yarn$NIR,scale=F))
plot(scale(yarn$NIR[1,],scale=F),type="n",ylim=c(min_X,max_X))
for (i in 1:21) lines(scale(yarn$NIR,scale=F)[i,],col=i)
# Plotting of the 21 individual NIR spectra - centered and scaled"
max_X=max(scale(yarn$NIR))
min_X=min(scale(yarn$NIR))
plot(scale(yarn$NIR[1,]),type="n",ylim=c(min_X,max_X))
for (i in 1:21) lines(scale(yarn$NIR)[i,],col=i)
# Plotting of the principal variances: "
yarnPC <- PCA(scale(yarn$NIR))
plot(1:length(yarnPC$var),yarnPC$var,cex=2)
lines(1:length(yarnPC$var),yarnPC$var)
# Plot of y:
plot(yarn$density,type="n")
lines(yarn$density)
