wine<-read.csv("VIN2.csv",head=T,sep=";",dec=",")
View(wine)
library(ChemometricsWithRData)
library(ChemometricsWithR)
par(mar=c(4,2,3,2),mfrow=c(3,4))
for (i in 3:15) boxplot(wine[,i] ~ wine[,2],
                        col = 1:3, main = names(wine)[i])

outlier<-wine[wine[,15]>1800,]
##WITHOUT Standardization - ONLY with centering####
winepc_without=PCA(scale(wine[,3:15], scale = FALSE))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(winepc_without, col = wine$Wine, main = "Scores")
loadingplot(winepc_without, show.names = TRUE, main = "Loadings")
biplot(winepc_without, score.col = wine$Wine, main = "biplot")
screeplot(winepc_without, type = "percentage", main = "Explained variance")
#with both
winepc=PCA(scale(wine[,3:15]))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(winepc, col = wine$Wine, main = "Scores")
loadingplot(winepc, show.names = TRUE, main = "Loadings")
biplot(winepc, score.col = wine$Wine, main = "biplot")
screeplot(winepc, type = "percentage", main = "Explained variance")
cor(wine[3:15])

##lda####
set.seed(4897)
train <- sample(1:178, 178/2)
test <- (1:178)[-train]
wine_train <- wine[train,]
wine_test <- wine[test,]
# Distribution in three classes in training data:
table(wine_train$Wine)
table(wine_test$Wine)

library(MASS)
lda_train_LOO <- lda(Wine ~.  - X-Wine,wine_train, prior = c(1, 1, 1)/3, CV = TRUE)

# Assess the accuracy of the prediction
# percent correct for each category:
ct <- table(wine_train$Wine, lda_train_LOO$class)
diag(prop.table(ct, 1))

# total percent correct
sum(diag(prop.table(ct)))
# [1] 0.97333, So the overal CV based error rate is 0.0267 = 2.7%.

library(klaR) #only works without the CV
partimat(Wine ~. -X- Wine,data=wine_train, method = "lda",  plot.matrix = TRUE, imageplot = FALSE,prior=c(1, 1, 1)/3)

##QDA####
# PART 2: QDA
# Most stuff from LDA can be reused:
qda_train_LOO <- qda(Wine ~.- X-Wine,wine_train, prior = c(1, 1, 1)/3, CV = TRUE)
qda_train <- qda(Wine ~.- X-Wine,wine_train, prior = c(1, 1, 1)/3, CV = F)
# Assess the accuracy of the prediction
# percent correct for each category:
ct <- table(wine_train$Wine, qda_train_LOO$class)
ct
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))
#[1] 0.96 For this example the QDA performs slightly worse than the LDA.
partimat(Wine ~.- X-Wine,data = wine_train, method = "qda", prior = c(1, 1, 1)/3,plot.matrix = TRUE, imageplot = FALSE)
##Predicting NEW data####
pre<-predict(qda_train, wine_test)$class

ct <- table(wine_test$Wine, pre)
ct

diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))

##Part 3: (Naive) Bayes method####
# With "usekernel=TRUE" it fits a density to the observed data and uses that
# instead of the normal distribution
# Let's explore the results first:
# (Can take a while dur to the fitting of densities)
partimat(Wine ~.- X-Wine,data = wine_train, method = "naiveBayes",
         prior=c(1, 1, 1)/3, plot.matrix = TRUE, imageplot = FALSE, usekernel = TRUE)

bayes_fit <- suppressWarnings(NaiveBayes(Wine ~.- X-Wine,data = wine_train, method = "naiveBayes",prior = c(1, 1, 1)/3, usekernel = TRUE))
par(mfrow = c(2, 2))
plot(bayes_fit)
# And now predicting NEW data:
bayeWinered <- predict(bayes_fit, wine_test)$class
# Find confusion table:
ct <- table(wine_test$Wine, bayeWinered)
ct
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))

##PART 4: k-nearest neighbourgh:####
# Explorative plot WARNING: THIS may take some time to produce!!
partimat(Wine ~.- X-Wine,data = wine[train,],plot.matrix = TRUE, imageplot = FALSE, method = "sknn", kn = 3)

knn_fit_5 <- sknn(Wine ~.- X-Wine,data = wine_train, method = "sknn", kn = 5)
# And now predicting NEW data:
knn_5_preds <- predict(knn_fit_5, wine_test)$class
# Find confusion table:
ct <- table(wine_test$Wine, knn_5_preds)
ct
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))

##PART 5:PLS-DA####
# We have to use the "usual" PLS-functions
# Define the reWineonse vector (2 classes) OR matrix (>2) classes:
# Let's try with K=2: Group 1: s, Group -1: c and v
wine_train$Y <- -1
wine_train$Y[wine_train$Wine == "Barbera"] <- 1
table(wine_train$Y)
wine_train$X <- as.matrix(wine_train[, 3:15])
# From here use standard PLS1 predictions, e.g.:
library(pls)
# Pls:
mod_pls <- plsr(Y ~X , ncomp = 4, data =wine_train,
                validation = "LOO", scale = TRUE, jackknife = TRUE)
# Initial set of plots:
par(mfrow = c(2, 2))
plot(mod_pls, labels = rownames(wine_train), which = "validation")
plot(mod_pls, "validation", estimate = c("train", "CV"),legendpos = "topright")
plot(mod_pls, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")
pls::scoreplot(mod_pls, labels = wine_train$Wine,pch=19,cex=0.5, col=as.numeric(wine_train$Wine))
#You should do a CV based confusion table for each component
preds <- array(dim = c(length(wine_test[,1]), 4)) #89 by 4 array
for (i in 1:4) preds[, i] <- predict(mod_pls, ncomp = i)
preds[preds<0] <- -1
preds[preds>0] <- 1
# Look at the results from each of the components:
for (i in 1:4) {
  ct <- table(wine_train$Y, preds[,i])
  CV_error <- 1-sum(diag(prop.table(ct)))
  print(CV_error)
}

# WHAT if in this case K=3 classes:
# Look at Varmuza, Sec. 5.2.2.3
set.seed(4897)
train <- sample(1:178, 178/2)
test <- (1:178)[-train]
wine_train <- wine[train,]
wine_test <- wine[test,]
# Distribution in three classes in training data:
table(wine_train$Wine)
table(wine_test$Wine)

K=3
wine_train$Y=matrix(rep(1,length(wine_train[,1])*K),ncol=K)# matrix 89 by 3

wine_train$Y[wine_train$Wine!="Barbera",1]=-1 #if elements in wine_train$Wine is not "c",then it is -1 in the  1st column of wine_train$Y .
wine_train$Y[wine_train$Wine!="Barolo",2]=-1
wine_train$Y[wine_train$Wine!="Grigno",3]=-1
wine_train$X <- as.matrix(wine_train[, 3:15])
table(wine_train$Y)
which(!is.finite(wine_train$X))
mod_pls <- plsr(Y ~ X, ncomp = 4, data = wine_train,
                validation="LOO", scale = TRUE, jackknife = TRUE)
# Initial set of plots:
par(mfrow=c(1, 1))
pls::scoreplot(mod_pls, labels = wine_train$Wine,col=as.numeric(wine_train$Wine))
plot(mod_pls, labels = rownames(wine_train), which = "validation")
plot(mod_pls, "validation", estimate = c("train", "CV"),
     legendpos = "topright")
plot(mod_pls, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")

# Predictions from PLS need to be transformed to actual classifications:
# Select the largest one:
preds <- array(dim = c(length(wine_train[, 1]), 4))
for (i in 1:4) preds[,i]<- apply(predict(mod_pls, ncomp = i), 1, which.max)
preds2 <- array(dim = c(length(wine_train[, 1]), 4))
preds2[preds==1] <- "c"
preds2[preds==2] <- "s"
preds2[preds==3] <- "v"
# Look at the results from each of the components:
for (i in 1:4) {
  ct <- table(wine_train$Wine, preds2[, i])
  CV_error <- 1 - sum(diag(prop.table(ct)))
  print(CV_error)
}

