# Lattice Examples
library(lattice)

data<-read.table("SPR.txt",header=TRUE)

data$merged_Det_Ca<-paste(data$DetStock,data$CaStock)
#View(data)


# xyplot(Response~EnzymeConc|Enzyme, data=data, groups=merged_Det_Ca,
#       auto.key=TRUE, pch=1, col=c("black", "green", "red", "blue"))


xyplot(Response~EnzymeConc|Enzyme, data=data, groups=merged_Det_Ca,
       auto.key=list(space="top", columns=4, cex.title=1,
                     points=FALSE, col=c("black", "green", "red", "blue")), pch=19, col=c("black", "green", "red", "blue"))





