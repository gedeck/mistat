masPred1 <- function(x,m,s){
  n<-length(x)
  k<-2*m+s
  res<-c(1:n)
  res[1:k]<-x[1:k]
  for(i in (m+1):(n-m-s)){
    xtm<-x[(i-m):(i+m)]
    b0m<-mean(xtm)
    am<-c(1:m)
    amm<-c(-m:-1)
    wm<-c(amm,0,am)
    b1m<-(3*sum(wm*xtm))/(m*(m+1)*(2*m+1))
    res[i+m+s]<-b0m+(m+s)*b1m
  }
  return(res)
}
