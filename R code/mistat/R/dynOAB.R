dynOAB<- function(N, al){
    Rew<-matrix(data = 0, nrow = N, ncol =  N+1)
    
    for(i in 1:(N+1)){
      X <- i - 1
      
      if(X < (al * (N + 1) -1)) { Rew[1,i] <- al}
      else { Rew[1, i] <- (X + 1) / (N + 1)}
    }
    for(j in 2:N){
      n <- N + 1 - j
      for(i in 1:(n + 1)){
        X <- i - 1
        cr1 <-(X + 1)*Rew[j-1, X+2]/(N - j + 2)
        cr2 <-(N - j + 1 - X)*Rew[j-1, X+1]/(N - j + 2)
        cr3 <-(X + 1)/(N - j + 2)
        cr <-cr1 + cr2 + cr3
        if(cr < (j * al)){Rew[j,i] <- j * al}
        else {Rew[j,i] <- cr}
      }
    }
    return(Rew)
  }
