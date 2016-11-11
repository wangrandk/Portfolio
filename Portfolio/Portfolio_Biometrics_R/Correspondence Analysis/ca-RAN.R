rm(list=ls())
Lebart <- read.table("Lebart.txt", header = TRUE,sep = "", dec = ",")
head(Lebart)
summary(Lebart)


library(ca)
leb<-ca(Lebart)
par(mfrow=c(1,1))
plot(leb)
summary(leb)
View(Lebart)
plot(leb, mass = TRUE, contrib = "absolute", map =
       "rowgreen", arrows = c(FALSE, TRUE))
plot3d.ca(leb, nd=3)

# Chi-square analysis
chisqresults <- chisq.test(Lebart)
# greater the chi square number; lower the probability(less than.05,reject Ho); the stronger the relationship between the dependent and independent variable, H0: two categories are not associated.
#p-value < 2.2e-16 is significant deviation from the independence hypothesis

chisqresults$observed
chisqresults$expected
chival<-sum((chisqresults$observed-chisqresults$expected)^2/chisqresults$expected)

# signed rootcontributions ??2: without sum and take sqrt of n
nphis <- (chisqresults$observed-chisqresults$expected)/sqrt(chisqresults$expected)
# Check:
sum(nphis^2)
n=sum(Lebart)
#signed rootcontributions are individual contributions to the Inertia
#total inertia in CA
inertial<-(chival)/n
phis<-nphis/sqrt(n)
inertial1<-sum(phis^2)

#The CA computations are simply the PCA of this matrix: (without any further centering nor scaling)
pcaofphis <- prcomp(phis, center=T)
round(100*pcaofphis$sdev^2/sum(pcaofphis$sdev^2),2)
biplot(pcaofphis, main = "biplot",cex=.5)
# combinations of row level and column level that mostly deviates from independence

##EU####
EU <- read.table("EU.txt", header = TRUE,sep = "", dec = ",")
head(EU)
eu<-ca(EU)
par(mfrow=c(1,1))
plot(eu)
summary(eu)

# a. 63.6% is explained by the first three CA.
# a. in max 16 axes can be extracted
# b. GB is most extreme
# c.d group(DK,SF)->(hou,sub,exp); (NL,GR,D)->(Fin,MAJ,BES,STR)<-(B,EP,L,A)
 
plot(eu, mass = TRUE, contrib = "absolute", map =
       "rowgreen", arrows = c(FALSE, TRUE))
plot3d.ca(eu, nd=3)

##PCA of EU####
chi <- chisq.test(EU)
# L<-as.matrix(EU)
# fisher.test(L)
chieu <- sum((chi$observed-chi$expected)^2/(chi$expected))
src <- (chi$observed-chi$expected)/sqrt(chi$expected)
# Check:
sum(src^2)
#signed rootcontributions are individual contributions to the Inertia
#total inertia in CA
inertias<-chieu/sum(EU)
phi<-src/sqrt(sum(EU))
inertias1<-sum(phi^2)

PCAphi <- prcomp(phi, center=T)
round(100*PCAphi$sdev^2/sum(PCAphi$sdev^2),2)
par(mfrow=c(1,1))
biplot(PCAphi, main = "biplot",cex=.5)

library(ChemometricsWithRData)
library(ChemometricsWithR)
EUPC <- PCA(scale(EU))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(EUPC,pc = c(1, 2),show.names = TRUE, pcscores = scores(EUPC), main = "Scores")
loadingplot(EUPC,  pc = c(1, 2), pcloadings = loadings(EUPC),show.names = TRUE, main = "Loadings")
biplot(EUPC, show.names = "both",score.col=1,loading.col="blue", main = "biplot")
screeplot(EUPC, type = "percentage", main = "Explained variance")

##variance plot####
par(mfrow=c(1,2))
plot(1:length(EUPC$var), EUPC$var, cex = 2,
     ylab = "variance explained",xlab = "n PC")
lines(1:length(EUPC$var), EUPC$var)
plot(1:length(EUPC$var), cumsum(EUPC$var/sum(EUPC$var)), cex = 2,
     ylab = "(explained variance)/(total variance)",xlab = "n PC")
lines(1:length(EUPC$var), cumsum(EUPC$var/sum(EUPC$var)))
# Scores:
pairs(scores(EUPC))
# Loadings:
par(mfrow = c(4,4), mar = c(4,4,.1,.1))
for (i in 1:4) for (j in 1:4) loadingplot(EUPC,
                                          show.names = TRUE,pc=c(i,j), cex.lab=0.7)
##ggplot for PCA####
EU.pca <- prcomp(EU,
                 center = TRUE,
                 scale. = TRUE)
library(devtools)
# First time install: install_github("ggbiplot", "vqv")
library(ggbiplot)
g <- ggbiplot(EU.pca, obs.scale = 1, var.scale = 1,groups = EU[,17], ellipse = TRUE,circle = FALSE)
print(g)

library(chemometrics)
EUPCA <- princomp(EU, cor = TRUE)
## Plots vs object number :
res <- pcaDiagplot(EU, EUPCA, a = 2)
## Plot of the two agains each other:
par(mfrow=c(1,2))
plot(res$SDist, res$ODist, type = "n")
text(res$SDist, res$ODist, labels = row.names(EU))
## Explained variance for each variable
pcaVarexpl(EU,a=2) #a  number of principal components

# Influence plot: residuals versus leverage
# for different number of components:
par(mfrow=c(2,2))
for (i in 1:17) {
  res=pcaDiagplot(EU[,1:17],a=i,EUPCA,plot=FALSE)
  plot(res$SDist,res$ODist,type="n")
  text(res$SDist,res$ODist,labels=row.names(EU))
}

## Random samples of a certain proportion of the original number of observations are left out####
# par(mar = c(1,1,1,1), mfrow = c(3,3))
# n=length(iris[,1])
# leave_out_size=0.50
# for (k in 1:9){
#   irisPC=PCA(scale(iris[sample(1:n,round(n*(1-leave_out_size))),1:4]))
#   loadingplot(irisPC, show.names = TRUE, main = "Loadings")
# }
# par(mar = c(4.5,1.5,4.5,1.5), mfrow = c(3,3))
# for (k in 1:9){
#   subsample <- sample(1:n,round(n*(1-leave_out_size)))
#   irisPC <- PCA(scale(iris[subsample,1:4]))
#   scoreplot(irisPC, col = iris$Species[subsample], main = "Scores")
# }

