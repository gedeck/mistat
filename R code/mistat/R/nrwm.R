nrwm <- function(n,v,w,c){
  s1<-sqrt(v)
  s2<-sqrt(w)
  X<-c(1:n)
  Tet<-c(1:n)
  cf<-c(1:n)
  Mt<-c(1:n)
  cf[1]<-(c+w)*v/(c+w+v)
  Tet[1]<-s2*rnorm(1)
  X[1]<-Tet[1]+s1*rnorm(1)
  Mt[1]<-X[1]
  for(i in 2:n){
    Tet[i]<-Tet[i-1]+s2*rnorm(1)
    X[i]<-Tet[i]+s1*rnorm(1)
    cf[i]<-(cf[i-1]+w)*v/(cf[i-1]+w+v)
    at<-(cf[i]+w)/(cf[i]+w+v)
    Mt[i]<-(1-at)*Mt[i-1]+at*X[i]
  }
  res<-list(nrw = X,Mt = Mt)
  return(res)
}
