# libraries --------------------------------------------------------------
library(ropenblas) #for inverting matrices

# EM algorithm ------------------------------------------------------------
expfn<-function(x,L,psi){
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
emalg<-function(X,L,psi){
  sizeL<-dim(L)
  col<-rep(0,sizeL[1])
  L2<-cbind(col,col,col)
  sizeX<-dim(X)
  exps<-expfn(X[1,],L,psi)
  exp<-exps$exp
  A<-(X[1,]%*%t(exp))
  B<-exps$expsq
  #estimating L_new
  for (i in (2:sizeX[1])){
    exps<-expfn(X[i,],L,psi)
    exp<-exps$exp
    A<-(X[i,]%*%t(exp))+A
    B<-exps$expsq+B
  }
  L2<-A%*%solve(B)
  exps<-expfn(X[1,],L,psi)
  exp<-exps$exp
  C<-(X[1,]%*%t(X[1,]))-(L2%*%exp%*%t(X[1,]))
  #estimating psi_new
  for (i in (2:sizeX[1])){
    exps<-expfn(X[i,],L,psi)
    exp<-exps$exp
    C<-(X[i,]%*%t(X[i,]))-(L2%*%exp%*%t(X[i,]))+C
  }
  psi2<-diag(diag(C))/sizeX[1]
  emres<-list("L2"=L2,"psi2"=psi2)
  return(emres)
}

# Iterative script --------------------------------------------------------

em<-function(Z,L,psi,tol,maxite){
  i<-1
  R<-cor(Z)
  while (i<maxite){
    if (i>1){
      psi<-psi2
      L<-L2
    }
    res<-emalg(Z,L,psi)
    L2<-res$L2
    psi2<-res$psi2
    if (max(abs(psi2-psi))>tol & max(abs(L2-L))>tol){
      i<-i+1
    } else{
      break
    }
  }
  message("Number of iterations:")
  message(i)
  scores<-t(L2)%*%solve(R)%*%t(Z)
  res<-list("L_new"=L2,"psi_new"=psi2,"scores"=scores)
  return(res)
}


