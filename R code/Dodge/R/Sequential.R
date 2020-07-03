#' Attribute Sequential Sampling Plans
#' 
#' Designs an attribute sequential sampling plan for given AQL, alpha, LQL, and
#' beta. The user can request plots describing the performance of the plan.
#' 
#' 
#' @aliases Sequential SequentialBinomial
#' @param x an object of class SeqSampPlan, or at least having the same
#' elements as one.
#' @param Plots logical indicating if the four plots should be returned
#' @author Raj Govindaraju with minor editing by Jonathan Godfrey
#' @examples
#' 
#' PlanDesign=SeqDesignBinomial(AQL=0.01, alpha=0.05, LQL=0.04, beta=0.05, Plots=FALSE)
#' SequentialBinomial(PlanDesign)
#' 

#' @export
SequentialBinomial=function(x, Plots=TRUE){
  k1=((1-x$beta)/x$alpha)^x$h
  k2 =(x$beta/(1-x$alpha))^x$h
  OC =(k1-1)/(k1-k2)
  AOQ= x$p*OC
  
  k5 = OC* log(x$beta/(1-x$alpha)) 
  k3=k5+(1-OC)* log((1-x$beta)/x$alpha)
  k4 = x$p*log(x$LQL/x$AQL)+(1-x$p)*log((1-x$LQL)/(1-x$AQL))
  ASN = k3/k4
  ATI=k5/k4 + (1-OC)*x$N
  results = list(p=x$p, OC=OC, ASN=ASN, AOQ=AOQ, ATI=ATI)
  class(results)="AccSampPlan"
  if(Plots){
    par(mfrow=c(2,2))
    plot(x$p, OC, type="l", 
    ylab="Probability of Acceptance", 
    xlab="Fraction Nonconforming p")
    title("OC Curve")
    
    plot(x$p, ASN, type="l", 
    ylab="Average sample size", 
    xlab="Fraction Nonconforming p")
    title(paste("maximum ASN = ", formatC(max(ASN))))
    
    plot(x$p, AOQ, type="l", 
    ylab="AOQ", 
    xlab="Fraction Nonconforming p")
    title(paste("AOQL = ", formatC(max(AOQ))))
  }
  return(results)
}




#' Create a sequential sampling plan
#' 
#' Selects the appropriate sequential sampling plan from the given inputs. The
#' only distribution that has been used in functions thus far is the binomial,
#' but further development is expected.
#' 
#' 
#' @aliases SeqDesign SeqDesignBinomial
#' @param N the lot size, ignored for the design of the plan unless the
#' underlying distribution is hypergeometric
#' @param AQL Acceptable quality level
#' @param alpha producer's risk
#' @param LQL Limiting quality level
#' @param beta consumers' risk
#' @param Plots logical stating if the sequential chart should be plotted
#' @author Raj Govindaraju and Jonathan Godfrey


#' @export
SeqDesignBinomial=function(N=NULL, AQL, alpha, LQL, beta, Plots=TRUE){
  a = log((1-beta)/alpha)
  b = log((1-alpha)/beta)
  g1= log(LQL/AQL)
  g2 = log((1-AQL)/(1-LQL))
  G=g1+g2
  h1= b/G
  h2 = a/G
  s = g2/G
  
  h = seq(- 4*h1, 5*h2, 0.01)
  p =(1-((1-LQL)/(1-AQL))^h )/(((LQL/AQL)^h)-(((1-LQL)/(1-AQL))^h))
  L = round(2*h1/s)
  k = seq(1, L, 1)
  accept = s*k-h1
  reject = s*k+h2
  
  results=list(N=N, AQL=AQL, alpha=alpha, LQL=LQL, beta=beta, h1=h1, h2=h2, s=s, accept=accept, reject=reject, k=k,p=p, h=h)
  class(results)="SeqSampPlan"
  if(Plots){
    plot(results)
  }
  return(results)
}

