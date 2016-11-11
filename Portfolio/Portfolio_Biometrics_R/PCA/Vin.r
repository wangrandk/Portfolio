JCFWine<-read.csv("VIN2.csv",head=T,sep=";",dec=",")
View(JCFWine)
summary(JCFWine)
data(wines, package = "ChemometricsWithRData")
View(wines)

par(mar=c(4,2,3,2),mfrow=c(3,4))
for (i in 3:15) boxplot(JCFWine[,i] ~ JCFWine[,2],
                       col = 1:3, main = names(JCFWine)[i])

outlier<-JCFWine[JCFWine[,15]>1800,]
##WITHOUT Standardization - ONLY with centering####
winepc_without=PCA(scale(JCFWine[,3:15], scale = FALSE))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(winepc_without, col = JCFWine$Wine, main = "Scores")
loadingplot(winepc_without, show.names = TRUE, main = "Loadings")
biplot(winepc_without, score.col = JCFWine$Wine, main = "biplot")
screeplot(winepc_without, type = "percentage", main = "Explained variance")
#with both
winepc=PCA(scale(JCFWine[,3:15]))
par(mar=c(4,2,3,2),mfrow=c(2,2))
scoreplot(winepc, col = JCFWine$Wine, main = "Scores")
loadingplot(winepc, show.names = TRUE, main = "Loadings")
biplot(winepc, score.col = JCFWine$Wine, main = "biplot")
screeplot(winepc, type = "percentage", main = "Explained variance")
cor(JCFWine[3:15])
