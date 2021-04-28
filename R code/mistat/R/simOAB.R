simOAB<- function(N, p, al, k, gam, Ns){
    res<-matrix(data = 1, nrow = Ns, ncol = 2)
    for(i in 1:Ns){
      n<-k
      X<-rbinom(1, k, p)
      repeat{
        cr <- pbeta(al, X+1, n+1-X)
        if((cr > gam)||(n == N)) break
        n<-n+1
        X<- X + rbinom(n = 1, size = 1, prob = p)
      }
      res[i,1] <- n
      res[i,2] <- X + (N - n) * al
    }
    AV <- mean(res[,1])
    sda <- sd(res[,1])
    Arew <- mean(res[,2])
    sdr <- sd(res[,2])
    out <- list(MeanValueStoppingTime = AV, 
                StandardDeviationST = sda, 
                MeanValueExpectedReward = Arew, 
                StandardDeviationER = sdr)
    return(out)
}
