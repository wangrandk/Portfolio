?dist
?hclust
rm(list=ls())
library(ChemometricsWithR)
data(wines)

## Distance matrix for a subset of data:
subset <- sample(nrow(wines), 20)
wines.dist <- dist(wines[subset,])

## Single linkage clustering:
wines.hcsingle <- hclust(wines.dist, method = "single")
plot(wines.hcsingle, labels = vintages[subset])

## Creates plot of phylogenetic tree in a fan form.
library(ape)
plot(as.phylo(wines.hcsingle), type = "fan", cex = 1)
## Complete Linkage clustering:
wines.hccomplete <- hclust(wines.dist, method = "complete")
plot(wines.hccomplete, labels = vintages[subset])
# Ward Hierarchical Clustering
wines.hcward <- hclust(wines.dist, method="ward.D") 
plot(wines.hcward,labels = vintages[subset]) # display dendogram
groups <- cutree(wines.hcward, k=c(3,5)) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
ct<-table(grp3 = groups[,"3"], grp5 = groups[,"5"])
diag(prop.table(ct, 1))
rect.hclust(wines.hcward, k=5, border="red")
## Clustering, cf. chapter in book:
wines.cl.single <- cutree(wines.hcsingle, h = 80)
plot(wines.cl.single)
table(wines.cl.single, vintages[subset])

wines.dist <- dist(wines)
wines.hcsingle <- hclust(wines.dist, method = "single")
table(vintages, cutree(wines.hcsingle, k = 3))
wines.hcaverage <- hclust(wines.dist, method = "average")
table(vintages, cutree(wines.hcaverage, k = 3))
wines.hccomplete <- hclust(wines.dist, method = "complete")
table(vintages, cutree(wines.hccomplete, k = 3))
library(cluster)
wines.agness <- agnes(wines.dist, method = "single")
wines.agnesa <- agnes(wines.dist, method = "average")
wines.agnesc <- agnes(wines.dist, method = "complete")
cbind(wines.agness$ac, wines.agnesa$ac, wines.agnesc$ac) # agglomerative coeficient.
## Computing cophenetic correlation:

plot(wines.agness, nmax = 150,labels = vintages[subset]) # ac gives indecation of h, 
# Correspondenc analysis delete corvariance when projecting data to 2-3 compodents, Clustering remains corvariance.
c1<-cor(wines.dist, cophenetic(wines.hcsingle)) # how nice the dendrogram fits the original distance.
c2<-cor(wines.dist, cophenetic(wines.hcaverage))
c3<-cor(wines.dist, cophenetic(wines.hccomplete))
c(c1,c2,c3)
# 0.7779217 0.8036244 0.7973172 original data has higher cor than scaled
# Yule:(ad-bc)/(ad+bc)
# Phi: 

##EU####
rm(list=ls())
EU <- read.table("EU.txt", header = TRUE,sep = "", dec = ",")
EU = t(EU)
View(EU)
#subset<-EU[,16:17]
#EU.dist <- dist(EU[,subset])
#tbl = table(EU$Smoke, EU$Exer) 
#chisq.test(tbl)
EU.dist<-dist(EU,method="euclidean")
#EU.dist<-oldDistance(EU,method="chi.square")
library(cluster)
EU.agness <- agnes(EU.dist, method = "single")
EU.agnesa <- agnes(EU.dist, method = "average")
EU.agnesc <- agnes(EU.dist, method = "complete")
EU.hcaverage <- hclust(EU.dist, method = "average")
cbind(EU.agness$ac, EU.agnesa$ac, EU.agnesc$ac)
par(mfrow=c(1, 2))
plot(EU.agnesa,labels = rownames(EU))
EU.cut<- cutree(EU.hcaverage, h = 5)
table(rownames(EU),EU.cut)
plot(EU.cut)
cor(EU.dist, cophenetic(EU.agness))
cor(EU.dist, cophenetic(EU.agnesa)) # fits best
cor(EU.dist, cophenetic(EU.agnesc))


##Wine_scaled####
library(ChemometricsWithR)
data(wines)
wines_scale<-scale(wines, center = T, scale = TRUE)
wines.dist <- dist(wines_scale)
wines.hcsingle <- hclust(wines.dist, method = "single")
table(vintages, cutree(wines.hcsingle, k = 3))
wines.hcaverage <- hclust(wines.dist, method = "average")
table(vintages, cutree(wines.hcaverage, k = 3))
wines.hccomplete <- hclust(wines.dist, method = "complete")
table(vintages, cutree(wines.hccomplete, k = 3))
library(cluster)
wines.agness <- agnes(wines.dist, method = "single")
wines.agnesa <- agnes(wines.dist, method = "average")
wines.agnesc <- agnes(wines.dist, method = "complete")
cbind(wines.agness$ac, wines.agnesa$ac, wines.agnesc$ac)
c1<-cor(wines.dist, cophenetic(wines.agness))
c2<-cor(wines.dist, cophenetic(wines.agnesa)) # fits best
c3<-cor(wines.dist, cophenetic(wines.agnesc))
c(c1,c2,c3) #0.4999069 0.7480003 0.6179819
par(mfrow=c(1, 1))
plot(wines.agnesa, nmax = 150,labels = vintages)
plot(wines.hcsingle,labels = vintages)
plot(wines.hcaverage,labels = vintages)
plot(wines.hccomplete,labels = vintages)

##
data(wines)
wines<-t(wines)#examine the variables.
View(wines)
wines.dist <- dist(wines)
wines.hcsingle <- hclust(wines.dist, method = "single")

wines.hcaverage <- hclust(wines.dist, method = "average")

wines.hccomplete <- hclust(wines.dist, method = "complete")

library(cluster)
wines.agness <- agnes(wines.dist, method = "single")
wines.agnesa <- agnes(wines.dist, method = "average")
wines.agnesc <- agnes(wines.dist, method = "complete")
cbind(wines.agness$ac, wines.agnesa$ac, wines.agnesc$ac)
c1<-cor(wines.dist, cophenetic(wines.agness))
c2<-cor(wines.dist, cophenetic(wines.agnesa)) # fits best
c3<-cor(wines.dist, cophenetic(wines.agnesc))
c(c1,c2,c3) #0.4999069 0.7480003 0.6179819
par(mfrow=c(1, 1))
plot(wines.agnesa, nmax = 150,labels = vintages)
plot(wines.hcsingle,labels = rownames(wines))
plot(wines.hcaverage,labels = rownames(wines))
plot(wines.hccomplete,labels = rownames(wines))
