##Distances between cities on Sealand####
rm(list=ls())
mydata<-read.table("sjaelland.txt",fill = TRUE, header = T)
Sealand_dist <- as.dist(mydata)


fit <- cmdscale(Sealand_dist,eig=TRUE, k=2) # k is the number of dim
y <- fit$points[,1]
x <- fit$points[,2]
plot(x, -y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Metric MDS", type="n")
text(x, -y, labels = colnames(mydata), cex=.7)

 
##minimum spanning tree-mst####
# Minimum spanning tree
library(ape)
st <- mst(as.matrix(Sealand_dist))
plot(x, -y, xlab = "Coordinate 1", ylab = "Coordinate 2",
     xlim = range(x)*1.2, type = "n")
for (i in 1:nrow(as.matrix(Sealand_dist))) {
  w1 <- which(st[i, ] == 1)
  segments(x[i],-y[i], x[w1], -y[w1])
}
text(x, -y, labels=colnames(mydata), cex=.6)
plot(st)
# c. MST gives good idea of how to make railway, as minimum trees has to reach each city with the shortest path.


