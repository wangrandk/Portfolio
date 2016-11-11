rm(list = ls(all = TRUE))
par(mfrow=c(1,1))
#data <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/SPR.txt",header=T)
data<-read.table("SPR.txt",header=TRUE)


#include additional rows in data
data$Sqrt.response <- sqrt(data$Response)
data$Sqrt.EnzymeConc <- sqrt(data$EnzymeConc)
data$merged_Det_Ca<-paste(data$DetStock,data$CaStock)



xyplot(Sqrt.response~Sqrt.EnzymeConc|Enzyme, data=data, groups=merged_Det_Ca, type = c("p", "r"),
       auto.key=list(space="top", columns=4, cex.title=1,
                     points=FALSE, col=c("black", "green", "red", "blue")), pch=19, col=c("black", "green", "red", "blue"))



