Edu<-read.table("C:/Users/RAN/OneDrive/Documents/BioDataAnalysis/DATA/EDUC_SCORES.txt",header=T,sep =",",row.names=1)
Edu
X<-Edu[,1:3] 
?apply()
apply(X,2,mean)
Xd<-scale(X,scale=F)
apply(X,2,sd)
Xs<-scale(X)
Xs

t(Xd)%*%Xd *1/7
# cov=(1/n-1)*(sum((x1-u1)(x2-u2)^2))
cov(X)

(t(Xs)%*%Xs)/7
cor(X)

saltdata<-read.table("C:/Users/RAN/OneDrive/Documents/BioDataAnalysis/DATA/Prepared for R/LESLIE_SALT.csv",header=T,sep =";",dec=".")

saltdata

#tale can be used in Latex
library(xtable)
first5obs <- Tab21[1:5,]
xtable(first5obs)
methods(xtable)


library(cluster)
library(gclus)
dta <- saltdata # get data - just put your own data here!
dta.r <- abs(cor(dta)) # get correlations
dta.col <- dmat.color(dta.r) # get colors
# reorder variables so those with highest correlation
# are closest to the diagonal
pairs(dta)
#Reorders objects so that similar (or high-merit) object pairs are adjacent. A permutation vector is returned
dta.o <- order.single(dta.r)
cpairs(dta, dta.o, panel.colors = dta.col, gap =.5,
       main = "Variables Ordered and Colored by Correlation" )


par(mfrow=c(2,4))
for (i in 1:8) qqnorm(saltdata[,i])

# Adding the log-price:
saltdata$logPrice=log(saltdata$Price)
# 9 histograms with color:
par(mfrow=c(3,3))
for (i in 1:9) hist(saltdata[,i],col=i)

# And identifying the observation numbers
attach(saltdata)
par(mfrow=c(1,1))
plot(logPrice~Size,type="n")
text(Size,logPrice,labels=row.names(saltdata))
abline(lm(logPrice~Size), col="red")

# For all of them:
attach(saltdata)
par(mfrow=c(2,4))
for (i in 2:8) {
  plot(logPrice~saltdata[,i],type="n",xlab=names(saltdata)[i])
  text(saltdata[,i],logPrice,labels=row.names(saltdata))
  abline(lm(logPrice~saltdata[,i]), col="red")
}
detach(saltdata)

attach(saltdata)
png("C:/Users/RAN/OneDrive/Documents/BioDataAnalysis/DATA/Prepared for R/logprice_relations.png",width=800,height=600)
par(mfrow=c(2,4))
for (i in 2:8) {
  plot(logPrice~saltdata[,i],type="n",xlab=names(saltdata)[i])
  text(saltdata[,i],logPrice,labels=row.names(saltdata))
  abline(lm(logPrice~saltdata[,i]), col="red")
}
dev.off()
detach(saltdata)


library(xtable)
capture.output(print(xtable(cor(saltdata)),type="html"),file="C:/Users/RAN/OneDrive/Documents/BioDataAnalysis/DATA/Prepared for R/cortable.html")
ggpairs(saltdata)

#make factors
saltdata$County <- factor(saltdata$County)
saltdata$Flood <- factor(saltdata$Flood)

library(ggplot2)
# First for each County:
p <- ggplot(saltdata, aes(Distance, logPrice, colour = County,
                          label = row.names(saltdata)))
p <- p + geom_text()
p <- p + geom_smooth(method = lm, fullrange=T)
print(p)

# Then for each Flooding condition:
p <- ggplot(saltdata, aes(Distance, logPrice, colour = Flood,
                          label = row.names(saltdata)))
p <- p + geom_text()
p <- p + geom_smooth(method = lm, fullrange=T)
print(p)

with(saltdata, table(County,Flood))

library(reshape2)
saltdata2 <- melt(saltdata, measure.vars=c(3,4,5,6, 8))
#take out column 3,4,5,6,8
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


library(GGally)
ggpairs(X)

d <- dist(mydata, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward") 
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=5, border="red")