rm(list=ls())
# install.packages("png")
# install.packages("pixmap")
# library(png)
# library(pixmap)
# file = readPNG("dew.png")
# pr=pixmapGrey(file,nrow=256/4,ncol=256/4,bbox=NULL, 
#               bbcent=FALSE, cellres=2)
# nx=256/4;ny=256/4; ntot = nx* ny
# dew=matrix(nr=nx,nc=ny,data=pr@grey)
# dew=ifelse(dew>.9,1,0)
# dew = t(dew)

# set.seed(3)
# noisy.dew=dew+rnorm(ntot,0,0.5)
# sigma=0.5 # I just did that in find_sigma_noise.R
# x <-noisy.dew 
#we need a binary image to operate with prior. Lets do that
#we will use noisy.dew in the sampling distribution

# nx = 500
# ny = 500
# ntot = nx*ny
# file= 'http://www2.imm.dtu.dk/courses/02443/projects/data/potts.txt'
# x<-  as.matrix(read.table(file))
# #settings
# beta=1.5
# niter=10




library(jpeg)
library(fields)
library(spatstat)
picture <- x
picture2 <- as.matrix(blur(as.im(picture), sigma=1.5))
picture3 <- as.matrix(blur(as.im(picture), sigma=2))
for(i in 1:nx){
  for(j in 1:ny){
    x[i,j] <- ifelse(picture3[i,j]>0.7,1,0)  
  }
}


png("GaussianSmooth.png")
layout(matrix(c(1:4), nrow=2))
par(mfrow=c(2,2))
image.plot(picture, col=gray.colors(50), main="original image", asp=1)
image.plot(picture2, col=gray.colors(50), main="blurred with sigma = 1.5", asp=1)
drape.plot(1:nrow(picture), 1:ncol(picture), picture, border=NA, theta=0, phi=80, main="original spectrogram")
drape.plot(1:nrow(picture), 1:ncol(picture), picture2, border=NA, theta=0, phi=80, main="blurred with sigma = 6")
dev.off()

image(seq(0,1,l=nx),seq(0,1,l=ny),x,
      main=("GaussianSmooth sigma2"),
      xlab="x",ylab="y", 
      col=c("white","black")) 
