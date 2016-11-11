# we use the iris data:
data(iris3)
Iris <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                   Sp = rep(c("s","c","v"), rep(50,3)))
# We make a test and training data:
set.seed(4897)
train <- sample(1:150, 75)
test <- (1:150)[-train]
Iris_train <- Iris[train,]
Iris_test <- Iris[test,]
# Distribution in three classes in training data:
table(Iris_train$Sp)
table(Iris_test$Sp)
## PART 1: LDA####
library(MASS)
lda_train_LOO <- lda(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,Iris_train, prior = c(1, 1, 1)/3, CV = TRUE)

# Assess the accuracy of the prediction
# percent correct for each category:
ct <- table(Iris_train$Sp, lda_train_LOO$class)
diag(prop.table(ct, 1))

# total percent correct
sum(diag(prop.table(ct)))
# [1] 0.97333, So the overal CV based error rate is 0.0267 = 2.7%.

library(klaR) #only works without the CV
partimat(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,
         data = Iris_train, method = "lda", prior=c(1, 1, 1)/3)

##QDA####
# PART 2: QDA
# Most stuff from LDA can be reused:
qda_train_LOO <- qda(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,Iris_train, prior = c(1, 1, 1)/3, CV = TRUE)
qda_train <- qda(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,Iris_train, prior = c(1, 1, 1)/3, CV = F)
# Assess the accuracy of the prediction
# percent correct for each category:
ct <- table(Iris_train$Sp, qda_train_LOO$class)
ct
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))
#[1] 0.96 For this example the QDA performs slightly worse than the LDA.
partimat(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,
         data = Iris_train, method = "qda", prior = c(1, 1, 1)/3)
##Predicting NEW data####
predict(qda_train, Iris_test)$class
# And now predicting NEW data:
#qdapred<-predict(qda_train_LOO, Iris_test)$class
#[1] s s s s s s s s s s s s s s s s s s s s s s s s s s c c c c c c c c c
#[36] c c v c c c c c c c v c c c c c c c v v v v v v v v v v v v v c v v v
#[71] v v v v v
#Levels: c s v
# Find confusion table:
ct <- table(Iris_test$Sp, predict(qda_train, Iris_test)$class)
ct

diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))

##Part 3: (Naive) Bayes method####
# With "usekernel=TRUE" it fits a density to the observed data and uses that
# instead of the normal distribution
# Let's explore the results first:
# (Can take a while dur to the fitting of densities)
partimat(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,
         data = Iris_train, method = "naiveBayes",
         prior=c(1, 1, 1)/3, usekernel = TRUE)

bayes_fit <- suppressWarnings(NaiveBayes(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,data = Iris_train, method = "naiveBayes",prior = c(1, 1, 1)/3, usekernel = TRUE))
par(mfrow = c(2, 2))
plot(bayes_fit,cex=.5)

# And now predicting NEW data:
bayespred <- predict(bayes_fit, Iris_test)$class
# Find confusion table:
ct <- table(Iris_test$Sp, bayespred)
ct
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))

##PART 4: k-nearest neighbourgh:####
# Explorative plot WARNING: THIS may take some time to produce!!
partimat(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,
         data = Iris_train, method = "sknn", kn = 3)

knn_fit_5 <- sknn(Sp ~ Sepal.L. + Sepal.W. + Petal.L. + Petal.W.,
                  data = Iris_train, method = "sknn", kn = 5)
# And now predicting NEW data:
knn_5_preds <- predict(knn_fit_5, Iris_test)$class
# Find confusion table:
ct <- table(Iris_test$Sp, knn_5_preds)
ct
diag(prop.table(ct, 1))
sum(diag(prop.table(ct)))

##PART 5:PLS-DA####
# We have to use the "usual" PLS-functions
# Define the response vector (2 classes) OR matrix (>2) classes:
# Let's try with K=2: Group 1: s, Group -1: c and v
Iris_train$Y <- -1
Iris_train$Y[Iris_train$Sp == "s"] <- 1
table(Iris_train$Y)
Iris_train$X <- as.matrix(Iris_train[, 1:4])
# From here use standard PLS1 predictions, e.g.:
library(pls)
# Pls:
mod_pls <- plsr(Y ~X , ncomp = 4, data =Iris_train,
                validation = "LOO", scale = TRUE, jackknife = TRUE)
# Initial set of plots:
par(mfrow = c(2, 2))
plot(mod_pls, labels = rownames(Iris_train), which = "validation")
plot(mod_pls, "validation", estimate = c("train", "CV"),legendpos = "topright")
plot(mod_pls, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")
pls::scoreplot(mod_pls, labels = Iris_train$Sp,pch=19, col=as.numeric(Iris_train$Sp))
#You should do a CV based confusion table for each component
preds <- array(dim = c(length(Iris_train[, 1]), 4)) #75 by 4 array
for (i in 1:4) preds[, i] <- predict(mod_pls, ncomp = i)
preds[preds<0] <- -1
preds[preds>0] <- 1
# Look at the results from each of the components:
for (i in 1:4) {
ct <- table(Iris_train$Y, preds[,i])
CV_error <- 1-sum(diag(prop.table(ct)))
print(CV_error)
}
#new data
preds_test <- array(dim = c(length(Iris_train[, 1]), 4))
for (i in 1:4) preds_test[, i] <- predict(mod_pls, ncomp = i,data=Iris_test)
preds_test[preds_test<0] <- -1
preds_test[preds_test>0] <- 1
# Look at the results from each of the components:
for (i in 1:4) {
  ct <- table(Iris_train$Y, preds_test[,i])
  CV_error <- 1-sum(diag(prop.table(ct)))
  print(CV_error)
}

# WHAT if in this case K=3 classes:
# Look at Varmuza, Sec. 5.2.2.3
K=3
Iris_train$Y=matrix(rep(1,length(Iris_train[,1])*K),ncol=K)# matrix 75 by 3
Iris_train$Y[Iris_train$Sp!="c",1]=-1 #if elements in Iris_train$Sp is not "c",then it is -1 in the  1st column of Iris_train$Y .
Iris_train$Y[Iris_train$Sp!="s",2]=-1
Iris_train$Y[Iris_train$Sp!="v",3]=-1
mod_pls <- plsr(Y ~ X, ncomp = 4, data = Iris_train,
                validation="LOO", scale = TRUE, jackknife = TRUE)
# Initial set of plots:
par(mfrow=c(1, 1))
pls::scoreplot(mod_pls, labels = Iris_train$Sp,col=as.numeric(Iris_train$Sp))
plot(mod_pls, labels = rownames(Iris_train), which = "validation")
plot(mod_pls, "validation", estimate = c("train", "CV"),
     legendpos = "topright")
plot(mod_pls, "validation", estimate = c("train", "CV"),
     val.type = "R2", legendpos = "bottomright")

# Predictions from PLS need to be transformed to actual classifications:
# Select the largest one:
preds <- array(dim = c(length(Iris_train[, 1]), 4))
for (i in 1:4) preds[,i]<- apply(predict(mod_pls, ncomp = i), 1, which.max)
preds2 <- array(dim = c(length(Iris_train[, 1]), 4))
preds2[preds==1] <- "c"
preds2[preds==2] <- "s"
preds2[preds==3] <- "v"
# Look at the results from each of the components:
for (i in 1:4) {
ct <- table(Iris_train$Sp, preds2[, i])
CV_error <- 1 - sum(diag(prop.table(ct)))
print(CV_error)
}

##Random forests####


