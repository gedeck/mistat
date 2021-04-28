dlmLg <- function(x,C0,v,W,M0){
  n<-length(x)
  pred<-c(1:n)
  for(i in 1:n){
    at<- matrix(data = 1, nrow = 2, ncol = 1)
    at[2,1]<-i
    pred[i]<-t(at)%*%M0
    ut<-v+t(at)%*%(C0+W)%*%at
    ei<-(x[i]-t(at)%*%M0)
    ev<- matrix(data = 1, nrow = 2, ncol = 1)
    ev[1,1]<-ei/ut
    ev[2,1]<-(i*ei)/ut
    M0<-M0+(C0+W)%*%ev
    B<-matrix(data = 1, nrow = 2, ncol = 2)
    B[1,1]<-1/ut
    B[1,2]<-i/ut
    B[2,1]<-i/ut
    B[2,2]<-(i^2)/ut
    C0<-(C0+W)-(C0+W)%*%B%*%(C0+W)
  }
  return(pred)
}

