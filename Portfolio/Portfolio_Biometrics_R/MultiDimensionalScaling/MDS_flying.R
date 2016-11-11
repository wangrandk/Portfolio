## Flying times####
rm(list=ls())
#PCO
mydata<-read.table("flying.txt", fill = TRUE, header = T)
Sealand_dist <- as.dist(mydata)
fit <- cmdscale(Sealand_dist,eig=TRUE, k=2,x.ret = T)
x <- fit$points[,1]
y <- fit$points[,2]

plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Metric MDS", type="n")
text(x, y, labels = colnames(mydata), cex=.7)

#NMS
library(MASS)
d <- as.dist(mydata)# euclidean distances between the rows
fit <- isoMDS(d, k=2) # k is the number of dim
fit
# plot solution
x <- fit$points[,1]
y <- fit$points[,2]
win.metafile('NMS_flying.wmf')
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Nonmetric MDS", type="n")
text(x, y, labels = colnames(mydata), cex=.7)
dev.off()
##Example from Wehren's book####
library(ChemometricsWithRData, warn.conflicts=FALSE, quietly = TRUE)
# First metric:
data(mydata)
mydata.dist <- as.dist((mydata))
mydata.cmdscale <- cmdscale(mydata.dist)
plot(mydata.cmdscale, main ="Principal Coordinate Analysis",
     xlab = "Coord 1", ylab = "Coord 2",type="n")
text(mydata.cmdscale, labels = colnames(mydata), cex=.7)

# Then Non- metric with Sammon's method:
mydata.sammon <- sammon(mydata.dist)

mydata.sammon <- sammon(mydata.dist, magic = .00003)

plot(mydata.sammon$points, main = "Sammon mapping",
     xlab = "Coord 1", ylab = "Coord 2", type="n")
text(mydata.cmdscale, labels = colnames(mydata), cex=.7)
# Then Non- metric with Kruskal's method:
mydata.isoMDS <- isoMDS(mydata.dist)

plot(mydata.isoMDS$points, main = "Non-metric MDS",
     xlab = "Coord 1", ylab = "Coord 2",type="n")
text(mydata.cmdscale, labels = colnames(mydata), cex=.7)
#initial  value 5.726289 
#iter   5 value 3.329442
#final  value 2.835320 
#converged
#MST
library(ape)
x <- mydata.isoMDS$points[,1]
y <- mydata.isoMDS$points[,2]
st <- mst(as.matrix(mydata.dist))

plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(mydata.dist))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels=colnames(as.matrix(mydata.dist)))
plot(st)



