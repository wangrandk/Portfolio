## Classical MDS####
# N rows (objects) x p columns (variables)
# each row identified by a unique row name,stress majorization
#Takes an input matrix giving dissimilarities between pairs of items and outputs a coordinate matrix whose configuration minimizes a loss function called strain.
mydata <- swiss[-1]
View(mydata)
d <- dist(mydata) # euclidean distances between the rows
fit <- cmdscale(d,eig=TRUE, k=2) # k is the number of dim
fit # view results

# plot solution
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Metric MDS", type="n")
text(x, y, labels = row.names(mydata), cex=.7)

## Nonmetric MDS####
# N rows (objects) x p columns (variables)
# each row identified by a unique row name, using isotonic regression, smallest space analysis (SSA) 
library(MASS)
d <- dist(mydata)# euclidean distances between the rows
fit <- isoMDS(d, k=2) # k is the number of dim
fit
# plot solution
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Nonmetric MDS", type="n")
text(x, y, labels = row.names(mydata), cex=.7)

##Example from Wehren's book####
library(ChemometricsWithRData, warn.conflicts=FALSE, quietly = TRUE)
# First metric:
data(wines)
wines.dist <- dist(scale(wines))
wines.cmdscale <- cmdscale(wines.dist)
plot(wines.cmdscale, pch = wine.classes, col = wine.classes,
     main ="Principal Coordinate Analysis",
     xlab = "Coord 1", ylab = "Coord 2")

# Then Non- metric with Sammon's method:
wines.sammon <- sammon(wines.dist)

wines.sammon <- sammon(wines.dist, magic = .00003)

plot(wines.sammon$points, main = "Sammon mapping",
     col = wine.classes, pch = wine.classes,
     xlab = "Coord 1", ylab = "Coord 2")

# Then Non- metric with Kruskal's method:
wines.isoMDS <- isoMDS(wines.dist)

plot(wines.isoMDS$points, main = "Non-metric MDS",
     col = wine.classes, pch = wine.classes,
     xlab = "Coord 1", ylab = "Coord 2")


##minimum spanning tree-mst####
# Minimum spanning tree
library(ape)
x <- wines.isoMDS$points[,1]
y <- wines.isoMDS$points[,2]
st <- mst(as.matrix(wines.dist))
plot(x, y, xlab = "Coordinate 1", ylab = "Coordinate 2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(wines.dist))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i], y[i], x[w1], y[w1])
}
text(x, y, labels=colnames(as.matrix(wines.dist)))
plot(st)

## The Shepard diagram-Kruskal's Non-metric####
mydata <- swiss[-1]
swiss.dist <- dist(mydata) # euclidean distances between the rows
swiss.mds <- cmdscale(d, k=2)
swiss.sh <- Shepard(swiss.dist, swiss.mds$points, k = 2)# show the data is linear
plot(swiss.sh, pch = ".")
lines(swiss.sh$x, swiss.sh$yf, type = "S")

