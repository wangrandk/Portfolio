#include lattice
library(lattice)

#read the data
SPR<-read.table("SPR.txt",header=TRUE)

SPR<-SPR[SPR$Enzyme=="E",]
SPR<-SPR[SPR$DetStock=="Det+",]
#SPR<-SPR[SPR$EnzymeConc == 2.5,]

dat<-SPR


##sqrt variables####
dat$sqrtResponse<-sqrt(dat$Response)
dat$sqrtEnzymeConc<-sqrt(dat$EnzymeConc)


# ##nonsqrt variables####
# dat$sqrtResponse<-dat$Response
# dat$sqrtEnzymeConc<-dat$EnzymeConc

# #creates very simple linear model
# lm1<-lm(sqrtResponse~sqrtEnzymeConc,data=dat)


#from Christopher Larsen
#datCa0Det0 = dat[dat$DetStock == "Det0" & dat$CaStock == "Ca0",]
#dat_pred = datCa0Det0

#dat_pred = dat_pred[order(dat_pred$EnzymeConc),]


#order because of something
dat = dat[order(dat$EnzymeConc),]




plot(sqrtResponse~sqrtEnzymeConc,dat,ylim=c(-10,50), pch=19,main="Enzime E, Det+",
     col=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1))

lmA = lm(sqrtResponse~sqrtEnzymeConc,dat)
summary(lmA)

pred<-predict(lmA,interval="predict",newdata=data.frame(dat))
conf<-predict(lmA,interval="conf",newdata=data.frame(dat))


matlines(dat$sqrtEnzymeConc,pred,col=3 ,lwd=2) 

#matlines(dat$sqrtEnzymeConc,pred,lty=c(1,2,2),col=1)

#matlines(dat$sqrtEnzymeConc,conf,lty=c(1,2,2),col=1,lwd=2) 

