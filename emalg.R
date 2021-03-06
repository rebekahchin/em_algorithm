# libraries --------------------------------------------------------------
library(ropenblas) #for inverting matrices

# EM algorithm ------------------------------------------------------------
estep<-function(x,L,psi){
  #finding the expectation of factors (F) given the observations (X)
  hat<-solve((L%*%t(L)) + psi)
  beta<-t(L)%*%hat
  exp<-beta%*%x
  n<-dim(L)
  n<-n[2]
  #finding the second moment of F given X
  expsq<-diag(n)-(beta%*%L)+(exp%*%t(exp))
  exps<-list("exp"=exp,"expsq"=expsq)
  return(exps)
}
mstep<-function(X,L,psi){
  sizeL<-dim(L)
  col<-rep(0,sizeL[1])
  L2<-cbind(col,col,col)
  sizeX<-dim(X)
  exps<-estep(X[1,],L,psi)
  exp<-exps$exp
  A<-(X[1,]%*%t(exp))
  B<-exps$expsq
  #estimating L_new
  for (i in (2:sizeX[1])){
    exps<-estep(X[i,],L,psi)
    exp<-exps$exp
    A<-(X[i,]%*%t(exp))+A
    B<-exps$expsq+B
  }
  L2<-A%*%solve(B)
  exps<-estep(X[1,],L,psi)
  exp<-exps$exp
  C<-(X[1,]%*%t(X[1,]))-(L2%*%exp%*%t(X[1,]))
  #estimating psi_new
  for (i in (2:sizeX[1])){
    exps<-estep(X[i,],L,psi)
    exp<-exps$exp
    C<-(X[i,]%*%t(X[i,]))-(L2%*%exp%*%t(X[i,]))+C
  }
  psi2<-diag(diag(C))/sizeX[1]
  emres<-list("L2"=L2,"psi2"=psi2)
  return(emres)
}

emalg<-function(tol,maxite,X,L,psi){
  Z<-scale(X)
  Sn<-cov(X)
  R<-cov2cor(Sn)
  i<-1
  while (i<maxite){
    if (i>1){
      psi<-psi2
      L<-L2
    }
    mres<-mstep(Z,L,psi)
    L2<-mres$L2
    psi2<-mres$psi2
    if (max(abs(psi2-psi))>tol & max(abs(L2-L))>tol){
      i<-i+1
    } else{
      break
    }
  }
  scores<-t(L2)%*%solve(R)%*%t(Z)
  scores<-t(scores)
  res<-list("iterations"=i,"L_new"=L2,"psi_new"=psi2,"scores"=scores)
  return(res)
}
