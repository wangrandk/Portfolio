#GOAL = plot mosaic on the map ggplot2

#clear work space
rm(list = ls(all = TRUE))

# install.packages("ggplot2")
# install.packages("reshape2")
# install.packages("plyr")
# install.packages("languageR")
# install.packages("lme4")
# install.packages("psych")

# #librarys for ggplot2
# library(ggplot2)
# library(gtable)


# detach("package:jpeg", unload=TRUE)
# search()






# #set.seed(5)
# img <- readPNG("square_regions-1.png")
# #img[1,1,] # rgb breakdown of top left pixel
# #summary(img)
# # png("png-package.png")
# # par(mfrow=c(2,2))
# # par(mfrow=c(1,1))
# plot(0, type='n', xlim=c(0,0.5), ylim=c(0,3),main="Regions",asp = 1)
# #rasterImage(img, -0.5, -0.3, 1.5, 1.3)
# rasterImage(img, 2.4, 3.2, 0, 0)
# # grid.raster(img)
# # 
# # dev.off()




# ###############################
# ima <- readPNG("square_regions-1.png")
# summary(ima)
# plot(1:2, type='n', main="Plotting Over an Image", xlab="x", ylab="y")
# 
# #Get the plot information so the image will fill the plot box, and draw it
# lim <- par()
# rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
# grid()




############################################################
#read the campy data 
campy_data <- read.table("case2regionsOnePerBatch.txt",header=T,sep="\t")
#read the climate data 
climate_data <- read.table("climate.txt",header=T,sep="\t")
#read the ozone data 
ozone_data <- read.table("ozone.data.txt",header=T,sep="\t")





#############################################################################
#chi squared test
region_total <- campy_data[c("R1total", "R2total", "R3total", "R4total",
                             "R5total", "R6total", "R7total", "R8total")]
region_pos <- campy_data[c("R1pos", "R2pos", "R3pos", "R4pos",
                           "R5pos", "R6pos", "R7pos", "R8pos")]
#sum the columns from original data
region_total_sums <- colSums(region_total, na.rm = FALSE, dims = 1)
region_pos_sums <- colSums(region_pos, na.rm = FALSE, dims = 1)

region_neg_sums <- region_total_sums - region_pos_sums


#create 2 by 8 dataset
region_data_compact <- t(data.frame(region_neg_sums,region_pos_sums))
#name the columns and 
colnames(region_data_compact) <- c("R1", "R2","R3","R4","R5","R6","R7","R8")
rownames(region_data_compact) <- c("Neg","Pos")
#make the Chisquare test
ch1<-chisq.test(region_data_compact)
ch1
#
round(ch1$residuals,2) ## Rounded to two decimals so that it is easier to see
#make a mosaicplot
###par(mfrow=c(1,1))




############################################################################
###   plots   ###
############################################################################
#install.packages("png")
library(png)

# img <- readPNG(system.file("img", "square_regions-1.png", package="png"))
# img.n <- readPNG(system.file("img", "square_regions-1.png", package="png"), TRUE)
# transparent <- img[,,4] == 0
# img <- as.raster(img[,,1:3])
# img[transparent] <- NA

img <- readPNG("square_regions-1.png",TRUE)


par(mfrow=c(1,1))
plot(0, type='n', xlim=c(-0.8,0.8), ylim=c(0,1.2),main="Regions",asp = 1)

     


rasterImage(img, -0.8, 0, 0.8, 1.2)

#xleft, ybottom, xright, ytop,

# ratio 1.2 / 1.6

par(new=TRUE)

rasterImage(img, -0.8, 0, 0.8, -1.2)


#par(mfrow=c(2,2))
#mosaicplot(table(pop$Gender,pop$Urban.Rural,pop$Goals),shade=TRUE)


mosaicplot(t(region_data_compact),shade=2:3)
#############################################################################




















# #######################
# #install.packages("png")
# #install.packages("gtable")
# #install.packages("grid")?
# library(png)
# library(gtable)
# 
# #Replace the directory and file information with your info
# ima <- readPNG("square_regions-1.png")
# 
# #Set up the plot area
# plot(1:2, type='n', main="Plotting Over an Image", xlab="x", ylab="y")
# 
# #Get the plot information so the image will fill the plot box, and draw it
# lim <- par()
# rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
# grid()
# lines(c(1, 1.2, 1.4, 1.6, 1.8, 2.0), c(1, 1.3, 1.7, 1.6, 1.7, 1.0), type="b", lwd=5, col="white")
# 
# grid.newpage()
# grid.draw(g)

