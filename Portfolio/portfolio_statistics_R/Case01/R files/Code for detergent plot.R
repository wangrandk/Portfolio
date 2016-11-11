rm(list = ls(all = TRUE))
par(mfrow=c(1,1))
data <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/SPR.txt",header=T)
data$Sqrt.response <- sqrt(data$Response)
data$Sqrt.EnzymeConc <- sqrt(data$EnzymeConc)


WithDet <-data[which(data$DetStock=="Det+"),]
WithoutDet <- data[which(data$DetStock=="Det0"),]


plot(WithDet$EnzymeConc,WithDet$Sqrt.response,xlab="Concentration",ylab="Sqrt.Response",col="green",type="p",main="concentration with or without Detergent",pch=19)
points(WithoutDet$EnzymeConc,WithoutDet$Sqrt.response,col="red",type="p",pch=19)


plot(WithDet$Sqrt.EnzymeConc,WithDet$Sqrt.response,xlab="Sqrt.Concentration",ylab="Sqrt.Response",col="green",type="p",ylim=c(0,50),main="concentration with our without Detergent",pch=19)
points(WithoutDet$Sqrt.EnzymeConc,WithoutDet$Sqrt.response,col="red",type="p",pch=19)

# Point 147 #####################################################################################################
data[c(139,147),]
data[data$Enzyme=="E" & data$EnzymeConc==2.5 & data$DetStock == "Det+",]



