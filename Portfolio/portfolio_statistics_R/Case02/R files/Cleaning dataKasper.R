#Load data#####################################################################################################################
rm(list = ls(all = TRUE))
Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","C")
pre2002 <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/campy_pre2002.txt",header=T,sep="\t")

data2005 <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/campy_2002-2005.csv",header=T,sep=",")

post2005 <- read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/campy_2005-.csv",header=T,sep=",")

# Cleaning data #################################################################################################################
#remove those with SEKTION =="res":
pre2002<-subset(pre2002, SEKTION!="res")
#Only keep those with AKTVNR == 5133
pre2002<- subset(pre2002,AKTVNR==5133)
#All files: Valid CHR numbers are 10000 and above
pre2002 <-pre2002[which(pre2002$CHR >= 10000),]
data2005 <-data2005[which(data2005$Chrnr >= 10000),]
post2005<- post2005[which(post2005$Chrnr >= 10000),]
#Convert dates to common format.

pre2002$PRV_DATO <- as.Date(pre2002$PRV_DATO,"%d%b%Y")
data2005$Prvdato <- as.Date(data2005$Prvdato,"%m/%d/%y")
post2005$Provedato <- as.Date(post2005$Provedato,"%m/%d/%y")

Summary(as.numeric(PRV_DATO))
# data from 2002 - 2005 contains 8 rows. the 8 rows that are of interrest.
#get same order of columns to keep and then rename.
headerpre2002 <- c("CHR_NR","EPINR","JNR","DYRNR","MATR","BAKTFUND","PRV_DATO","region")
header2005 <- c("Chrnr","Epi.nr","Jnr","Dyrnr", "Materialeart","Resultat","Prvdato","region")
headerpost2005 <-c("Chrnr","Epinr","Jnr","Provenr","Materialeart","Tolkning","Provedato","region")

pre2002 <- pre2002[headerpre2002]
data2005 <- data2005[header2005]
post2005 <- post2005[headerpost2005]

#synconice the names to the names we want:
Names.Coloumns <- c("chrnr","epinr","jnr","dyrnr","matr","resultat","prvdato","region")

colnames(pre2002) <- Names.Coloumns
colnames(data2005) <- Names.Coloumns
colnames(post2005) <- Names.Coloumns

# merge together:
pre2002 <-pre2002[!duplicated(paste(pre2002$chrnr, pre2002$epinr,pre2002$prvdato)) ,]
#################################################################################################################
campy_data <- rbind(pre2002, data2005, post2005)
############################################################################################################
#delete all NA
campy_data$dyrnr <- NULL
campy_data <-campy_data[which(campy_data$epinr !="NA"),]
# check what levels in the Result coloumn is there:
#only include NEG and POS
campy_data$resultat[campy_data$resultat=="" | campy_data$resultat=="NEGATIV"]<-"NEG"
campy_data$resultat[campy_data$resultat!="NEG"]<-"POS"
#change it to factors
campy_data$resultat <- factor(campy_data$resultat)
##############################################################################
#removing unique jnr numbers:
UniqueNr <- unique(campy_data$jnr)
campy_data <- campy_data[UniqueNr,]
## Only keep records with certain "matr" 
campy_data <- campy_data[(campy_data$matr == "766" | campy_data$matr == "772" | campy_data$matr == "Kloaksvaber" | campy_data$matr == "Svaberprøve" ),]
##  12

#new coulmn with numeric data from date:
Numeric1998 <- as.numeric(as.Date("12/97/29",format="%m/%y/%d"))


difference<- (as.numeric(campy_data$prvdato)-Numeric1998) 
#the weeks since 1998-01-01:
campy_data$Weeks <-(as.numeric(campy_data$prvdato)-Numeric1998)%/%7 +1
View(campy_data)
# only positive weeks:
campy_data <- campy_data[campy_data$Weeks > 0,]

Numeric1998
summary(as.numeric(campy_data$prvdato))

#ads column called week number
campy_data$week_number <- as.numeric(campy_data$prvdato)
#calculates the week number of each day, starting at date "1998-01-01" and onwards
#for all years
campy_data$week_number_yes <- ((campy_data$week_number-as.numeric(as.Date("1998-01-01"))-4) %/%7 +2)


# 14 - skip!

## 15 - delete the farms with 10 flocks or less:
t<-as.data.frame(table(campy_data$epinr))
View(t)
t[(t$Freq<=10),1]
summary(campy_data)

campy_data <- campy_data[campy_data$epinr != 20,]
campy_data <- campy_data[campy_data$epinr != 21,]
campy_data <- campy_data[campy_data$epinr != 22,]
campy_data <- campy_data[campy_data$epinr != 23,]
campy_data <- campy_data[campy_data$epinr != 24,]
campy_data <- campy_data[campy_data$epinr != 25,]
campy_data <- campy_data[campy_data$epinr != 26,]
campy_data <- campy_data[campy_data$epinr != 27,]
campy_data <- campy_data[campy_data$epinr != 28,]
campy_data <- campy_data[campy_data$epinr != 31,]
campy_data <- campy_data[campy_data$epinr != 35,]
campy_data <- campy_data[campy_data$epinr != 40,]
campy_data <- campy_data[campy_data$epinr != 56,]
campy_data <- campy_data[campy_data$epinr != 60,]

# should have used for loop but something went wrong.
# 16 
campy_data <- split(campy_data,campy_data$Weeks)
head(campy_data)
# 17
campy_data <- table( campy_data$resultat, campy_data$Weeks)
View(campy_data)
campy_data <- as. table ( campy _17)


pre2002 <-pre2002[!duplicated(paste(pre2002$chrnr, pre2002$epinr,pre2002$prvdato)) ,]


# 18

write.table(campy,file="campy.txt",sep="," ,col.names = NA)