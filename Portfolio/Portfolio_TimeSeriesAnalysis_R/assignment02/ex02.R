Y1 <- arima.sim(model = list(ar = 0.6,order=c(1,0,0)), n = 500)
plot(Y1)
acf(Y1)
abline(h=sqrt(1/500)*1.96)

#Part 2 
e=rnorm(1500)
a=0.9
y=filter(e,filter=a,method="recursive")
ts.plot(y)

##part 4 Seasonal processes
y1<-arima.sim(model = list(ar = 0.9, order = c(1,0,0)), n = 500)
ts.plot(y1)
acf(y1)
pacf(y1)

y2<-arima.sim(model=list(ar=c(rep(0,11),.7)), n = 500)
ts.plot(y2)
par(mfrow=c(1,2))
acf(y2)
pacf(y2)
