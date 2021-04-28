dynOAB2 <- function(N, al){
    Rew <- dynOAB(N, al)
    out<-(Rew[N,1]+Rew[N,2])/2
    return(out)
    }