#' Lot Sensitive Compliance Sampling Plans
#' 
#' The lot sensitive compliance sampling plans for given parameters.
#' 
#' 
#' @param N the lot size
#' @param LTPD the lot tolerance percent defective, also known as the limiting
#' quality
#' @param beta consumer risk
#' @param p fraction nonconforming
#' @param Plots logical indicating if the four plots are required
#' @author Raj Govindaraju with minor editing by Jonathan Godfrey
#' @references Schilling, E.G. (1978) \dQuote{A Lot Sensitive Sampling Plan for
#' Compliance Testing and Acceptance Inspection}, \emph{Journal of Quality
#' Technology} \bold{10}(2), pp47-51.
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' LSP(1000, 0.04,0.05)
#' 
#' @export
LSP=function(N, LTPD, beta, p=seq(0, 0.3, .001), Plots=TRUE)
{
f = 1-(beta**(1/(LTPD*N)) )
n = round(f*N)
OC =(1-f)^(N*p)
AOQ=(N-n)*p*OC/N
ATI= n*OC+N*(1-OC)
results = list(p=p, OC=OC, n=rep(n,length(p)),  AOQ=AOQ, ATI=ATI)
class(results)="AccSampPlan"
if(Plots){
par(mfrow=c(2,2))
plot(OC~p, type="l", 
ylab="Probability of Acceptance", 
xlab="Fraction Nonconforming p")
title(paste("f = ", formatC(f)))

plot(rep(n, length(p))~p, type="l", 
ylab="Uncurtailed sample size", 
xlab="Fraction Nonconforming p")
title(paste("n = ", formatC(n)))

plot(AOQ~p, type="l", 
ylab="AOQ", 
xlab="Fraction Nonconforming p")
title(paste("AOQL = ", formatC(max(AOQ))))

plot(ATI~p, type="l", 
ylab="ATI", 
xlab="Fraction Nonconforming p")
}
return(results)
}

