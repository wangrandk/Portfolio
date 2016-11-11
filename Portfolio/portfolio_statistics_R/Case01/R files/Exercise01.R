SPR<-read.table("C:/Users/RAN/OneDrive/books/Applied stat/Handin/SPR.txt",header=T)
summary(SPR)
str(SPR)
pairs(SPR)
SPR$lResponse<-log(SPR$Response)
SPR$sqrtResponse<-sqrt(SPR$Response)
View(SPR)
## first model####
lm3<-lm(sqrtResponse~ Enzyme * DetStock * CaStock * EnzymeConc,SPR)
summary(lm3)
lm4<-step(lm3)
drop1(lm4,test="F")
lm5<-update(lm4,~.-Enzyme:CaStock)
summary(lm5)
lm6<-step(lm5)
summary(lm6)
drop1(lm6,test="F")
lm7<-update(lm6,~.-DetStock:CaStock:EnzymeConc)
summary(lm7)
lm8<-step(lm7)
drop1(lm8,test="F")
lm9<-update(lm8,~.-Enzyme:DetStock )
summary(lm9)
lm10<-step(lm9)
summary(lm10)
drop1(lm10,test="F")
lm11<-update(lm10,~.-CaStock:EnzymeConc)
summary(lm11)
drop1(lm11,test="F")
lm12<-update(lm11,~.-CaStock )
summary(lm12)
drop1(lm12,test="F")
lm13<-update(lm12,~.-Enzyme:EnzymeConc)
summary(lm13)

par(mfrow=c(2,2))
plot(lm13,col=as.numeric(factor(SPR$EnzymeConc)))
anova(lm13,lm10)


## 2nd Model####
SPR$sqrtResponse<-sqrt(SPR$Response)
SPR$sqrtEnzymeConc<-sqrt(SPR$EnzymeConc) 

##minus 147 model1 from every variables included reduced to the final####
SPR[-147,]
lm3<-lm(sqrtResponse~ Cycle + Enzyme * DetStock * CaStock * sqrtEnzymeConc,SPR[-147,])
summary(lm3)
plot(lm3)
lm4<-step(lm3)
drop1(lm4,test="F")
lm5<-update(lm4,~.-Enzyme:CaStock:sqrtEnzymeConc)
summary(lm5)
lm6<-step(lm5)
summary(lm6)
lm9<-update(lm6,~.-DetStock:CaStock:sqrtEnzymeConc)
summary(lm9)
lm10<-step(lm9)
summary(lm10)
lm11<-update(lm10,~.- Enzyme:CaStock)
summary(lm11)
lm12<-step(lm11)
lm13<-update(lm12,~.- CaStock:sqrtEnzymeConc )
summary(lm13)
lm14<-step(lm13)
lm15<-update(lm14,~.-Enzyme:DetStock)
summary(lm15)
lm16<-step(lm15)
lm17<-update(lm16,~.-Enzyme:sqrtEnzymeConc)
summary(lm17)
anova(lm17)

##################### 3D graph###########################################################
coef(lm13)
SPR$EnzymeConc<-as.factor(SPR$EnzymeConc)
pred.data<-expand.grid(Enzyme=levels(SPR$Enzyme),EnzymeConc=levels(SPR$EnzymeConc),DetStock=levels(SPR$DetStock))
pred.data$Response<-predict(lm13,newdata=pred.data) 
head(pred.data)
library(lattice) ## A flexible graphics package including many nice functions
wireframe(Response~Enzyme * EnzymeConc | DetStock,pred.data,scales = list(arrows = FALSE))
wireframe(Response~Enzyme * EnzymeConc | DetStock,pred.data,groups=as.numeric(pred.data$DetStock), scales = list(arrows = FALSE), drape=TRUE,colorkey=TRUE)

wireframe(Response~Enzyme * DetStock|EnzymeConc ,pred.data,groups=as.numeric(pred.data$EnzymeConc), scales = list(arrows = FALSE), drape=TRUE,colorkey=TRUE)

wireframe(Response~ DetStock*EnzymeConc |Enzyme  ,pred.data,groups=as.numeric(pred.data$Enzyme), scales = list(arrows = FALSE), drape=TRUE,colorkey=TRUE)

# SPR$EnzymeConc<-as.numeric(SPR$EnzymeConc)
SPR$sqrtEnzymeConc<-sqrt(SPR$EnzymeConc)

##############2D graph###################################################################
model<-lm(formula = sqrtResponse ~ (Enzyme + DetStock + sqrtEnzymeConc)^3, data = SPR)
summary(model)
## uncertianty: Response~ Enzyme+EnzymeConc|Det+ #### mat.height=seq(151,185,2)
pred.en<-expand.grid(Enzyme=levels(SPR$Enzyme),EnzymeConc=levels(SPR$EnzymeConc),DetStock="Det0")
pred<-predict(lm17,newdata=pred.en,interval="c")^2 
summary(pred)
par(mfrow=c(1,1)) #c(0,2.5,7.5,15)
matplot(c(0,2.5,7.5,15)[as.numeric(pred.en$EnzymeConc)],pred,type="n",ylim=c(0,1800),xlab="EnzymeConc", ylab="Response Prediction",main="Prediction of response")
matlines(c(0,2.5,7.5,15), matrix(pred[,1],nrow=4,byrow=TRUE),col=2:6,lty=rep(c(1,2,2),each=5),lwd=2)
legend("topleft",legend=levels(SPR$Enzyme),lty=1,col=2:6,title = "Det+")

# Barplot: response~Enzyme+EnzymeConc |Det+##
library(Hmisc)
barplot(matrix(pred[,1],nrow=5,dimnames=dn),beside=TRUE,col=2:6,legend.text=TRUE,args.legend=list(x="topleft"),main="95% confidence interval for Det+",ylab="Response",xlab="Enzyme concentration",ylim=c(0,max(pred)))
errbar((1:23)[-c(1:3)*6]+0.5,y=pred[,1],yminus=pred[,2],yplus=pred[,3],add=TRUE,pch=NA)

#########################################################################################
## uncertianty: Response~ Enzyme+EnzymeConc|Det0 ####
pred.en<-expand.grid(Enzyme=levels(SPR$Enzyme),EnzymeConc=levels(SPR$EnzymeConc),DetStock="Det0")
pred<-predict(lm13,newdata=pred.en,interval="c")^2 
par(mfrow=c(1,1))
matplot(c(0,2.5,7.5,15)[as.numeric(pred.en$EnzymeConc)],pred,type="n",ylim=range(pred))
# matlines(c(0,2.5,7.5,15), cbind(matrix(pred[,1],nrow=4,byrow=TRUE),matrix(pred[,2],nrow=4,byrow=TRUE),matrix(pred[,3],nrow=4,byrow=TRUE)),col=2:6,lty=rep(c(1,2,2),each=5),lwd=2)
# legend("topleft",legend=levels(SPR$Enzyme),lty=1,col=2:6)

matplot(c(0,2.5,7.5,15)[as.numeric(pred.en$EnzymeConc)],pred,type="n",ylim=range(pred),xlab="EnzymeConc", ylab="Response Prediction",main="Prediction of response Det0")
matlines(c(0,2.5,7.5,15), matrix(pred[,1],nrow=4,byrow=TRUE),col=2:6,lty=rep(c(2,2,2),each=5),lwd=2)
legend("topright",legend=levels(SPR$Enzyme),lty=2,col=2:6,title = "Det0")

# Barplot: response~Enzyme+EnzymeConc |Det0
dn<-list(Enzyme=levels(SPR$Enzyme),EnzymeConc=levels(SPR$EnzymeConc)) #Dimnames
barplot(matrix(pred[,3],nrow=5,dimnames=dn),beside=TRUE,col=2:6,legend.text=TRUE,args.legend=list(x="topleft"),main="95% confidence interval for Det0",ylab="Response",xlab="Enzyme concentration")
barplot(matrix(pred[,1],nrow=5,dimnames=dn),beside=TRUE,col=2:6,add=TRUE)
barplot(matrix(pred[,2],nrow=5,dimnames=dn),beside=TRUE,col=0,add=TRUE)
