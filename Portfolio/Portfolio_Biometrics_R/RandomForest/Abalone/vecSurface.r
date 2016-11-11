rm(list=ls())
library(forestFloor)
#simulate data
obs=2500
vars = 6 

X = data.frame(replicate(vars,rnorm(obs)))
Ysignal = with(X, X3 * X4 * 3)
Yerror = rnorm(obs) * 1
Y = Ysignal+Yerror
print(cor(Ysignal,Y))

#grow a forest, remeber to include inbag
rfo=randomForest(X,Y,keep.inbag = TRUE,sampsize=1000,ntree=500)

vec.plot(rfo,X,3:4,grid.lines=100,VEC.function=mean,
         zoom=2,limitY=F,col=fcol(matrix(Y,ncol=1),1))



