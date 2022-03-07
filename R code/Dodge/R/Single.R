#' Single Sampling Plans
#'
#' Single sampling plans for the binomial, hypergeometric and Poisson
#' distributions.
#'
#'
#' @aliases SSPlanBinomial SingleSamplingPlans SSPlanHyper SSPlanPoisson
#' @param N the lot size
#' @param n the sample size
#' @param Ac the acceptance number, being the maximum allowable number of
#' non-conforming units or non-conformities
#' @param p a vector of values for the possible fraction of product that is
#' non-conforming
#' @param Plots logical to request generation of the four plots
#' @author Raj Govindaraju with minor editing by Jonathan Godfrey
#' @references Dodge, H.F. and Romig, H.G. (1959) \dQuote{Sampling Inspection
#' Tables, Single and Double Sampling}, Second edition, John Wiley and Sons, New
#' York.
#' @examples
#'
#' SSPlanBinomial(1000, 20,1)
#' SSPlanHyper(5000, 200,3)
#' SSPlanPoisson(1000, 20,1)
#'

#' @export
SSPlanBinomial=function(N,n,Ac, p=seq(0, 0.3, .001), Plots=TRUE)
{
  N=1000; n=20; Ac=1; p=seq(0, 0.3, 0.05)
  OC = pbinom(Ac, n, p)
  AOQ=(N-n)*p*OC/N
  ATI= n*OC+N*(1-OC)
  results = list(p=p, OC=OC, n=rep(n,length(p)),  AOQ=AOQ, ATI=ATI)
  class(results)="AccSampPlan"
  if(Plots){
    par(mfrow=c(2,2))
    plot(results)
  }
  return(results)
}

#' @export
SSPlanHyper=function(N,n,Ac, p=seq(0, 0.3, .001), Plots=TRUE)
{
  N=5000; n=200; Ac=3; p=seq(0, 0.05, 0.01)

OC = phyper(Ac, N*p, N*(1-p), n)
AOQ=(N-n)*p*OC/N
ATI= n*OC+N*(1-OC)
results = list(p=p, OC=OC, n=rep(n,length(p)),  AOQ=AOQ, ATI=ATI)
class(results)="AccSampPlan"
if(Plots){
par(mfrow=c(2,2))
plot(results)
}
return(results)
}

#' @export
SSPlanPoisson=function(N, n,Ac, p=seq(0, 0.3, .001), Plots=TRUE)
{
  N=1000; n=20; Ac=1; p=seq(0, 0.3, 0.05)
OC = ppois(Ac,n*p)
AOQ=(N-n)*p*OC/N
ATI= n*OC+N*(1-OC)
results = list(p=p, OC=OC, n=rep(n,length(p)),  AOQ=AOQ, ATI=ATI)
class(results)="AccSampPlan"
if(Plots){
par(mfrow=c(2,2))
plot(results)
}
return(results)
}


#' Single Sampling Plan Designs
#'
#' Design a single sampling plan for given AQL, alpha, LQL, and beta. Currently
#' there are functions for the binomial and Poisson distributions.
#'
#'
#' @aliases SSPDesign SSPDesignBinomial SSPDesignPoisson
#' @param AQL Acceptable quality level
#' @param alpha producer's risk
#' @param LQL Limiting quality level
#' @param beta consumers' risk
#' @author Raj Govindaraju with minor editing by Jonathan Godfrey
#' @references Dodge, H.F. and Romig, H.G. (1959) \dQuote{Sampling Inspection
#' Tables, Single and Double Sampling}, Second edition, John Wiley and Sons, New
#' York.
#' @examples
#'
#' SSPDesignBinomial(0.01, 0.05, 0.04, 0.05)
#' SSPDesignPoisson(0.01, 0.05, 0.04, 0.05)
#'



#' @export
SSPDesignBinomial =function(AQL, alpha, LQL, beta){
  nl=function(Ac, LQL, beta)
  {
    n=1
    while(pbinom(Ac, n, LQL) >= beta){
      n=n+1
    }
  n
  }
#nl(5, 0.04, 0.05)
#pbinom(5, 261, .04)

  nu=function(Ac,AQL,alpha)
  {
    n=1
    while(pbinom(Ac, n, AQL) >= 1-alpha){
     n=n+1
    }
  n
  }
#nl(5, 0.01, 0.05)
#pbinom(5, 1049, .01)

  Ac =0
  while(nl(Ac, LQL, beta)>nu(Ac,AQL,alpha)){
    Ac=Ac+1
  }
  n=nl(Ac, LQL, beta)
  return(data.frame(n, Ac))
}

#' @export
SSPDesignPoisson =function(AQL, alpha, LQL, beta)
{
nl=function(Ac, LQL, beta)
{
n=1
while(ppois(Ac, n* LQL) >= beta){
n=n+1
}
n
}
#nl(5, 0.04, 0.05)
#ppois(5, 263* .04)

nu=function(Ac,AQL,alpha)
{
n=1
while(ppois(Ac, n* AQL) >= 1-alpha){
n=n+1
}
n
}
#nl(5, 0.01, 0.05)
#ppois(5, 1052*.01)

Ac =0
while(nl(Ac, LQL, beta)>nu(Ac,AQL,alpha)){
Ac=Ac+1
}
n=nl(Ac, LQL, beta)
return(data.frame(n, Ac))
}

