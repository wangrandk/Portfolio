
###############################################
## Day 2: Example: Nuclear
###############################################
###
nuc<-read.table("nuclear.txt",header=TRUE)
summary(nuc)
pairs(nuc)
pairs(nuc,panel=panel.smooth)
lm1<-lm(Cost~Date,nuc)
summary(lm1)
par(mfrow=c(2,2))
plot(lm1)

lm2<-lm(Cost~MWatts+Date,nuc)
lm2<-lm(Cost~.,nuc)  #. = "all that is left"
summary(lm2,cor=TRUE)
par(mfrow=c(2,2))
plot(lm2)

lm2<-lm(Cost~I(MWatts-750)+I(Date-69.5),nuc)
summary(lm2,cor=TRUE)

lm2<-lm(Cost~I(MWatts-825)+I(Date-68.5),nuc)
summary(lm2,cor=TRUE)

# sqrt
lm2b<-lm(sqrt(Cost)~.,nuc)
plot(lm2b)
summary(lm2b)
lm2b<-lm(log(Cost)~.,nuc[-26,])
summary(lm2b)
plot(lm2b)

lm2<-lm(MWatts~.,nuc)
summary(lm2)

##interactions####
lm2<-lm(Cost~MWatts*Date,nuc)
summary(lm2)


