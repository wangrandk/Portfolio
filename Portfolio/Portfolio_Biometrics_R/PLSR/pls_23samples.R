rm(list=ls())
pectin<-read.table("Pectin_and_DE.txt",header=T,sep=";",dec=",")
pectin$NIR<-as.matrix(pectin[,-1])
length(pectin$DE)
summary(pectin)
pectin$train <-TRUE
pectin$train[sample(1:length(pectin$DE),23)]<- FALSE
pectin_TEST <- pectin[pectin$train==FALSE,]
pectin_TRAIN <- pectin[pectin$train==TRUE,]

#1. Explore the data
##2. Model the data, first PCR####
Mpcr<-pcr(DE~NIR,ncomp =30,data=pectin_TRAIN,validation="LOO",scale=T,jackknife=T )
par(mfrow=c(2,2))
plot(Mpcr,labels=rownames(pectin_TRAIN),which="validation")
plot(Mpcr,"validation",estimate=c("train","CV"),legendpos="topright")
plot(Mpcr,"validation",estimate=c("train","CV"),val.type="R2",legendpos="bottomright")
pls::scoreplot(Mpcr,labels=rownames(pectin))

##2.using pls1 (without segments)####
Mpls<-plsr(DE~NIR,ncomp=30,data=pectin_TRAIN,validation="LOO",scale=T,jackknife=T)
par(mfrow=c(2,2))
plot(Mpls,labels=rownames(pectin_TRAIN),which="validation")
plot(Mpls,"validation",estimate=c("train","CV"),legendpos="topright")
plot(Mpls,"validation",estimate=c("train","CV"),val.type="R2",legendpos="bottomright")
pls::scoreplot(Mpls,labels=rownames(pectin_TRAIN))

# Plot RMSE AND coefficients with uncertainty from Jacknife:(PCR),coMpare RMSEP FOR CHOOSING A NO. OF COMP,
par(mfrow=c(2, 2))
coefplot(Mpcr, ncomp =1,se.whiskers=TRUE,labels=prednames(pectin_TRAIN),cex.axis =0.5, main = "DE,PCR with 1")
coefplot(Mpcr, ncomp =2,se.whiskers=TRUE,labels=prednames(pectin_TRAIN),cex.axis = 0.5, main = "DE,PCR with 2")
coefplot(Mpcr, ncomp =20,se.whiskers=TRUE,labels=prednames(pectin_TRAIN),cex.axis =0.5, main="DE,PCR with 3")
coefplot(Mpls, ncomp= 10,se.whiskers=TRUE,labels=prednames(pectin_TRAIN),cex.axis = 0.5, ain = "DE,PLS with 2")
##   using pls1 (with segments)
Seg_pls<-plsr(DE~NIR,ncomp=30,data=pectin_TRAIN,validation="CV",segments=10,segment.type=c("random"),scale=T,jackknife=T)
par(mfrow=c(2,2))
plot(Seg_pls,labels=rownames(pectin_TRAIN),which="validation")
plot(Seg_pls,"validation",estimate=c("train","CV"),legendpos="topright")
plot(Seg_pls,"validation",estimate=c("train","CV"),val.type="R2",legendpos="bottomright")
##COMP IS 9
#   SCORE, Loadings, one by one
pls::scoreplot(Seg_pls,comp=1:3,labels=rownames(pectin))
par(mfrow=c(3,3))
pls::loadingplot(Seg_pls, comps = 1, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 2, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 3, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 4, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 5, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 6, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 7, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 8, scatter = F, labels = prednames(Seg_pls),)
pls::loadingplot(Seg_pls, comps = 9, scatter = F, labels = prednames(Seg_pls),)

##3. USING A PROPER NO.OF COMPFOR PLSR##
Mpls3<-plsr(DE~NIR,ncomp=9,data=pectin_TRAIN,validation="LOO",scale=TRUE,jackknife=TRUE)
#4. VALIDATE:predicted and  residual.
par(mfrow=c(2, 2))
obsfit<-predplot(Mpls3,labels=rownames(pectin_TRAIN),which="validation")
Residuals<-obsfit[,1]-obsfit[,2]
abline(lm(obsfit[,2]~obsfit[,1]),col=2)
plot(obsfit[,2], abs(Residuals), type = "n", xlab = "Fitted", ylab = "Residuals")
text(obsfit[,2], Residuals, labels = rownames(pectin_TRAIN))
qqnorm(Residuals)
#leverage of X and Hat matrix
Xf <- scores(Mpls3)
H <- Xf %*% solve(t(Xf) %*% Xf) %*% t(Xf)
leverage <- diag(H)
plot(leverage, abs(Residuals), type = "n", main = "3")
text(leverage, abs(Residuals), labels = rownames(pectin_TRAIN))

##4) "interpret/conclude"####
# Plot coefficients with uncertainty from Jacknife:
par(mfrow=c(2, 2))
obsfit<-predplot(Mpls3,labels=rownames(pectin_TRAIN),which="validation")
abline(lm(obsfit[,2]~obsfit[,1]),col=2)
plot(Mpls3, "validation", estimate = c("train", "CV"), val.type = "R2",
     legendpos = "bottomright")
coefplot(Mpls3, se.whiskers = TRUE, labels = prednames(Mpls3), cex.axis = 0.5)
biplot(Mpls3,var.axes = TRUE)

##5) predict the 4 data points from the TEST set:####
preds <- predict(Mpls3, newdata =pectin_TEST, ncomp = 9)
plot(pectin_TEST$DE, preds)
rmsep<-sqrt(mean(pectin_TEST$DE-preds)^2)
rmsep
# 3comp .84659
# 11COMP 0.121125
# 10comp  0.1344003
# 9COMP   0.01850639


