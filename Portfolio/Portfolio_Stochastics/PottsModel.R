rm(list=ls())
data <- as.matrix(read.table("potts.txt",header = FALSE, sep = ""))
nx <- 500; ny <- 500; xmax <- 1; ymax <- 1; n <- nx*ny    
st1=0;st2=1; state <- rep(0,n)
state[1:n] <- ifelse(data[1:n]<=.5, st1,st2)
state <-matrix(nx,ny,data=state); 
#state<-as.numeric(state);
#state <- pmax(state,t(state))/N;
N=5;iter =100; beta = log(1+sqrt(2)) - .001; #not affect boundary 

#permutation: choose pixels at random with constraint-no replacement.
x=y=rep(0,500);
for (i in 1:500){
  x[i] = sample.int(500,1,replace=F);
  y[i] = sample.int(500,1,replace=F);
}

for (t in 1:iter){
  for (j in 2:nx-1){
   # for (j in 2:ny-1){
    X = state[x[j],y[j]]
    Xstar = 1 - X;
    if(state[x[j]+1,y[j]] == state[x[j]-1,y[j]] && 
         state[x[j],y[j]-1] == state[x[j],y[j]+1] )
    {d = beta*(2*state[x[j]+1,y[j]] + 2*state[x[j],y[j]+1])} 
    else if 
    (state[x[j]+1,y[j]] == state[x[j]-1,y[j]]) 
    {d = beta*(2*state[x[j]+1,y[j]])} 
    else if
          (state[x[j],y[j]-1] == state[x[j],y[j]+1])
    {d = beta*(2*state[x[j],y[j]-1])} 
   
    
    if (Xstar == state[j]){dstar=beta*(Xstar + state[j])}
    R = d/dstar;
    p = exp (min(1,R));
    u = runif(1);
    state[x[j],y[j]] = ifelse(u<p, Xstar, state[x[j],y[j]]) 
    #}
  }
}


Thresh <- -(rnorm(N)^2); Resp <- c(0L,1L);
MetData <- IsingSampler(n, state, Thresh, beta, 1000, responses = Resp, method = "MH")

n <- 1000 ; X <- rep(NA,n)
X[1] <-runif(n=1, min = 0, max = 1) # Init
sigma <- 1
f<- function(X) {dbeta(X,.5, .5,ncp = 0) }
for(i in 1:(n-1))
{
  Y <- runif(n=1, min = 0, max = 1) 
  R <- (f(Y) * dunif(X[i])) / (f(X[i]) * dunif(Y))
  p <- min(1,R)
  accept <- rbinom(n=1,size=1,prob=p)
  X[i+1] <- ifelse(accept==1, Y, X[i])
}
plot((X),type='b')
hist((X),prob=T,breaks=50)
s <- seq(0,1,.1)
lines(s,dbeta(s,.5,.5),col=3)
lines(density((X)),col=2)

image(seq(0,xmax,l=nx),seq(0,ymax,l=ny),state,
      main="Variable x",
      xlab="x",ylab="y",
      col=c(0,1))

summary(data)
## denoise#### 
iter<-10000; n <- 1000 ;mu = 0; sigma<-.5
#f<- functin(X){mvrnorm(n = X, mu, Sigma, tol = 1e-6, empirical = FALSE, EISPACK = FALSE)}
X <- rep(NA,n);
Y <- rep(NA,n-1);
X[1] <- rnorm(n=1,mu,sigma)    # Initial

for(i in 1:(n-1)) # Iterate random update
{ # Two-stage Gibbs sampler
  Y[i] <- rnorm(n=1,mean=sigma*X[i], sqrt(1-sigma^2)) # propose candidate values
  X[i+1] = rnorm(n=1,mean=sigma*Y[i], sqrt(1-sigma^2)) 
}
x <-[1:3]
x[3]
rnorm(10,0,0)

