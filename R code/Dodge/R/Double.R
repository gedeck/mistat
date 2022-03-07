#' Double Sampling Plans
#'
#' Double Sampling Plans for the binomial and Poisson distributions.
#'
#'
#' @aliases DSPlanBinomial DoubleSamplingPlans DSPlanPoisson
#' @param N the lot size
#' @param n1 the sample size in the first stage of the plan
#' @param n2 the sample size in the second stage of the plan
#' @param Ac1 the first stage acceptance number
#' @param Re1 the first stage rejection number
#' @param Ac2 the second stage acceptance number
#' @param p a vector of values for the possible fraction of product that is
#' nonconforming
#' @param Plots logical to request generation of the four plots
#' @author Raj Govindaraju with minor editing by Jonathan Godfrey
#' @references Dodge, H.F. and Romig, H.G. (1959) \dQuote{Sampling Inspection
#' Tables, Single and Double Sampling}, Second edition, John Wiley and Sons, New
#' York.
#' @examples
#'
#' DSPlanBinomial(1000, 10, 10, 0, 2, 1)
#' DSPlanPoisson(1000, 10, 10, 0,2, 1)
#'

#' @export
DSPlanBinomial=function(N,n1,n2,Ac1,Re1, Ac2, p=seq(0,0.25,0.005), Plots=TRUE){
#N=1000;n1=10;n2=10;Ac1=0;Re1=2;Ac2=1
N=150; n1=20; n2=40; Ac1=2; Re1=6; Ac2=6
p = c(0, 0.05, 0.1, 0.15, 0.2, 0.25)

Ac1; Re1
Pa1=pbinom(Ac1, n1, p)

limits=(Ac1+1):(Re1-1)

i=0
Pa2=matrix(0, ncol=length(limits), nrow=length(p))

for(d1 in limits)
{
  i=i+1
  pc=dbinom(d1,n1,p)*pbinom((Ac2-d1),n2,p)
  Pa2[,i]=pc
}
Pa2
Pa2=rowSums(Pa2)
OC=Pa1+Pa2
ASN =n1+n2*(pbinom((Re1-1), n1, p)- pbinom(Ac1, n1, p))
AOQ=(p*Pa1*(N-n1)+p*Pa2*(N-n1-n2))/N
ATI= n1*Pa1+(n1+n2)*Pa2+(1-OC)*N

results = list(p=p, OC=OC, ASN=ASN, AOQ=AOQ, ATI=ATI, Pa1=Pa1, Pa2=Pa2)
class(results)="AccSampPlan"
if(Plots){
par(mfrow=c(2,2))
plot(results)
}
return(results)
}

#' @export
DSPlanPoisson=function(N,n1,n2,Ac1,Re1, Ac2, p=seq(0,0.25,0.005), Plots=TRUE){
#N=1000;n1=10;n2=10;Ac1=0;Re1=2;Ac2=1
  N=150; n1=20; n2=40; Ac1=2; Re1=6; Ac2=6

Pa1=ppois(Ac1, n1*p)
limits=(Ac1+1):(Re1-1)


i=0
Pa2=matrix(0, ncol=length(limits), nrow=length(p))

for(d1 in limits)
{
i=i+1
pc=dpois(d1,n1*p)*ppois((Ac2-d1),n2*p)
Pa2[,i]=pc
Pa2}
Pa2=rowSums(Pa2)
OC=Pa1+Pa2

ASN =n1+n2*(ppois((Re1-1), n1*p)- ppois(Ac1, n1*p))
AOQ=(p*Pa1*(N-n1)+p*Pa2*(N-n1-n2))/N
ATI= n1*Pa1+(n1+n2)*Pa2+(1-OC)*N

results = list(p=p, OC=OC, ASN=ASN, AOQ=AOQ, ATI=ATI, Pa1=Pa1, Pa2=Pa2)
class(results)="AccSampPlan"
if(Plots){
par(mfrow=c(2,2))
plot(results)
}
return(results)
}
