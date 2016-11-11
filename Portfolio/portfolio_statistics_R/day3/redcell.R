
###############################################
## Day 3: Redcell
###############################################
setwd("C:\\Users\\RAN\\OneDrive\\books\\Applied stat\\day3")
red<-read.table("redcell.txt",header=TRUE)
summary(red)
plot(folate ~ ventilation, red)
## ANOVA models can be fitted using lm or aov we'll use lm:
a1 <- lm(folate ~ ventilation, red) #-1
# there are two summaries that are of interest:
# First of all if the factor that we use is significant:
anova(a1) 
# Secondly, we want to see the estimated parameters
summary(a1)

## The following four lines relates to the fact that an aov model is also a lm
class(a1)
methods(summary)
summary.aov(a1) ## Same as anova(a1)
summary.lm(a1)

# We can try to use an other level as reference:
levels(red$ventilation)
red$rVent<-relevel(red$ventilation,"O2,24h") #move to first as reference level
levels(red$rVent)
a2<-lm(folate~rVent,red)
summary(a2)
anova(a2) # =anova(a1) 
# The conclusion from anova(a2) remains the same, but the parameters are 
# no longer significantly different from the reference level.
# oder doesn't affect F p-value, but just the p-value in between the levels.