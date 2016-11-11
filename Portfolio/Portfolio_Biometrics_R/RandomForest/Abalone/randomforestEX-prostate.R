rm(list=ls())
load(file="prostata.rda")
summary(prostate)
x=prostate$x
y=prostate$y
#RF is the forest_object, randomForest is the algorithm, x & y the training data
RF = randomForest(x=x,y=y,
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
RF$confusion
RF$votes
#Dotchart of variable importance, these genes code for prostate cancer
varImpPlot(RF)

#lets try to predict a test set of 34 samples
s=sample(102,34)
x2=x[s,]
true.y = y[s]
pred.y = predict(RF,x2)
par(mfrow=c(1,1))
plot(pred.y,true.y,
     main= "test-set prediction",
     xlab= "predict reponse",
     ylab= "true response")
t=table(true.y,pred.y)
mosaicplot(t,shade=TRUE)

