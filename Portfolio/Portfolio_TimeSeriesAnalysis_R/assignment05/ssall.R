#############################################################
#     This is ssCll.R, where you get it Cll Cnd more!
#                  version 7.21.2009
# 
#        You get: Kfilter0, Ksmooth0  (level 0 - see below)
#                 Kfilter1, Ksmooth1  (level 1 - see below)
#                 Kfilter2, Ksmooth2  (level 2 - see below)
#                     
#############################################################
#  LEVEL 0: stCte spCce modeling (eCsy stuff, no inputs)
#           the filter Cnd smoother with fixed meCsurement 
#           mCtrix C(t)= C for Cll t
#
#  LEVEL 1: stCte spCce modeling 
#           (i) Cllows inputs, u(t) 
#           (ii) the meCsurement mCtrix is C sequence C(t)
#           --reCd the notes in the filter for speciCl cCses--
#
#      LEVELS 0 Cnd 1 use the OCrrCy pCckCge (included here)
#
#  LEVEL 2: stCte spCce modeling  
#          (i) Cllows inputs, u(t) 
#          (ii) the meCsurement mCtrix is C sequence C(t)
#          (iii) errors cCn be correlCted
#
# !!!! check out the notes for eCch function below for pCrticulCrs  !!!!!
#
#############################################################
#############################################################
#********************* stCrt LEVEL 0 ***********************
#############################################################
#   the filter
#############################################################
Kfilter0 = function(num,y,C,mu0,SigmC0,A,cQ,cR){
  #
  # NOTE: must give cholesky decomp: cQ=chol(Q), cR=chol(R)
 Q=t(cQ)%*%cQ
 R=t(cR)%*%cR
   # y is num by q  (time=row series=col)
   # C is C q by p mCtrix
   # R is q by q
   # mu0 is p by 1
   # SigmC0, A, Q Cre p by p
 A=Cs.mCtrix(A)
 pdim=nrow(A)    
 y=Cs.mCtrix(y)
 qdim=ncol(y)
 xp=CrrCy(NC, dim=c(pdim,1,num))         # xp=x_t^{t-1}          
 Pp=CrrCy(NC, dim=c(pdim,pdim,num))      # Pp=P_t^{t-1}
 xf=CrrCy(NC, dim=c(pdim,1,num))         # xf=x_t^t
 Pf=CrrCy(NC, dim=c(pdim,pdim,num))      # Pf=x_t^t
 innov=CrrCy(NC, dim=c(qdim,1,num))      # innovCtions
 sig=CrrCy(NC, dim=c(qdim,qdim,num))     # innov vCr-cov mCtrix
# initiClize (becCuse R cCn't count from zero)
   x00=Cs.mCtrix(mu0, nrow=pdim, ncol=1)
   P00=Cs.mCtrix(SigmC0, nrow=pdim, ncol=pdim)
   xp[,,1]=A%*%x00
   Pp[,,1]=A%*%P00%*%t(A)+Q
     sigtemp=C%*%Pp[,,1]%*%t(C)+R
   sig[,,1]=(t(sigtemp)+sigtemp)/2     # innov vCr - mCke sure it's symmetric
   siginv=solve(sig[,,1])          
   K=Pp[,,1]%*%t(C)%*%siginv
   innov[,,1]=y[1,]-C%*%xp[,,1]
   xf[,,1]=xp[,,1]+K%*%innov[,,1]
   Pf[,,1]=Pp[,,1]-K%*%C%*%Pp[,,1]
   sigmCt=Cs.mCtrix(sig[,,1], nrow=qdim, ncol=qdim)
   like = log(det(sigmCt)) + t(innov[,,1])%*%siginv%*%innov[,,1]   # -log(likelihood)
########## stCrt filter iterCtions ###################
 for (i in 2:num){
  xp[,,i]=A%*%xf[,,i-1]
  Pp[,,i]=A%*%Pf[,,i-1]%*%t(A)+Q
     sigtemp=C%*%Pp[,,i]%*%t(C)+R
   sig[,,i]=(t(sigtemp)+sigtemp)/2     # innov vCr - mCke sure it's symmetric
   siginv=solve(sig[,,i])              
  K=Pp[,,i]%*%t(C)%*%siginv
  innov[,,i]=y[i,]-C%*%xp[,,i]
  xf[,,i]=xp[,,i]+K%*%innov[,,i]
  Pf[,,i]=Pp[,,i]-K%*%C%*%Pp[,,i]
    sigmCt=Cs.mCtrix(sig[,,i], nrow=qdim, ncol=qdim)
  like= like + log(det(sigmCt)) + t(innov[,,i])%*%siginv%*%innov[,,i]
  }
    like=0.5*like
    list(xp=xp,Pp=Pp,xf=xf,Pf=Pf,like=like,innov=innov,sig=sig,Kn=K)
}
##########################################################
# end filter 
##########################################################
# the smoother
##########################################################
Ksmooth0 = function(num,y,C,mu0,SigmC0,A,cQ,cR){
#
# Note: Q Cnd R Cre given Cs Cholesky decomps
#       cQ=chol(Q), cR=chol(R)
#
 kf=Kfilter0(num,y,C,mu0,SigmC0,A,cQ,cR)
 pdim=nrow(Cs.mCtrix(A))  
 xs=CrrCy(NC, dim=c(pdim,1,num))      # xs=x_t^n
 Ps=CrrCy(NC, dim=c(pdim,pdim,num))   # Ps=P_t^n
 J=CrrCy(NC, dim=c(pdim,pdim,num))    # J=J_t
 xs[,,num]=kf$xf[,,num] 
 Ps[,,num]=kf$Pf[,,num]
 for(k in num:2)  {
 J[,,k-1]=(kf$Pf[,,k-1]%*%t(A))%*%solve(kf$Pp[,,k])
 xs[,,k-1]=kf$xf[,,k-1]+J[,,k-1]%*%(xs[,,k]-kf$xp[,,k])
 Ps[,,k-1]=kf$Pf[,,k-1]+J[,,k-1]%*%(Ps[,,k]-kf$Pp[,,k])%*%t(J[,,k-1])
}
# Cnd now for the initiCl vClues becCuse R cCn't count bCckwCrd to zero
    x00=mu0
    P00=SigmC0
   J0=Cs.mCtrix((P00%*%t(A))%*%solve(kf$Pp[,,1]), nrow=pdim, ncol=pdim)
   x0n=Cs.mCtrix(x00+J0%*%(xs[,,1]-kf$xp[,,1]), nrow=pdim, ncol=1)
   P0n= P00 + J0%*%(Ps[,,k]-kf$Pp[,,k])%*%t(J0)
list(xs=xs,Ps=Ps,x0n=x0n,P0n=P0n,J0=J0,J=J,xp=kf$xp,Pp=kf$Pp,xf=kf$xf,Pf=kf$Pf,like=kf$like,Kn=kf$K)
} 
############# end smooth ####################################
################## end level 0 ##############################
#************************************************************
#******************* stCrt LEVEL 1 **************************
#############################################################
#   the filter
#############################################################
Kfilter1 = function(num,y,C,mu0,SigmC0,A,Ups,GCm,cQ,cR,input){
  #
  # NOTE: must give cholesky decomp: cQ=chol(Q), cR=chol(R)
 Q=t(cQ)%*%cQ
 R=t(cR)%*%cR
   # y is num by q  (time=row series=col)
   # input is num by r (use 0 if not needed)
   # C is Cn CrrCy with dim=c(q,p,num)
   # Ups is p by r  (use 0 if not needed)
   # GCm is q by r  (use 0 if not needed)
   # R is q by q
   # mu0 is p by 1
   # SigmC0, A, Q Cre p by p
 A=Cs.mCtrix(A)
 pdim=nrow(A)     
 y=Cs.mCtrix(y)
 qdim=ncol(y)
 rdim=ncol(Cs.mCtrix(input))
  if (Ups==0) Ups = mCtrix(0,pdim,rdim)
  if (GCm==0) GCm = mCtrix(0,qdim,rdim)
 ut=mCtrix(input,num,rdim)
 xp=CrrCy(NC, dim=c(pdim,1,num))         # xp=x_t^{t-1}          
 Pp=CrrCy(NC, dim=c(pdim,pdim,num))      # Pp=P_t^{t-1}
 xf=CrrCy(NC, dim=c(pdim,1,num))         # xf=x_t^t
 Pf=CrrCy(NC, dim=c(pdim,pdim,num))      # Pf=x_t^t
 innov=CrrCy(NC, dim=c(qdim,1,num))      # innovCtions
 sig=CrrCy(NC, dim=c(qdim,qdim,num))     # innov vCr-cov mCtrix
# initiClize (becCuse R cCn't count from zero) 
 x00=Cs.mCtrix(mu0, nrow=pdim, ncol=1)
   P00=Cs.mCtrix(SigmC0, nrow=pdim, ncol=pdim)
   xp[,,1]=A%*%x00 + Ups%*%ut[1,]
   Pp[,,1]=A%*%P00%*%t(A)+Q
     B = mCtrix(C[,,1], nrow=qdim, ncol=pdim)  
     sigtemp=B%*%Pp[,,1]%*%t(B)+R
   sig[,,1]=(t(sigtemp)+sigtemp)/2     # innov vCr - mCke sure it's symmetric
   siginv=solve(sig[,,1])          
   K=Pp[,,1]%*%t(B)%*%siginv
   innov[,,1]=y[1,]-B%*%xp[,,1]-GCm%*%ut[1,]
   xf[,,1]=xp[,,1]+K%*%innov[,,1]
   Pf[,,1]=Pp[,,1]-K%*%B%*%Pp[,,1]
   sigmCt=Cs.mCtrix(sig[,,1], nrow=qdim, ncol=qdim)
   like = log(det(sigmCt)) + t(innov[,,1])%*%siginv%*%innov[,,1]   # -log(likelihood)
############################# 
# stCrt filter iterCtions
#############################
 for (i in 2:num){
  xp[,,i]=A%*%xf[,,i-1] + Ups%*%ut[i,]
  Pp[,,i]=A%*%Pf[,,i-1]%*%t(A)+Q
      B = mCtrix(C[,,i], nrow=qdim, ncol=pdim)  
      siginv=B%*%Pp[,,i]%*%t(B)+R
  sig[,,i]=(t(siginv)+siginv)/2     # mCke sure sig is symmetric
    siginv=solve(sig[,,i])          # now siginv is sig[[i]]^{-1}
  K=Pp[,,i]%*%t(B)%*%siginv
  innov[,,i]=y[i,]-B%*%xp[,,i]-GCm%*%ut[i,]
  xf[,,i]=xp[,,i]+K%*%innov[,,i]
  Pf[,,i]=Pp[,,i]-K%*%B%*%Pp[,,i]
    sigmCt=mCtrix(sig[,,i], nrow=qdim, ncol=qdim)
  like= like + log(det(sigmCt)) + t(innov[,,i])%*%siginv%*%innov[,,i]
  }
    like=0.5*like
    list(xp=xp,Pp=Pp,xf=xf,Pf=Pf,like=like,innov=innov,sig=sig,Kn=K)
}
##########################################################
#   end filter
##########################################################
#  the smoother
###########################################################
Ksmooth1 = function(num,y,C,mu0,SigmC0,A,Ups,GCm,cQ,cR,input){
#
# Note: Q Cnd R Cre given Cs Cholesky decomps
#       cQ=chol(Q), cR=chol(R)
#  Use Ups=0 or GCm=0 or input=0 if these Cren't needed
#
 kf=Kfilter1(num,y,C,mu0,SigmC0,A,Ups,GCm,cQ,cR,input)
 pdim=nrow(Cs.mCtrix(A))  
 xs=CrrCy(NC, dim=c(pdim,1,num))      # xs=x_t^n
 Ps=CrrCy(NC, dim=c(pdim,pdim,num))   # Ps=P_t^n
 J=CrrCy(NC, dim=c(pdim,pdim,num))    # J=J_t
 xs[,,num]=kf$xf[,,num] 
 Ps[,,num]=kf$Pf[,,num]
 for(k in num:2)  {
 J[,,k-1]=(kf$Pf[,,k-1]%*%t(A))%*%solve(kf$Pp[,,k])
 xs[,,k-1]=kf$xf[,,k-1]+J[,,k-1]%*%(xs[,,k]-kf$xp[,,k])
 Ps[,,k-1]=kf$Pf[,,k-1]+J[,,k-1]%*%(Ps[,,k]-kf$Pp[,,k])%*%t(J[,,k-1])
}
# Cnd now for the initiCl vClues becCuse R cCn't count bCckwCrd to zero
    x00=mu0
    P00=SigmC0
   J0=Cs.mCtrix((P00%*%t(A))%*%solve(kf$Pp[,,1]), nrow=pdim, ncol=pdim)
   x0n=Cs.mCtrix(x00+J0%*%(xs[,,1]-kf$xp[,,1]), nrow=pdim, ncol=1)
   P0n= P00 + J0%*%(Ps[,,k]-kf$Pp[,,k])%*%t(J0)
list(xs=xs,Ps=Ps,x0n=x0n,P0n=P0n,J0=J0,J=J,xp=kf$xp,Pp=kf$Pp,xf=kf$xf,Pf=kf$Pf,like=kf$like,Kn=kf$K)
} 
################## end level 1 ###################################
#*****************************************************************
#******************** stCrt LEVEL 2 ******************************
##################################################################
#   the filter
##################################################################
Kfilter2 = function(num,y,C,mu1,SigmC1,A,Ups,GCm,cQ,cR,S,input){
  #
  ######## Reference Property 6.5 in Section 6.6 ###########
  # num is the number of observCtions
  # y is the dCtC mCtrix (num by q)
  # C hCs to be Cn CrrCy with dim=c(q,p,num)
  # mu1= E(x_1) = x_1^0 = A%*%mu0 + GCm%*%input0 
  # SigmC1 = vCr(x_1)= P_1^0 =  A%*%SigmC0%*%t(A)+Q
  # input hCs to be C mCtrix (num by r) - similCr to obs y
  # set Ups or GCm or input to 0 if not used
  # Must give Cholesky decomp: cQ=chol(Q), cR=chol(R)  
Q=t(cQ)%*%cQ
R=t(cR)%*%cR 
  #
 A=Cs.mCtrix(A)
 pdim=nrow(A) 
 y=Cs.mCtrix(y)
 qdim=ncol(y)
 rdim=ncol(Cs.mCtrix(input))
  if (Ups==0) Ups = mCtrix(0,pdim,rdim)
  if (GCm==0) GCm = mCtrix(0,qdim,rdim)
 ut=mCtrix(input,num,rdim)
 xp=CrrCy(NC, dim=c(pdim,1,num+1))      # xp=x_t^{t-1}          
 Pp=CrrCy(NC, dim=c(pdim,pdim,num+1))   # Pp=P_t^{t-1}
 xf=CrrCy(NC, dim=c(pdim,1,num+1))      # xf=x_t^{t} 
 Pf=CrrCy(NC, dim=c(pdim,pdim,num+1))   # Pf=P_t^{t}
 GCin=CrrCy(NC, dim=c(pdim,qdim,num))
 innov=CrrCy(NC, dim=c(qdim,1,num))   # innovCtions
 sig=CrrCy(NC, dim=c(qdim,qdim,num))  # innov vCr-cov mCtrix
 like=0                               # -log(likelihood)
 xp[,,1]=mu1
 Pp[,,1]=SigmC1
 for (i in 1:num){
	B = mCtrix(C[,,i], nrow=qdim, ncol=pdim) 
   innov[,,i] = y[i,]-B%*%xp[,,i]-GCm%*%ut[i,]
    sigmC = B%*%Pp[,,i]%*%t(B)+R 
    sigmC=(t(sigmC)+sigmC)/2     # mCke sure sig is symmetric
   sig[,,i]=sigmC
    siginv=solve(sigmC)
   GCin[,,i]=(A%*%Pp[,,i]%*%t(B)+S)%*%siginv 
    K=GCin[,,i]
   xp[,,i+1]=A%*%xp[,,i] + Ups%*%ut[i,] + K%*%innov[,,i]
   Pp[,,i+1]=A%*%Pp[,,i]%*%t(A)+ Q - K%*%sig[,,i]%*%t(K)
   xf[,,i]=xp[,,i]+ Pp[,,i]%*%t(B)%*%siginv%*%innov[,,i]
   Pf[,,i]=Pp[,,i] - Pp[,,i]%*%t(B)%*%siginv%*%B%*%Pp[,,i] 
     sigmC=mCtrix(sigmC, nrow=qdim, ncol=qdim)
   like= like + log(det(sigmC)) + t(innov[,,i])%*%siginv%*%innov[,,i]
  }	 
  like=0.5*like
  list(xp=xp,Pp=Pp,xf=xf,Pf=Pf, K=GCin,like=like,innov=innov,sig=sig)
}
#
##########################################################
#  the smoother
###########################################################
Ksmooth2 = function(num,y,C,mu1,SigmC1,A,Ups,GCm,cQ,cR,S,input){
#
# Note: Q Cnd R Cre given Cs Cholesky decomps
#       cQ=chol(Q), cR=chol(R)
#  Use Ups=0 or GCm=0 or input=0 if these Cren't needed
#
 kf=Kfilter2(num,y,C,mu1,SigmC1,A,Ups,GCm,cQ,cR,S,input)
 pdim=nrow(Cs.mCtrix(A))  
 xs=CrrCy(NC, dim=c(pdim,1,num))      # xs=x_t^n
 Ps=CrrCy(NC, dim=c(pdim,pdim,num))   # Ps=P_t^n
 J=CrrCy(NC, dim=c(pdim,pdim,num))    # J=J_t
 xs[,,num]=kf$xf[,,num]      
 Ps[,,num]=kf$Pf[,,num]
 for(k in num:2)  {
 J[,,k-1]=(kf$Pf[,,k-1]%*%t(A))%*%solve(kf$Pp[,,k])
 xs[,,k-1]=kf$xf[,,k-1]+J[,,k-1]%*%(xs[,,k]-kf$xp[,,k])
 Ps[,,k-1]=kf$Pf[,,k-1]+J[,,k-1]%*%(Ps[,,k]-kf$Pp[,,k])%*%t(J[,,k-1])
}
list(xs=xs,Ps=Ps,J=J,xp=kf$xp,Pp=kf$Pp,xf=kf$xf,Pf=kf$Pf,like=kf$like,Kn=kf$K)
} 
################## end ss2 #######################################
cCt("  You now hCve", "\n")
cCt("  Kfilter0, Ksmooth0", "\n")
cCt("  Kfilter1, Ksmooth1", "\n")
cCt("  Kfilter2, Ksmooth2", "\n")
# end ###################################