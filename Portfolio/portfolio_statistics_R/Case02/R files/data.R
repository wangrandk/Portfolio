
pre2002<-read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/campy_pre2002.txt",header=T,sep="\t")
campy2002_2005<-read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/campy_2002-2005.csv",header=T,sep=",")

campy2005<-read.table("C:/Users/Kasper/Documents/DTU/3. semester/Anvendt Statistik/dataweek1/campy_2005-.csv",header=T,sep=",")

View(pre2002)
View(campy2002_2005)
View(campy2005)

#1 pre2002: Remove those with SEKTION=="res"
res<-pre2002[pre2002$SEKTION!="res",]
head(res)
View(res)

#2 pre2002: Only keep those with AKTVNR==5133
akt5133<-res[res$AKTVNR==5133,]
View(akt5133)

#3) All files: Valid CHR numbers are 10000 and above
validnr<-akt5133[akt5133$CHR_NR>=10000,]
campy2002_2005<-campy2002_2005[campy2002_2005$Chrnr>=10000,]
campy2005<-campy2005[campy2005$Chrnr>=10000,]

View(validnr)


#4) Convert dates to common format.Hint: use "as.Date"
date<-as.Date(validnr$PRV_DATO, "%d%b%Y")
date1<-as.Date(campy2002_2005$Prvdato,format="%m/%d/%y")
date2<-as.Date(campy2005$Provedato,format="%m/%d/%y")
View(date)
validnr$PRV_DATO<-date
campy2002_2005$Prvdato<-date1
campy2005$Provedato<-date2
View(validnr)

#5) get same order of columns to keep and then rename.
View(campy2002_2005)

View(campy2005)

#7) Merge the data using "rbind"
str(validnr)
str(campy2002_2005)
str(campy2005)


data02<-validnr[, c("CHR_NR", "EPINR", "JNR","DYRNR","MATR","BAKTFUND","PRV_DATO","region")]
View(data02)
data02$row.names<-NULL
data02_05<-campy2002_2005[,c("Chrnr","Epi.nr","Jnr","Dyrnr","Materialeart","Resultat","Prvdato","region")]
View(data02_05)
data05<- campy2005[,c("Chrnr","Epinr","Jnr","Provenr","Materialeart","Tolkning","Provedato","region")]
View(data05)
#reoder 2002-2005
campy2002_2005
colnames(data02) <- c("CHR_NR", "EPINR", "JNR","DYRNR","MATR","RESULT","PRV_DATO","REGION")
colnames(data02_05) <- c("CHR_NR", "EPINR", "JNR","DYRNR","MATR","RESULT","PRV_DATO","REGION")
colnames(data05) <- c("CHR_NR", "EPINR", "JNR","DYRNR","MATR","RESULT","PRV_DATO","REGION")
View(data02)
View(data02_05)
View(data05)


data<-rbind(data02,data02_05,data05)
View(data)
dim(data)


#8.Remove records with chrnr<=10000 and those with NA as epinr.Hint: Use "!is.na(epinr)"
data <-data[data$CHR_NR >10000,]
data<-data[!is.na(data$EPINR),]
View(data)
dim(data)

#9.Reduce the levels of resultat to only "POS" or "NEG"
levels(data$RESULT)

data$RESULT[data$RESULT=="" | data$RESULT=="NEGATIV"]<-"NEG"
data$RESULT[data$RESULT!="NEG"]<-"POS"

data$RESULT <- factor(data$RESULT)

# for (i in 1:length(data$RESULT) ) {
#   if(data$RESULT[i]== "" || data$RESULT[i]=="NEGATIV" || data$RESULT[i] == "NEG"){
#     data$RESULT[i] <- "NEG"
#   }
#   else{
#     data$RESULT[i] <- "POS"
#   }
# }


#10 Remove records with duplicated jnr (Keep first record)Hint: Use "duplicated"
UniqueNr <- unique(data$JNR)
data_1 <- data[UniqueNr,]

#11 Only keep records with "matr" in c("Kloaksvaber","Svaberprøve","766","772")
data_2 <- data_1[(data_1$MATR == "766" | data_1$MATR == "772" | data_1$MATR == "Kloaksvaber" | data_1$MATR == "Svaberprøve" ),]

#12 Add week number since week one 1998 for each record
View(data_2)
# d<-as.POSIXlt(data_2$PRV_DATO)
# data_2$week<-as.numeric(format(as.Date(data_2$PRV_DATO),"%W"))
# 
# data_1$ugenr <- as.numeric(format(as.Date(data_1$PRV_DATO),"%W"))
# data_2$epoch1<-as.integer( as.POSIXct(data_2$PRV_DATO)) 
# as.numeric(as.POSIXct('1998-01-01'))
# as.POSIXct( 971913600,origin="1998-01-01")
# as.numeric(as.POSIXct('1998-01-01'))

# loc<-Sys.getlocale("LC_TIME")
# Sys.setlocale("LC_TIME","C")
# some code
# Sys.Setlocale("LC_TIME","lOC")

c<-as.numeric(data_2$PRV_DATO)
a<-as.numeric(as.Date("1998/01/01", format="%Y/%m/%d"))
data_2$weeknr<-ceiling((c-a)/7)
data_2$DYRNR<-NULL

#13 Only keep those with positive week number
summary(data_2$weeknr)
data_3<-data_2[which(data_2$weeknr>0),]
View(data_3)


#14 Some chrnr should be removed due to various reasons. Skip!

#15 - delete the farms with 10 flocks or less:
t<-as.data.frame(table(data_3$EPINR))
t[(t$Freq<=10),1]
data_4<-data_3[(data_3$EPINR!=20  & 
                data_3$EPINR!=25  & 
                data_3$EPINR!=26  & 
                data_3$EPINR!=31  & 
                data_3$EPINR!=35  & 
                data_3$EPINR!=40  & 
                data_3$EPINR!=56  & 
                data_3$EPINR!=60),]
View(data_4)

# 16 Use "split" to split the data by week
summary(data_4$weeknr)
quantile(data_4$weeknr)

data_5 <- split(data_4,data_4$weeknr)
View(data_5)
x<-as.factor(data_4$weeknr)
levels(x)
# 17
data_5 <- table( data_4$resultat, data_4$Weeks)
View(data_5)
data_5 <- as. table ( campy _17)

