

#' Chain Sampling Plans
#' 
#' Chain Sampling Plans for the binomial and Poisson distributions.
#' 
#' 
#' @aliases ChainSamplingPlans ChainBinomial ChainPoisson
#' @param N the lot size
#' @param n the sample size
#' @param i the number of preceding lots that are free from nonconforming units
#' for the lot to be accepted
#' @param p a vector of values for the possible fraction of product that is
#' nonconforming
#' @param Plots logical to request generation of the four plots
#' @return A matrix containing the argument \code{p} as supplied and the
#' calculated OC, ATI and ???
#' @author Raj Govindaraju with minor editing by Jonathan Godfrey
#' @references Dodge, H.F. (1955) \dQuote{Chain Sampling Inspection Plan},
#' \emph{Industrial Quality Control} \bold{11}(4), pp10-13.
#' @examples
#' 
#' require(Dodge)
#' ChainBinomial(1000, 20,3)
#' ChainPoisson(1000, 20,3)
#' 
#' @export

ChainBinomial=function(N,n,i, p=seq(0, 0.2, .001), Plots=TRUE){
OC =(1-p)^n+n*p*(1-p)^(n+n*i-1)
AOQ=(N-n)*p*OC/N
ATI= n*OC+N*(1-OC)
results = list(p=p, OC=OC, n=rep(n,length(p)),  AOQ=AOQ, ATI=ATI)
class(results) = "AccSampPlan"
if(Plots){
par(mfrow=c(2,2))
plot(results)
}
return(results)
}

#' @export
ChainPoisson=function(N, n,i, p=seq(0, 0.3, .001), Plots=TRUE)
{
OC = exp(-n*p)+n*p*exp(-n*p*(i+1))
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
