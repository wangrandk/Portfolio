rm(list=ls())

##Part 1  apply,lapply, sapply
m = matrix(rnorm(30),ncol=5)
print(m)

#simple rowsums etc vector to scalar, output vector
apply(m,1,sum)
apply(m,2,sum)

#cumulative sum, vector to vector, output vector
cumsum(1:5)
apply(m,2,cumsum)

#modified apply function
f = function(vec) sum((mean(vec)-vec)^2)
f = function(vec) {
  Jim = list(mood="happy",
             place="bar",
             age=42)
  SumOfSquares = sum((mean(vec)-vec)^2)
  return(SumOfSquares)
}

f(1:5)
f(c(2,0,1,1,1,1,1))
apply(m,2,f)

#the endline
apply(m,2,function(vec) sum((mean(vec)-vec)^2))

#the sapply
ncols=dim(m)[2]
out = sapply(1:ncols,function(j) f(m[,j]))
out = lapply(1:dim(m)[2],function(j) f(m[,j]))


##part two replicate, scope, grid search

#simulate data
obs=2500
vars = 6 
X = data.frame(replicate(vars,rnorm(obs)))
Ysignal = with(X, X1^2 + sin(X2*pi) + 1 * X3 * X4)
Yerror = rnorm(obs) * 1
Y = Ysignal+Yerror
print(cor(Ysignal,Y))

#grow a forest, remeber to include inbag
rfo=randomForest(X,Y,keep.inbag = TRUE,sampsize=1000,ntree=500,mtry=5)
print(rfo)

#grid search light
mtrys= c(1,2,3,4,5,6)
sampsizes = c(25,50,100,200,1000)
pars  =  expand.grid(mtry= mtrys,
                     sampsize=sampsizes)
#those paremeters changing
parsInList = lapply(1:dim(pars)[1], function(i) pars[i,])
#those paremeters constant
std.arg = alist(x=X,y=Y,nrtee=300)

library(parallel) #mclapply
R2.fit = mclapply(parsInList, function(these.pars) {
  run.arg = c(std.arg,these.pars)      
  rfo=do.call(what = randomForest, args = run.arg)
  print(rfo$call)
  rev(rfo$rsq)[1]
})

##view grid results
library(rgl)
persp3d(x = mtrys,
        y = sampsizes,
        z = matrix(unlist(R2.fit),nrow=length(mtrys)),
        col=c("grey","black"),alpha=.2)





