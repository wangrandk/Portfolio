
#### ANALYSIS OF WEATHER PART 1 ########################################################################################
rm(list = ls(all = TRUE))
Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","C")
Weather <- read.table("C:/Users/Kasper/Dropbox/Applied Statistics/Case2/case2regionsOnePerBatch.txt",header=T)
Weather$year <- as.factor(Weather$year)
# make a nice table from summary
summary(Weather)
View(Weather)
#Bar plot ofNumerbs of slaughters pr year. Not very nice but works.
## PLOT 1 #############################################################################################################
# into each year:
Weather1998 <- Weather[which(Weather$year=="1998"),]
Weather1999 <- Weather[which(Weather$year=="1999"),]
Weather2000 <- Weather[which(Weather$year=="2000"),]
Weather2001 <- Weather[which(Weather$year=="2001"),]
Weather2002 <- Weather[which(Weather$year=="2002"),]
Weather2003 <- Weather[which(Weather$year=="2003"),]
Weather2004 <- Weather[which(Weather$year=="2004"),]
Weather2005 <- Weather[which(Weather$year=="2005"),]
Weather2006 <- Weather[which(Weather$year=="2006"),]
Weather2007 <- Weather[which(Weather$year=="2007"),]
Weather2008 <- Weather[which(Weather$year=="2008"),]
#make a vector with the totals of each year:
total<- cbind(sum(Weather1998$total),
                sum(Weather1999$total),
                sum(Weather2000$total),
                sum(Weather2001$total),
                sum(Weather2002$total),
                sum(Weather2003$total),
                sum(Weather2004$total),
                sum(Weather2005$total),
                sum(Weather2006$total),
                sum(Weather2007$total),
                sum(Weather2008$total))
#make a vector with with pos of each year:
pos <- cbind(sum(Weather1998$pos),
             sum(Weather1999$pos),
             sum(Weather2000$pos),
             sum(Weather2001$pos),
             sum(Weather2002$pos),
             sum(Weather2003$pos),
             sum(Weather2004$pos),
             sum(Weather2005$pos),
             sum(Weather2006$pos),
             sum(Weather2007$pos),
             sum(Weather2008$pos))
# combine the vectors:
total_pos <- rbind(total,pos)
#plot the matrix:
barplot(total_pos,main="Number of slaughters pr.year",xlab="Year",col=c("darkblue","red"),beside=TRUE,
        names.arg=c("1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"))

## proportion variable:
Weather$Prop <- Weather$pos/Weather$total
## plot 2 ##########################################################################################################################
plot(~Prop+aveTemp+maxTemp+relHum+sunHours+precip,data=Weather,panel=panel.smooth)

## GAM PLOT 3 ##############################################################################################################
library(mgcv)
par(mfrow=c(2,3))
Gam_model<-gam(Prop~s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=Weather)
plot(Gam_model)


  ## BOXPLOT OF REGIONS PLOT 4 #####################################################################################
par(mfrow=c(1,1))
Prop_1 <- Weather$R1pos/Weather$R1total
Prop_2 <- Weather$R2pos/Weather$R2total
Prop_3 <- Weather$R3pos/Weather$R3total
Prop_4 <- Weather$R4pos/Weather$R4total
Prop_5 <- Weather$R5pos/Weather$R5total
Prop_6 <- Weather$R6pos/Weather$R6total
Prop_7 <- Weather$R7pos/Weather$R7total
Prop_8 <- Weather$R8pos/Weather$R8total

boxplot(Prop_1,Prop_2,Prop_3,Prop_4,Prop_5,Prop_6,Prop_7,Prop_8,
        main="Proportion of positive broils pr. region")




#### MANIPULATE THE REGIONS #######################################################################################
#clima <- Weather
#X <- clima[,1:7] ## Climatic data
#totalR <- as.numeric(as.matrix(clima[,18:25])) ## All the totals
#posR <- as.numeric(as.matrix(clima[,10:17])) ## All the positive
# Merging it all together :
#dat <- data.frame(X,totalR=totalR,posR=posR,region=factor(paste("R",rep(1:8,each=nrow(X)),sep="")))
#View(dat)
########### DATA EXCLUDED ##########################################################################################
#exclude relHum = 0. 
Weather_1 <- Weather[-c(274,275),]
Weather_2 <- Weather_1[!is.na(Weather_1$relHum),]
Weather_3 <- Weather_2[!is.na(Weather_2$sunHours),]
################## MODEL ########################################################################################
par(mfrow=c(3,3))
lm1 <- lm(Prop~(aveTemp+maxTemp+relHum+sunHours+precip),data=Weather_3)

lm2 <- lm(Prop~(aveTemp+(pwl(aveTemp,11.25))+maxTemp+relHum+sunHours+precip),data=Weather_3)
plot(lm2)
Gam_model_1<-gam(Prop~(s(aveTemp)+s(pwl(aveTemp,11.25))+s(maxTemp)+s(relHum)+s(sunHours)+s(precip)),data=Weather_3)
plot(Gam_model_1)

Gam_model_2<-gam(Prop~(s(aveTemp)+s(pwl(aveTemp,11.25))+s(I(maxTemp^2))+s(relHum)+s(sunHours)+s(precip)),data=Weather_3)
        plot(Gam_model_2)       
         
Gam_model_3<-gam(Prop~(s(aveTemp)+s(pwl(aveTemp,11.25))+s(I(maxTemp^2))+s(relHum)+s(sunHours)+s(pwl(sunHours,41))+s(precip)),data=Weather_3)
plot(Gam_model_3)       

lm3 <- lm(Prop~(aveTemp+(pwl(aveTemp,11.25))+(I(maxTemp^2))+(relHum)+(sunHours)+(pwl(sunHours,41))+(precip)),data=Weather_3)
par(mfrow=c(2,2))
plot(lm3)
################################# ##########PLOT OF RESIDUALS ################################################################
gam.check(Gam_model_3)
###########################################################################################################################
lm4 <- lm(Prop~(sunHours+I(sunHours^2)+I(sunHours^3)+relHum+maxTemp+I(maxTemp^2)+aveTemp+I(aveTemp^2)+precip+I(precip^2)+I(precip^3)),data=Weather_3)
plot(lm4)

lm5 <- step(lm4)
summary(lm5)
drop1(lm5 <- update(lm4,~. - precip),test="F")

plot(lm5)


##########################   PREDICTION INTERVAL  ###########################################################################

pred.data <- data.frame(AveTemp_seq=seq(0,100,length=100))
pred.int<-predict(lm2,int="prediction",newdata=pred.data)

summary(lm4)
plot(Prop~aveTemp,Weather_3, ylim=c(0,1),main="Prediction AveTemp")
pred.x <- pred.data$AveTemp_seq
matlines(pred.x, pred.int, lty=c(1,2,2), col="black")
conf.int<-predict(model.long.jump, int="confidence", newdata=pred.data)
matlines(pred.x, conf.int, lty=c(1,2,2), col="red")

########################################################################################################################

plot(~Prop+I(aveTemp^2)+I(maxTemp^2)+relHum+I(sunHours)+precip,data=Weather_3,panel=panel.smooth)

Gam_model<-gam(Prop~s(aveTemp)+s(maxTemp)+s(relHum)+s(sunHours)+s(precip),data=Weather)
plot(Gam_model)

plot(sqrt(Weather_3$Prop)~Weather_3$aveTemp)
summary(lm1)
par(mfrow=c(2,2))
plot(lm1)
lm2 <- step(lm1)
2
summary(lm2)
lm1


pwl<-function(x,x0){
  ## x is data
  ## x0 is cut off
  ## The associated estimated parameter is for x > x0
  return( (x > x0) * (x-x0) )
}
## ANALYSIS OF REGION PART 2 ##############################################################################################
rm(list = ls(all = TRUE))
Weather <- read.table("C:/Users/Kasper/Dropbox/Applied Statistics/Case2/case2regionsOnePerBatch.txt",header=T)
Weather$year <- as.factor(Weather$year)
Weather$Prop <- Weather$pos/Weather$total
#save the sum Neg and Pos for each region in matrix:
pos1 <- sum(Weather$R1pos)
pos2 <- sum(Weather$R2pos)
pos3 <- sum(Weather$R3pos)
pos4 <- sum(Weather$R4pos)
pos5 <- sum(Weather$R5pos)
pos6 <- sum(Weather$R6pos)
pos7 <- sum(Weather$R7pos)
pos8 <- sum(Weather$R8pos)

matrix(colSums(Weather[,10:25]),nrow=2)

Region_Pos <- c(pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8)

Region_Neg <- c((sum(Weather$R1total)-pos1),
                      (sum(Weather$R2total)-pos2),
                      (sum(Weather$R3total)-pos3),
                      (sum(Weather$R4total)-pos4),
                      (sum(Weather$R5total)-pos5),
                      (sum(Weather$R6total)-pos6),
                      (sum(Weather$R7total)-pos7),
                      (sum(Weather$R8total)-pos8))
sum(Region_Neg)+sum(Region_Pos)

Region_NP <- cbind(Region_Pos,Region_Neg)
View(Region_NP)
names(Region_NP)
rownames(Region_NP) <- c("Reg1","Reg2","Reg3","Reg4","Reg5","Reg6","Reg7","Reg8")
colnames(Region_NP) <- c("POS","NEG")
View(Region_NP)
chisq.test(Region_NP,correct=FALSE) # significant difference between the regions. 
mosaicplot(as.table(Region_NP),shade=TRUE)

sum(Region_Neg)+sum(Region_Pos)
sum(Weather$total)
