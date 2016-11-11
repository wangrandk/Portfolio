rm(list=ls())
library(forestFloor)
#simulate data
obs=2500
vars = 6 

X = data.frame(replicate(vars,rnorm(obs)))
Ysignal = with(X, X1^2 + sin(X2*pi) + 1 * X3 * X4)
Yerror = rnorm(obs) * 1
Y = Ysignal+Yerror
print(cor(Ysignal,Y))

#grow a forest, remeber to include inbag
rfo=randomForest(X,Y,keep.inbag = TRUE,sampsize=1000,ntree=500)

getTree(rfo)
