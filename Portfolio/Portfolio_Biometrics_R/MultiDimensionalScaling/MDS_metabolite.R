##Secondary metabolite data####
rm(list=ls())
smdata<- matrix(scan("SM.txt"), ncol = 51, byrow = T)
library(vegan)
dist_jaccard<-vegdist(smdata,method="jaccard")

smr<-cor(smdata, method="pearson") #d = 1 - r,  r = Z(x)·Z(y)/n
dist_pearson<-1.-smr
dist_pearson<-data.frame(dist_pearson)

##PCO_jaccard####
fit <- cmdscale(dist_jaccard,eig=TRUE, k=3) # k is the number of dim

x <- fit$points[,1]
y <- fit$points[,2]
z <- fit$points[,3]
plot(x,y, xlab="Coordinate 1", ylab="Coordinate 2",type="n",main="PCO 1,2")
text(x, y, labels=colnames(as.matrix(dist_jaccard)),cex=.6)
plot(x,z, xlab="Coordinate 1", ylab="Coordinate 3",main="PCO 1,3",type="n")
text(x, z, labels=colnames(as.matrix(dist_jaccard)),cex=.6)
plot(y,z, xlab="Coordinate 2", ylab="Coordinate 3",type="n",main="PCO 2,3")
text(y,z, labels=colnames(as.matrix(dist_jaccard)),cex=.6)


library(scatterplot3d)
scatterplot3d(x,y,z, main="3D Scatterplot PCO")

# PCO SPINNING TREE
library(ape)
st <- mst(as.matrix(dist_jaccard))
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",main="PCO_jaccard 1,2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_jaccard))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels=rownames(as.matrix(dist_jaccard)),cex=.6)

plot(x, z, xlab = "Coordinate 1", ylab = "Coordinate 3",main="PCO_jaccard 1,3",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_jaccard))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], z[i], x[w1], z[w1])
}
text(x, y, labels=rownames(as.matrix(dist_jaccard)),cex=.6)

plot(y, z, xlab = "Coordinate 2", ylab = "Coordinate 3",main="PCO_jaccard 2,3",
     xlim = range(y)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_jaccard))) {
  w1 <- which(st[i, ] == 1)
  segments(y[i], z[i], y[w1], z[w1])
}
text(y, z, labels=rownames(as.matrix(dist_jaccard)),cex=.6)

plot(st)

##PCO_pearson####
fit <- cmdscale(dist_pearson,eig=TRUE, k=3) # k is the number of dim

x <- fit$points[,1]
y <- fit$points[,2]
z <- fit$points[,3]
plot(x,y, xlab="Coordinate 1", ylab="Coordinate 2",col=rownames(dist_pearson),main="PCO 1,2")
text(x, y, labels=colnames(as.matrix(dist_pearson)),cex=.6)
plot(x,z, xlab="Coordinate 1", ylab="Coordinate 3",main="PCO 1,3",col=rownames(dist_pearson))
text(x, z, labels=colnames(as.matrix(dist_pearson)),cex=.6)
plot(y,z, xlab="Coordinate 2", ylab="Coordinate 3",col=rownames(dist_pearson),main="PCO 2,3")
text(y,z, labels=colnames(as.matrix(dist_pearson)),cex=.6)


library(scatterplot3d)
scatterplot3d(x,y,z, main="3D Scatterplot PCO")

# PCO SPINNING TREE
library(ape)
st <- mst(as.matrix(dist_pearson))
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",main="PCO_pearson 1,2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_pearson))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels=rownames(dist_pearson),cex=.7)

plot(x, z, xlab = "Coordinate 1", ylab = "Coordinate 3",main="PCO_pearson 1,3",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_pearson))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], z[i], x[w1], z[w1])
}
text(x, z, labels=rownames(dist_pearson),cex=.7)

plot(y, z, xlab = "Coordinate 2", ylab = "Coordinate 3",main="PCO_pearson 2,3",
     xlim = range(y)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_pearson))) {
  w1 <- which(st[i, ] == 1)
  segments(y[i], z[i], y[w1], z[w1])
}
text(y, z, labels=rownames(dist_pearson),cex=.7)

plot(st)


##NMDS_jaccard####
library(MASS)
sm.sh<-Shepard(dist_jaccard,fit$points)# show the data is linear
plot(sm.sh, pch = ".")
lines(sm.sh$x, sm.sh$yf, type = "S")

library(rgl)
plot3d(x,y,z, col="red", size=3)

sm.iso<-isoMDS(abs(dist_jaccard)+0.0001,k=3)
#$stress
#22.78809
x <- sm.iso$points[,1]
y <- sm.iso$points[,2]
z <- sm.iso$points[,3]
plot(x,y, xlab="Coordinate 1", ylab="Coordinate 2",type="n",main="NMS_jaccard 1,2")
text(x, y, labels=colnames(as.matrix(dist_jaccard)),cex=.6)
plot(x,z, xlab="Coordinate 1", ylab="Coordinate 3",main="NMS_jaccard 1,3",type="n")
text(x, z, labels=colnames(as.matrix(dist_jaccard)),cex=.6)
plot(y,z, xlab="Coordinate 2", ylab="Coordinate 3",type="n",main="NMS_jaccard 2,3")
text(y,z, labels=colnames(as.matrix(dist_jaccard)),cex=.6)

st <- mst(as.matrix(dist_jaccard))
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",main="NMS_jaccard 1,2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_jaccard))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels=rownames(as.matrix(dist_jaccard)),cex=.6)

plot(x, z, xlab = "Coordinate 1", ylab = "Coordinate 3",main="NMS_jaccard 1,3",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_jaccard))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], z[i], x[w1], z[w1])
}
text(x, y, labels=rownames(as.matrix(dist_jaccard)),cex=.6)

plot(y, z, xlab = "Coordinate 2", ylab = "Coordinate 3",main="NMS_jaccard 2,3",
     xlim = range(y)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_jaccard))) {
  w1 <- which(st[i, ] == 1)
  segments(y[i], z[i], y[w1], z[w1])
}
text(y, z, labels=rownames(as.matrix(dist_jaccard)),cex=.6)
plot(st)

##NMDS_Pearson####
library(MASS)
sm.iso<-isoMDS(abs(as.dist(dist_pearson))+0.0001,k=3)
#$stress
#3.15079
x <- sm.iso$points[,1]
y <- sm.iso$points[,2]
z <- sm.iso$points[,3]
plot(x,y, xlab="Coordinate 1", ylab="Coordinate 2",type="n",main="NMS_pearson 1,2")
text(x, y, labels=rownames(dist_pearson),cex=.6)
plot(x,z, xlab="Coordinate 1", ylab="Coordinate 3",main="NMS_pearson 1,3",type="n")
text(x, z, labels=rownames(dist_pearson),cex=.6)
plot(y,z, xlab="Coordinate 2", ylab="Coordinate 3",type="n",main="NMS_pearson 2,3")
text(y,z, labels=rownames(dist_pearson),cex=.6)

st <- mst(as.matrix(dist_pearson))
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",main="NMS_pearson 1,2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_pearson))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels=rownames(dist_pearson),cex=.6)

plot(x, z, xlab = "Coordinate 1", ylab = "Coordinate 3",main="NMS_pearson 1,3",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_pearson))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], z[i], x[w1], z[w1])
}
text(x, z, labels=rownames(dist_pearson),cex=.6)

plot(y, z, xlab = "Coordinate 2", ylab = "Coordinate 3",main="NMS_pearson2,3",
     xlim = range(y)*1.2, type = "n")
for (i in 1:nrow(as.matrix(dist_pearson))) {
  w1 <- which(st[i, ] == 1)
  segments(y[i], z[i], y[w1], z[w1])
}
text(y, z, labels=rownames(dist_pearson),cex=.6)













ord<-metaMDS(smdata,distance="jaccard",k=3);
ord1<-decorana(smdata);
stressplot(ord)
#Large scatter around the line suggests that original dissimilarities are not well preserved in the reduced number of dimensions
plot(ord)
#communities("sites/observation",open circles),species/variables(red crosses)
plot(ord, type = "n")
points(ord, display = "sites", cex = 0.8, pch=21, col="red", bg="yellow")
text(ord, display = "spec", cex=0.7, col="blue")



