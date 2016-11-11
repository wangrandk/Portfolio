###############################################
## Day 3: Heartrate
###############################################
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day3")
hea<-read.table("heartrate.txt",header=TRUE)
summary(hea)
str(hea)
hea$subj<-factor(hea$subj) # Subject should be a factor

# And the first column is just an index, so we can use that as "row.names":
hea<-read.table("heartrate.txt",header=TRUE,row.names=1)
summary(hea)

# Finally we can read the data so that we get it in the form that we want from the beginning:
hea<-read.table("heartrate.txt",header=TRUE,row.names=1,colClasses=c(NA,"numeric","factor","factor"))
summary(hea)
str(hea)

## Interactions can be added using A+B+A:B or just A*B 
a1<-lm(hr~subj+time+subj:time,hea)
a1<-lm(hr~subj*time,hea)
a1<-lm(hr~(subj*time)^2,hea)
anova(a1)
summary(a1)

# So we cannot fit interactions as the subjects only had one heart attack ...
a2<-lm(hr~time+subj,hea)
a2<-lm(hr~subj+time,hea)
anova(a2)
summary(a2)
anova(a1,a2)
a3<-lm(hr~time,hea)
anova(a3)
anova(a3,a2)

summary(a2)
hea$time2<-hea$time
levels(hea$time2)<-c("before",rep("after",3)) #merge levels
a2b<-lm(hr~subj+time2,hea)
anova(a2b)
summary(a2b)
anova(a2,a2b)
anova(a2b,a2)
drop1(a2b,test="F")


summary(lm(hr~subj*time2,hea))

##Changing the order of the levels
hea$time<-factor(as.character(hea$time),levels=c("0","30","60","120"))
interaction.plot(hea$time,hea$subj,hea$hr)
interaction.plot(hea$time2,hea$subj,hea$hr)

