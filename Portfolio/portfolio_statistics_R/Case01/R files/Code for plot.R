rm(list = ls(all = TRUE))
data <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/SPR.txt",header=T)
#Setup data frames:
par(mfrow=c(3,3))
DataA_Det_Ca <-data[which(data$Enzyme=="A" & data$DetStock== "Det+" & data$CaStock=="Ca+"),]
DataA_Det <-data[which(data$Enzyme=="A" & data$DetStock== "Det+" & data$CaStock=="Ca0"),]
DataA_Ca <-data[which(data$Enzyme=="A" & data$DetStock== "Det0" & data$CaStock=="Ca+"),]
DataA <-data[which(data$Enzyme=="A" & data$DetStock== "Det0" & data$CaStock=="Ca0"),]

DataB_Det_Ca <-data[which(data$Enzyme=="B" & data$DetStock== "Det+" & data$CaStock=="Ca+"),]
DataB_Det <-data[which(data$Enzyme=="B" & data$DetStock== "Det+" & data$CaStock=="Ca0"),]
DataB_Ca <-data[which(data$Enzyme=="B" & data$DetStock== "Det0" & data$CaStock=="Ca+"),]
DataB <-data[which(data$Enzyme=="B" & data$DetStock== "Det0" & data$CaStock=="Ca0"),]
View(DataB)

DataC_Det_Ca <-data[which(data$Enzyme=="C" & data$DetStock== "Det+" & data$CaStock=="Ca+"),]
DataC_Det <-data[which(data$Enzyme=="C" & data$DetStock== "Det+" & data$CaStock=="Ca0"),]
DataC_Ca <-data[which(data$Enzyme=="C" & data$DetStock== "Det0" & data$CaStock=="Ca+"),]
DataC <-data[which(data$Enzyme=="C" & data$DetStock== "Det0" & data$CaStock=="Ca0"),]

DataD_Det_Ca <-data[which(data$Enzyme=="D" & data$DetStock== "Det+" & data$CaStock=="Ca+"),]
DataD_Det <-data[which(data$Enzyme=="D" & data$DetStock== "Det+" & data$CaStock=="Ca0"),]
DataD_Ca <-data[which(data$Enzyme=="D" & data$DetStock== "Det0" & data$CaStock=="Ca+"),]
DataD <-data[which(data$Enzyme=="D" & data$DetStock== "Det0" & data$CaStock=="Ca0"),]

DataE_Det_Ca <-data[which(data$Enzyme=="E" & data$DetStock== "Det+" & data$CaStock=="Ca+"),]
DataE_Det <-data[which(data$Enzyme=="E" & data$DetStock== "Det+" & data$CaStock=="Ca0"),]
DataE_Ca <-data[which(data$Enzyme=="E" & data$DetStock== "Det0" & data$CaStock=="Ca+"),]
DataE <-data[which(data$Enzyme=="E" & data$DetStock== "Det0" & data$CaStock=="Ca0"),]

#PLots:
#PLot A with different Detergent, Calcium levels 

plot(Response ~ EnzymeConc,data=DataA_Det_Ca,col="black",pch=18,main="Enzym A")
points(Response ~ EnzymeConc,data=DataA_Det,col="green",pch=18)
points(Response ~ EnzymeConc,data=DataA_Ca,col="red",pch=18)
points(Response ~ EnzymeConc,data=DataA,col="blue",pch=18)

#PLot B with different Detergent, Calcium levels 

plot(Response ~ EnzymeConc,data=DataB_Det_Ca,col="black",pch=18,main="Enzym B")
points(Response ~ EnzymeConc,data=DataB_Det,col="green",pch=18)
points(Response ~ EnzymeConc,data=DataB_Ca,col="red",pch=18)
points(Response ~ EnzymeConc,data=DataB,col="blue",pch=18)

#PLot C with different Detergent, Calcium levels 

plot(Response ~ EnzymeConc,data=DataC_Det_Ca,col="black",pch=18,ylim=c(0,1000),main="Enzym C")
points(Response ~ EnzymeConc,data=DataC_Det,col="green",pch=18)
points(Response ~ EnzymeConc,data=DataC_Ca,col="red",pch=18)
points(Response ~ EnzymeConc,data=DataC,col="blue",pch=18)

#PLot D with different Detergent, Calcium levels 

plot(Response ~ EnzymeConc,data=DataD_Det_Ca,col="black",pch=18,ylim=c(0,1000),main="Enzym D")
points(Response ~ EnzymeConc,data=DataD_Det,col="green",pch=18)
points(Response ~ EnzymeConc,data=DataD_Ca,col="red",pch=18)
points(Response ~ EnzymeConc,data=DataD,col="blue",pch=18)

#PLot E with different Detergent, Calcium levels 

plot(Response ~ EnzymeConc,data=DataE_Det_Ca,col="black",pch=18,ylim=c(0,1000),main = "Enzym E")
points(Response ~ EnzymeConc,data=DataE_Det,col="green",pch=18)
points(Response ~ EnzymeConc,data=DataE_Ca,col="red",pch=18)
points(Response ~ EnzymeConc,data=DataE,col="blue",pch=18)

plot(0,0,pch=18,ylim=c(0,50),main = "Legend",type="n")
legend("center",c("Det+ and Ca+", "Det+ Ca0", "Det0Ca+ ", "Det0Ca0"),c("black","green","red","blue"),cex=0.4)

