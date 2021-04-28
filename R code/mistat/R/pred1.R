pred1 <- function(x, n = 10){
  if(n >= length(x))
    stop("n should be < length(x)")
  ns<-length(x)
  res<-c(1:ns)
  k <- min(c(n, length(x)))
  res[1:n]<-x[1:n]
  for(i in (n+1):ns){
    xs<-x[1:i]
    ak<-acf(xs,k,plot=F)
    a<-ak$acf[1:(k-1)]
    R<-toeplitz(a)
    r<-ak$acf[2:k]
    b<-solve(R)%*%r
    res[i]<-sum(x[(i-1):(i-(k-1))]*b)
  }
  return(res)
}
