#Showing Changing pix
# you need reconstruction saved in x
# and Changing pixels saved in ChangingPix

mask <- ChangingPix!=matrix(nr=ny,nc=nx,data=0)
smallmask <- patch <- matrix(nr=50,nc=50,data=NA)


for(i in 1:50) {
  for(j in 1:50) {
    patch[i,j]=x[i,j]
    smallmask[i,j] <- ifelse(ChangingPix[i,j]==0,0,0.5)
  }
}

#red circle 
theta=seq(0,2*pi,0.01)
circle=matrix(nr=length(theta),nc=2,data=NA)
circle[,1]=nx/10 + sqrt(2)*(nx/10)*cos(theta)
circle[,2]=ny/10 + sqrt(2)*(nx/10)*sin(theta)

png("ChangingPix_patch1.png")
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))

image(seq(0,1,l=nx),seq(0,1,l=ny),x,
      main="Full Reconst",
      xlab="",ylab="",
      col=c("white","black"))
#plot(circle[,1],circle[,2],type='l',col=2,lwd=2)

image(seq(0,1,l=nx),seq(0,1,l=ny),ChangingPix,
      main=paste("ChangingPix after burnin ",burn.in),
      xlab="",ylab="",
      col=terrain.colors(8))
image(seq(0,1,l=nx/10),seq(0,1,l=ny/10),patch,
      main="small patch(50x50)",
      xlab="",ylab="",
      col=c("white","black"))

image(seq(0,1,l=nx/10),seq(0,1,l=ny/10),smallmask,
      main="small mask(50x50)",
      xlab="",ylab="",
      col=terrain.colors(8))

dev.off()

