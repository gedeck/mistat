predARMA <- function(X,a){
  n<-length(X)
  pred<-c(1:n)
  pred[1:3]<-X[1:3]
  for(i in 4:n){
    pred[i]<-a[1]*X[i-1]+a[2]*X[i-2]+a[3]*X[i-3]
  }
  return(pred)
}
