toeplitz <- function(a){
  n<-length(a)
  res<-jay(n,n)
  res[1,]<-a
  for(i in 2:n){
    res[i,(i:n)]<-a[1:(n-i+1)]
    for(j in i:(i-i)){
      res[i,j]<-res[j,i]}
  }
  return(res)       
}

std<-function(x){
  return(sqrt(var(x)))
  }

inv<-function(x){ 
  return(solve(x))
  }

jay<-function(k,l){
  n<-k*l
  a<-c(1:n)/c(1:n)
  res<-matrix(a,nrow=k)
  return(res)
  }
