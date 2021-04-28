predPoly <- function(x,n,s){
  ns<-length(x)
  res<-c(1:ns)
  res[1:n]<-x[1:n]
  for(i in n:(ns-s)){
    xs<-x[i:(i-n+1)]
    nx<-c(0:-(n-1))
    A<-cbind(nx^0,nx,nx^2)
    b<-solve(t(A)%*%A)%*%t(A)%*%xs
    ts<-c(1,s,s^2)
    pred<-b[1,1]+s*b[2,1]+(s^2)*b[3,1]
    res[i+s]<-pred
  }
  return(res)
}
