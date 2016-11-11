##Caffeine####

setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day4")
Ca<-read.table("caffeine.txt",header=TRUE)
summary(Ca)

#1 Type the data into S-plus so that appropriate analysis can be carried out
Ca<-matrix(c(652,36,218,1537,46,327,598,38,106,242,21,67),ncol=4,dimnames=list(c("Married","Pre.Married","Single"),c("0","1-150","151-300",">300")))

#2. Determine whether Caffeine consumption and Marital status are independent
chi1<-chisq.test(Ca)
# X-squared = 51.6556, df = 6, p-value = 2.187e-09  

chi1
chi1$exp

#3. If there is dependence between Caffeine consumption and Marital status, what is the conclusion?
mosaicplot(as.table(Ca),shade=TRUE)
# H0: two variables are independent 
# they are dependent
# df=6, a=5% critical value= 12.59 
# x-squared = 51.65 > 12.59, reject H0
#  H0 is false or caffeine consumption and marrital statues are not independent

##Diet####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day4")
D<-read.table("diet.txt",header=TRUE)
summary(D)
str(D)
#1. Analyze the relationship between the four types of cracker and the four levels of severity of bloating 
D.ones<-D[which(D$Diet==2 & D$Bloat=='none'),]
View(data.ones)
D<-matrix(c(6,4,2,0,2,2,3,5,2,5,3,2,7,4,1,0),ncol=4,dimnames=list(Bloat=c("none","low","med","high"),CrackerType=c("1","2","3","4")))
chi1<-chisq.test(D) # not vailid

#null hypothesis is that these two classifications are not different.
fisher1<-fisher.test(D)
fisher1
summary(fisher1)
mosaicplot(as.table(D),shade=TRUE)

D2<-D[-1,]
D2<-D[-2,]
D2<-D[-3,]
D2[1,]<-D2[1,]+D[2,]+D[3,]
D2<-D[-3,]
D2

dimnames(D2)[[1]]<-c( "none+low+med","med","high")
mosaicplot(as.table(D2),shade=TRUE)


##Case: Popular####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day4")
P<-read.table("popular_test.txt",header=TRUE)

P.ones<-P[which(P$Gender==''& P$Goals=='Sports'),]
View(P.ones)

#1. Analyze the relationship between gender and goals.
P<-matrix(c(117,130,50,91,60,30),ncol=3,dimnames=list(Bloat=c("boy","girl"),CrackerType=c("Grade","Popular","Sports")))
P
chi1<-chisq.test(P) 
mosaicplot(as.table(P),shade=TRUE)
#answer: they are not independent.

#2. Analyze the relationship between age and goals.
table<-table(P$Age,P$Goals)
View(table)
Matrix<-matrix(c(1,50,72,94,29,1,0,28,39,63,11,0,0,22,21,32,12,3),ncol=3,dimnames=list(Age=c("7","9","10","11","12","13"),Goals=c("Grades","Popular","Sports")))
Matrix<-Matrix[-1,]
Matrix<-Matrix[-5,]
chi1<-chisq.test(Matrix) 
mosaicplot(as.table(Matrix),shade=TRUE)
# X-squared = 4.7654, df = 6, p-value = 0.5742  answer: failed to reject HO, age and goals are dependent. 


#fisher1<-fisher.test(Matrix,workspace = 200000000,hybrid=T)
mosaicplot(as.table(Matrix),shade=TRUE)
# there is no difference between age and goals.
# p-value = 0.2549
# alternative hypothesis: two.sided

#3 Could you suggest other analysis that may be interesting?


##Case: KFM####
KFM<-read.table("kfm.txt",header=TRUE)
KFM
#1. Make apropriate plots of the birthweight in order to check wether the weight is normally distributed

hist(KFM$weight,prob=TRUE,col="blue")
lines(density(KFM$weight,adjust=2),col=2)
qqnorm(KFM$weight)
qqline(KFM$weight)

shapiro.test(KFM$weight)
# data:  KFM$weight
# W = 0.9898, p-value = 0.9405
# NULL hypothesis that the samples came from a Normal distribution

#2. Make apropriate parametric tests (e.g. ??2 test) if the birthweights for the babies can be assumed normally distributed

KFM
normality<-dnorm(KFM$weight,mean = mean(KFM$weight), sd =sd(KFM$weight),log = FALSE)
plot(normality)

str(KFM$weight)
a<-hist(KFM$weight)
# $counts
# [1]  4  9 18 13  4  2
# $breaks
# [1] 4.0 4.5 5.0 5.5 6.0 6.5 7.0
Mean = mean(KFM$weight)
Sd =sd(KFM$weight)
N=50
pnorm(4,Mean,Sd) * N
(pnorm(4.5,Mean,Sd)-pnorm(4,Mean,Sd))*N
(pnorm(5,Mean,Sd)-pnorm(4.5,Mean,Sd))*N
(pnorm(5.5,Mean,Sd)-pnorm(5,Mean,Sd))*N
(pnorm(6,Mean,Sd)-pnorm(5.5,Mean,Sd))*N
(pnorm(6.5,Mean,Sd)-pnorm(6,Mean,Sd))*N
(pnorm(7,Mean,Sd)-pnorm(6.5,Mean,Sd))*N
(1- pnorm(7,Mean,Sd))*N


pnorm(a$breaks,mean = mean(KFM$weight),sd =sd(KFM$weight))
M<-matrix(c(.4,0,3,4,10.64,9,17,18,13,13,4.6,4,.72,2,.054,0),ncol=8,dimnames=list(c("theory","test"),c("1","2","3","4","5","6","7","8")))
fisher.test(M)

# p-value = 0.9846
# alternative hypothesis: two.sided
# the weight is from a normally distributed data 

