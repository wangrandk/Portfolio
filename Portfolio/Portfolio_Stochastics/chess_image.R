#chessboard image 
nx <- ny <-64
ntot=nx*ny
chess=matrix(nr=nx,nc=ny,data=1)

for(i in 1:nx){
  for(j in 1:ny){
   if(floor((i-1)/8) %% 2 ==0 && floor((j-1)/8) %% 2 !=0)
   {chess[i,j]=0}
   if(floor((i-1)/8) %% 2 !=0 && floor((j-1)/8) %% 2 ==0)
   {chess[i,j]=0}
   
  }
}


png("chess_board.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),chess,
      main="Chess-board",
      xlab="x",ylab="y",
      col=c("white","black"))

#add noise with sigma=0.5
noisy.chess=chess+rnorm(ntot,0,0.5)
image(seq(0,1,l=nx),seq(0,1,l=ny),noisy.chess,
      main="noisy Chess-board",
      xlab="x",ylab="y",
      col=terrain.colors(8))
dev.off()

#create a binary chess-board from the noisy image
#we need a binary image to operate with prior. Lets do that
binary.chess=matrix(nx,ny,data=NA)
for(i in 1:nx){
  for(j in 1:ny){
    binary.chess[i,j] <- ifelse(noisy.chess[i,j]>0.5,1,0)  
  }
}
png("chess_board2.png",height=300)
par(mfrow=c(1,2))
image(seq(0,1,l=nx),seq(0,1,l=ny),chess,
      main="Chess-board",
      xlab="x",ylab="y",
      col=c("white","black"))

#add noise with sigma=0.5
noisy.chess=chess+rnorm(ntot,0,0.5)
image(seq(0,1,l=nx),seq(0,1,l=ny),binary.chess,
      main="binary from noisy.Chess",
      xlab="x",ylab="y",
      col=c("white","black"))
dev.off()

