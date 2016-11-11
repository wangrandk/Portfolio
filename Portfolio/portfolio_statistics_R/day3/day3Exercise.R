##Kali####
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day3")
k<-read.table("kali.txt",header=TRUE)
summary(k)
k

#1 a non-parametric test to examine if the content of kali depends on the different productions
kruskal.test(k$kali~k$production)
# kruskal.test for testing homogeneity in location parameters in the case of two or more samples;
# Wilcoxon Rank Sum Performs one- and two-sample Wilcoxon tests on vectors of data

#2 Use a one-way ANOVA to examine if the content of kali depends on the different productions
plot(kali ~ production, k)

# data:  k$kali by k$production
# Kruskal-Wallis chi-squared = 17.8528, df = 3, p-value = 0.0004717

## ANOVA models can be fitted using lm or aov we'll use lm:
a1 <- lm(kali ~ production, k) 
anova(a1) 
summary(a1)

k$b<-relevel(k$production,"b") 
levels(k$b)
a2 <- lm(kali ~ k$b , k) 
summary(a2)
plot(kali ~ k$b,k)

k$c<-relevel(k$production,"c") 
levels(k$c)
a3 <- lm(kali ~ k$c , k) 
summary(a3)
plot(kali ~ k$c,k)

k$d<-relevel(k$production,"d") 
levels(k$d)
a4 <- lm(kali ~ k$d , k) 
summary(a4)
plot(kali ~ k$d,k)
#3
b


##Fertilizer####
#1
f<-read.table("fertilizer.txt",header=TRUE)
summary(f)
f
F<-data.frame(yield=c(10.3,-4.95,-6.00,10.30,-4.65,-11),
              field=rep(c("a","b","c"),2),
              fertilizer=rep(c("A","B"),3))

#2 Determine whether Fertilizer and/or Field influence on the yield
a1 <- lm(value ~ fertilizer , f)
summary(a1)
a2 <- lm(value ~ field , f)
summary(a2)
anova(a2)
plot(value ~ fertilizer+field, f)

#3 Is it possible to test for interaction effects between Fertilizer and Field? 
#  No interaction. only field is significant. value ~ field is the right model to use.
a3<- lm(value ~ fertilizer+field , f)
summary(a3)
anova(a3)

# f$b<-relevel(f$fertilizer,"b") 
# levels(f$b)
# a4 <- lm(value ~ f$b * field , f)
# summary(a4)



##Case: Filter#####
Filter<-read.table("filter.txt",header=TRUE)
summary(Filter)
Filter
#1 Determine whether size, type and side influence on the noise level by doing a graphical comparison
pairs(Filter,panel=panel.smooth)


#2 Determine whether size, type and side influence on the noise level by the appropriate statistical analysis? answer: the interaction model is ideal.

Filter$SIZE<-as.factor(Filter$SIZE)
Filter$TYPE<-as.factor(Filter$TYPE)
Filter$SIDE<-as.factor(Filter$SIDE)

mlm<-lm(NOISE~(.)^3,Filter)
summary(mlm)
anova(mlm)
par(mfrow=c(2,2))
plot(mlm)

#3 Are there any interaction effects between size and type? Yes

lm5<-lm(NOISE~SIZE*TYPE,Filter) 
summary(lm5)
anova(lm5)
plot(NOISE~SIZE*TYPE,Filter)




##Case: Fish####
Fish<-read.table("fishgrazer.txt",header=TRUE)
summary(Fish) #every 8 subjucts are a plot
Fish
#1
pairs(Fish,panel=panel.smooth)

lm1<-lm(cover~block,Fish) # SIGNIFICANT
summary(lm1)
plot(cover~block,Fish)

lm2<-lm(cover~treat,Fish) # NOT SIGNIFICANT
summary(lm2)
plot(cover~treat,Fish)

#2
qf(.95,5,90)

#3 
Fish$block<-as.factor(Fish$block)
Fish$treat<-as.factor(Fish$treat)
                     
lm2<-lm(cover~block*treat,Fish) # SIGNIFICANT
lm3<-lm(cover~block+treat,Fish)
par(mfrow=c(2,2))
plot(lm2)
plot(lm3)

boxplot(cover~block*treat,Fish)
boxplot(cover~treat*block,Fish)
abline(v=(1:7)*6+0.5,col=2)

lm2<-lm(sqrt(cover)~block*treat,Fish)
lm3<-lm(log(cover)~block*treat,Fish)
anova(lm2)
plot(lm2) #3. variance of residuals to the fitted value.
plot(lm3)
# corver~B(p,n=100)  var(X)=np(1???p)
barplot(tapply(Fish$cover,list(Fish$block,Fish$treat),mean))
Fish$logitcover<-log(Fish$cover/100)/(1-(Fish$cover/100)))

Fish$treat2<-fish$treat
levels(Fish$treats)<- c("C","L.Lf","LfF","f","fF")
anova(lm4<-(logitcover~treat2+block,Fish)

# library(polycor)
# hetcor(Fish)

 