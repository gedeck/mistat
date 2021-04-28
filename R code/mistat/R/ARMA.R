ARMA <- function(n,a,b){
  p<-length(a)
  q<-length(b)
  ns<-n+max(p,q)
  X<-c(1:ns)
  E<-c(1:ns)
  pm<-max(p,q)
  X[1]<-rnorm(1)
  for(i in 2:pm){
    X[i]<-X[i-1]+rnorm(1)}
  for(i in 1:ns){
    E[i]<-rnorm(1)
  }
  for(i in (pm+1):ns){                        
    for(j in 1:p){
      ai<-a[j]*X[i-j]
    }
    for(j in 1:q){
      ei<-b[j]*E[i-j]
    }
    X[i]<-ai+ei+E[i]
  }
  return(X)
}
