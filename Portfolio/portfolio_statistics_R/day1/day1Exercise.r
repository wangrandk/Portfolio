##Clima####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day1")
data<-read.table("clima.txt",header=TRUE)
summary(data)
str(data)
data[,1]==1
#1
plot(data$time,type='l',data$denmark, ylim=range(c(data$denmark,data$greenland)),xlab = "year",ylab="temperature",main = "Temperature in Denmark")
lines(data$time,data$greenland,type='l',col=2)
cor(data$time,data$denmark)

#2
plot(data$time[data$time<=1960],type='o',data$denmark[data$time<=1960],xlab = "year",ylab="temperature",main = "Temperature in Denmark")
index<-data$time<=1960
cor(data$time[index],data$denmark[index])
abline(lm(denmark[index]~time[index],data),col=2)
#abline(lm(greenland~time,data),col=3)

#3
index<-data$time>=1960
cor(data$time[index],data$denmark[index])
plot(data$time[data$time>=1960],type='o',data$denmark[data$time>=1960],xlab = "year",ylab="temperature",main = "Temperature in Denmark")
abline(lm(denmark[index]~time[index],data),col=2)





##Bodyfat####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day1")
data<-read.table("bodyfat.txt",header=TRUE)
str(data)
data
data2<-split(data$fatpct,data$gender) 
names(data2)<-c("male","female")
male<-data$fatpct[data$gender=="m"]
female<-data$fatpct[data$gender=="f"]

#1 normality
qqnorm(male)
qqline(male)

hist(male,prob=TRUE,col="blue")
lines(density(male),col=2)
hist(male,prob=TRUE,col="blue")
lines(density(male,adjust=2),col=2)
curve(dnorm(x,mean=mean(male),sd=sd(male)), col=2, lwd=2, add = TRUE)

qqnorm(female)
qqline(female)
hist(female,prob=TRUE,col="blue")
lines(density(female),col=2)
lines(density(female,adjust=2),col=2)

ks.test(male,female)
#not significant. H0: x and y were drawn from the same continuous distribution-normally distributed
shapiro.test(male)
shapiro.test(female)

#2 independent 2-group t-test
t.test(male,female) # where y and x are numeric

# independent 2-group Mann-Whitney U Test 
#ranksum tests the null hypothesis that data in x and y are samples from continuous distributions with equal medians, against the alternative that they are not. The test assumes that the two samples are independent. x and y can have different lengths.
wilcox.test(male,female) # where y and x are numeric


##Calcium####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat")
cal<-read.table("calcium.txt",header=TRUE)
summary(cal)
#1. Typically a t-test is used to examine the differences between the means of two groups. For example, in an experiment you may want to compare the overall mean for the group on which the manipulation took place vs a control group. 
calcium<-cal$Decrease[cal$Treatment=="Calcium"]
placebo<-cal$Decrease[cal$Treatment=="Placebo"]
cal

#2 normality test
qqnorm(calcium)
qqline(calcium)
hist(calcium,prob=TRUE,col="blue")
lines(density(calcium),col=2)
hist(calcium,prob=TRUE,col="blue")
curve(dnorm(x,mean=mean(calcium),sd=sd(calcium)), col=2, lwd=2, add = TRUE)
lines(density(calcium,adjust=2),col=2)

#3 not significant. variances are not same
var.test(calcium,placebo)

#4.graph of treatment means
boxplot(Decrease~Treatment,cal)

#5 not significant. fail to reject H0,means are not same
t.test(calcium,placebo)

#6 
wilcox.test(calcium,placebo)


##Laborforce####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat")
labor<-read.table("labor.txt",header=TRUE)
summary(labor)
labor

#1 the pooled test requires the assumption that the variances of the two populations are equal.
t.test(labor$x1968,labor$x1972,var.equal = TRUE)
#not significant, no difference
d<-density(labor$x1968)
plot(d)
polygon(d,col=2,border="4")

#2 significant there is a difference in means
t.test(labor$x1968,labor$x1972,paired=TRUE)

#3 paired t test is most appropriate. Assumption of the same variance is too abitrary, whereas paired t test best fits the measurement of the same city in two years.

#4 mean of the differences -0.03368421=3.4%
mean(labor$x1968)-mean(labor$x1972)

##Humerus####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat")
hum<-read.table("humerus.txt",header=TRUE)
summary(hum)
#split humerus according to code
hum2<-split(hum$humerus,hum$code) 
names(hum2)<-c("doa","alive")
my.qq(hum2$doa)
my.qq(hum2$alive)
t.test(hum2$doa,hum2$alive)
t.test(hum2$doa,hum2$alive,alternative="less")

hum$code<-factor(hum$code,labels=c("doa","alive"))
t.test(humerus~code,data=hum)
plot(humerus~code,hum)

##Rainfall####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat")
rf<-read.table("rainfall.txt",header=TRUE)
summary(rf)
par(mfrow=c(1,1))
plot(rf)
rf$code<-as.factor(rf$code)
boxplot(rain~code,data=rf)

tmp<-split(rf$rain,rf$code)
par(mfrow=c(2,1))
my.qq(tmp[[1]])
my.qq(tmp[[2]])

boxplot(rain~code,data=rf)
boxplot(log(rain)~code,data=rf) #sqrt

par(mfrow=c(2,1))
my.qq(log(tmp[[1]]))
my.qq(log(tmp[[2]]))

var.test(log(rain)~code,data=rf)
t.test(log(rain)~code,data=rf)

wilcox.test(log(rain)~code,data=rf)
#log(A)-log(B)=log(A/B) p-value is same with or without log

