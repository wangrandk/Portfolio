rm(list=ls())
load(file="abalone.rda")
library(randomForest)
View(abalone)


#RF is the forest_object, randomForest is the algorithm, X & y the training data
x=abalone[,2:9]
y=abalone[,1]
RF = randomForest(x,y,
                  importance=TRUE, #extra diagnostics
                  keep.inbag=TRUE, #track of bootstrap process
                  ntree=500, #how many trees
                  replace=FALSE) #bootstrap with replacement?
print(RF)

#RF$predicted is the OOB-CV predictions
par(mfrow=c(1,2))
plot(RF$predicted,y,
     col="#12345678",
     main="prediction plot",
     xlab="predicted reponse",
     ylab="actual response")
mosaicplot(RF$confusion,shade=TRUE)



##variable importance
RF$importance

#short cut to plot variable importance
varImpPlot(RF)
RF$y

length(levels(RF$y))

#get packge from rForge. Maybe additional packages such trimTrees, mlbench, rgl and #must be installed firts.
#install.packages("forestFloor", repos="http://R-Forge.R-project.org")
library(forestFloor, warn.conflicts=FALSE, quietly = TRUE)
#the function forestFloor outputs a forestFloor-object, here called ff
abalone = abalone[abalone$sex!="I",]
X=abalone[,2:9]
Y=abalone[,1]

RF = randomForest(x=X,y=Y,
                  importance=TRUE, #extra diagnostics
                  keep.inbag=TRUE, #track of bootstrap process
                  ntree=500, #how many trees
                  replace=FALSE) #bootstrap with replacement?
print(RF)

ff = forestFloor(RF,x)
print(ff)

#ff can be plotted in different ways. As our data have six dimensions we cannot plot everything at once. Lets start with one-way forestFloor plots
plot(ff)

#following lines demonstrate the above equation
#this part can be skipped...
#this is the starting prediction of each tree
tree.bootstrap.mean = apply(RF$inbag,2,function(x) sum(x*y/sum(x)))
#this is the individual OOB bootstrap.mean for any observation4
y.bootstrap.mean = apply(RF$inbag,1,function(x) {                         sum((x==0) * tree.bootstrap.mean)/sum(x==0)
})
#OOB prediction = FC.rowsum + bootstrap.mean
yhat = apply(ff$FCmatrix,1,sum) + y.bootstrap.mean

#yhat and RF$predicted are almost the same, only limited by double precision.
##plot(yhat-RF$predicted) #try plot this

#fcol outputs a colourvector as function of a matrix or forestFloor object
#first input, what to colour by, 2nd input, what columns to use
par(mfrow=c(2,2))
pairs(X[,1:3],col=fcol(X,cols=2),main="single variable gradient, nn X2")
pairs(X[,1:3],col=fcol(X,cols=c(1:2)),main="double variable gradient, nn X1 & X2")
pairs(X[,4:6],col=fcol(X,cols=c(1:3)),main="triple variable gradient, nn X1 & X2 & X3")
pairs(X[,1:8],col=fcol(X,cols=c(1:5)),main="multi variable gradient, nn PCA of X1...X5")

#print fcol outputs colours defined as RGB+alpha(transparency)
Col = fcol(X,cols=c(1:3))
print(Col[1:5])

#first two hexidemimals describe red, then green, then blue, then alpha.
# two hexidecimals is equal to a 10base number from 1 to 256
#now we apply a color gradient along variable x3
Col = fcol(ff,3,orderByImportance=T)
Col = fcol(ff,3,order=F)
plot(ff,col=Col)
show3d_new(ff,3:4,col=Col)
#one awesome 3D plot in a external window!!



##abalone####
aba = c()
aba$y = abalone$rings
aba$X = abalone[,names(abalone)!="rings"]
#1B Model
library(randomForest)
aba$rfo = randomForest(aba$X,aba$y,keep.inbag=T,importance=T)
library(forestFloor, warn.conflicts=FALSE, quietly = TRUE)
aba$ff = forestFloor(aba$rfo,aba$X)
#1C Plots
aba$Col = fcol(aba$ff,1,alpha=0.2,orderByImportance=T)
plot(aba$ff,col=aba$Col) #shucked_weight and shell-weight seems to interact
show3d_new(aba$ff,1:2,col=aba$Col) #the 2-way plot fully explains this interactions
varImpPlot(aba$rfo,scale=FALSE)
print(aba$rfo$importance)

##3prostate###########
load(file="prostata.rda")
summary(prostate)
pro= prostate

#replace randomForest function with cinbag for binary classification
#completely the same except inbag is a count and not true/false 1/0
pro$rfo = cinbag(pro$x,pro$y,keep.inbag=T,importance=T,ntree=2000) #more trees to make importance more robust
par(mfrow=c(1,2))
plot(pro$rfo$predicted,pro$y,
     col="#12345678",
     main="prediction plot",
     xlab="predicted reponse",
     ylab="actual response")
mosaicplot(t(pro$rfo$confusion),shade=TRUE)
pro$ff = forestFloor(pro$rfo,pro$x,calc_np=T) #calc_np needs to be true for classification
#3B plots
Col = c("black","red")[as.numeric(pro$y)] #black for true healthy, red for true cancer
Col = c("#00000050","#FF000050")[as.numeric(pro$y)] #same colours included, some transparancy
varImpPlot(pro$rfo,scale=F,type=1)
#most important vars is approx. 1627  406   77  653 5568 1053  979 1322  411 1061  897  614
#exact order varies
#one error in package for sorting figures for RF-classification, was found yesterday.
#thx for noticing :), following line is a tempoary fix
pro$ff$imp_ind = sort(importance(pro$rfo,scale=F,type=1),dec=T,ind=T)$ix
#importanceOrder contain the order to sort variables by importance
plot.forestFloor(pro$ff,
                 plot_seq=1:12,
                 col=Col,
                 order_by_importance=T #turn off automatical sorting of figures
)


show3d_new(pro$ff,c(1,2),col=Col)
show3d_new(pro$ff,c(1,2),col=Col,plot.rgl.args=alist(
  xlab=Xi[1],
  ylab=Xi[2])
)

