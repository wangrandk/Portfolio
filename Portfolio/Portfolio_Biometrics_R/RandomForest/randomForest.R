library(randomForest)

#a simple dataset of normal distributed features
obs = 2000
vars = 6
X = data.frame(replicate(vars,rnorm(obs,mean=0,sd=1)))
#the target/response/y depends of X by some 'unknown hidden function'
hidden.function = function(x,SNR=4) {
ysignal <<- with(x, .5 * X1^2 + sin(X2*pi) + X3 * X4) #y = x1^2 + sin(x2) + x3 * x4
ynoise = rnorm(dim(x)[1],mean=0,sd=sd(ysignal)/SNR)
cat("actucal signal to noise ratio, SNR: nn", round(sd(ysignal)/sd(ynoise),2))
y = ysignal + ynoise
}
y = hidden.function(X)
#scatter plot of X y relations
plot(data.frame(y,X[,1:4]),col="#00004520")

#no noteworthy linear relationship
print(cor(X,y))

#RF is the forest_object, randomForest is the algorithm, X & y the training data
RF = randomForest(x=X,y=y,
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
abline(lm(y~yhat,data.frame(y=RF$y,yhat=RF$predicted)))

#this performance must be seen in the light of the signal-to-noise-ratio, SNR
plot(y,ysignal,
     col="#12345678",
     main="signal and noise plot",
     xlab="reponse + noise",
     ylab="noise-less response")

cat("explained variance, (pseudo R2) = 1- SSmodel/SStotal = nn",round(1-mean((RF$pred-y)^2)/var(y),3))
#explained variance, (pseudo R2) = 1- SSmodel/SStotal =0.653
cat("model correlation, (Pearson R2) = ",round(cor(RF$pred,y)^2,2))
#model correlation, (Pearson R2) = 0.69
cat("signal correlation, (Pearson R2) = ",round(cor(y,ysignal)^2,2))

par(mfrow=c(1,1))
plot(RF$rsq,type="l",log="x",
     ylab="prediction performance, pseudo R2",
     xlab="n trees used")

##variable importance
RF$importance

#short cut to plot variable importance
varImpPlot(RF)

#lets try to predict a test set of 800 samples
X2 = data.frame(replicate(vars,rnorm(800)))
true.y = hidden.function(X2)

pred.y = predict(RF,X2)
par(mfrow=c(1,1))
plot(pred.y,true.y,
     main= "test-set prediction",
     xlab= "predict reponse",
     ylab= "true response",
     col=rgb(0,0,abs(pred.y/max(pred.y)),alpha=.9))
abline(lm(true.y~pred.y,data.frame(true.y,pred.y)))

#get packge from rForge. Maybe additional packages such trimTrees, mlbench, rgl and #must be installed firts.
#install.packages("forestFloor", repos="http://R-Forge.R-project.org")
library(forestFloor, warn.conflicts=FALSE, quietly = TRUE)
#the function forestFloor outputs a forestFloor-object, here called ff
ff = forestFloor(RF,X)
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
pairs(X[,1:3],col=fcol(X,cols=c(1:3)),main="triple variable gradient, nn X1 & X2 & X3")
pairs(X[,1:5],col=fcol(X,cols=c(1:5)),main="multi variable gradient, nn PCA of X1...X5")

#print fcol outputs colours defined as RGB+alpha(transparency)
Col = fcol(X,cols=c(1:3))
print(Col[1:5])

#first two hexidemimals describe red, then green, then blue, then alpha.
# two hexidecimals is equal to a 10base number from 1 to 256
#now we apply a color gradient along variable x3
Col = fcol(ff,3,order=F)
plot(ff,col=Col)
show3d_new(ff,3:4,col=Col)
#one awesome 3D plot in a external window!!


