\name{BsProb.design}
\alias{BsProb.design}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Bayesian posterior probabilities from Box and Meyer method }
\description{
  The function calculates Bayesian posterior probabilities according 
  to Box and Meyer (1993) for screening experiments with 2-level factors.
  The function is modified from function BsProb in packge \pkg{BsMD}
  with the purpose of providing usage comfort for 
  class design objects.
}
\usage{
BsProb.design(design, mFac = NULL, response=NULL, select=NULL, mInt = 2, p = 0.25, g = 2,
    ng = 1, nMod = 10)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{design}{an experimental design of class \code{\link[DoE.base:class-design]{design}} 
              with the \code{type} element of the \code{design.info} attribute 
              containing \dQuote{FrF2} or \dQuote{pb} and at least one response variable}
  \item{response}{ NULL or a character string that specifies response variable to be used, 
              must be an element of \code{response.names(obj)}; 
              if NULL, the first response from \code{response.names(obj)} is used}
  \item{mFac}{integer. Maximum number of factors included in the models.
              The default is the number of factors in the design.}
  \item{select}{ vector with position numbers of the factors to be included; \cr
              default: all factors. }
  \item{mInt}{integer <= 3. Maximum order of interactions considered in the models.
              This can strongly impact the result.}
  \item{p}{numeric. Prior probability assigned to active factors.
              This can strongly impact the result.}
  \item{g}{numeric vector. Variance inflation factor(s) gamma associated to active and interaction factors;
              see "Details" section}
  \item{ng}{integer <=20. Number of different variance inflation factors (g) used in calculations.}
  \item{nMod}{integer <=100. Number of models to keep with the highest posterior probability.}
}

\details{
Factor and model posterior probabilities are computed by the Box and Meyer (1993) Bayesian procedure. 
The design factors - or a selection of these given by column numbers in \code{select} - 
are considered together with the specified response or the first response of the design. 
The function has been adapted from function \code{\link[BsMD]{BsProb}} in package \pkg{BsMD}, 
and a vignette in that package (\url{../../BsMD/doc/BsMD.pdf}) explains 
details of the usage regarding the parameters.

If \code{g}, the variance inflation factor (VIF) gamma, is a vector of length 1, 
the same VIF is used for factor main effects and interactions. 
If the length of \code{g} is 2 and \code{ng} is 1, \code{g[1]} 
is used for factor main effects and \code{g[2]} for the interaction effects. 
If \code{ng} greater than 1, then \code{ng} values of VIFs between \code{g[1]} and 
\code{g[2]} are used for calculations with the same gamma value for main effects 
and interactions. The function calls the FORTRAN subroutine \code{bm} and captures 
summary results. The complete output of the FORTRAN code is save in the \code{BsPrint.out} 
file in the working directory. The output is a list of class \code{BsProb} 
for which print, plot and summary methods are available from package \pkg{BsMD}.
}

\value{
    cf. documentation of function \code{\link[BsMD]{BsProb}}
}

\note{
    This method relies on the availability of package \pkg{BsMD}.
}

\references{
Barrios, E. (2013). Using the BsMD Package for Bayesian Screening and Model
   Discrimination. Vignette. \url{../../BsMD/doc/BsMD.pdf}.

Box, G. E. P and R. D. Meyer (1986). An Analysis for Unreplicated Fractional 
      Factorials. \emph{Technometrics} \bold{28}, 11-18.

Box, G. E. P and R. D. Meyer (1993). 
   Finding the Active Factors in Fractionated Screening Experiments. 
   \emph{Journal of Quality Technology} \bold{25}, 94-105. }
\author{Daniel Meyer, ported to R by Ernesto Barrios, port adapted to designs by Ulrike Groemping.}
\examples{
   ### there are several success stories and recommendations for this method
   ### in the simulated example here (not fabricated, 
   ###         it was the first one that came to my mind), 
   ### the method goes wrong, at least when using mInt=2 (the default, because 
   ###         Daniel plots work quite well for pure main effects models):
   ### active factors are A to E (perhaps too many for the method to work),
   ### the method identifies F, J, and L with highest probability 
   ### (but is quite undecided)
   plan <- pb(12)
   dn <- desnum(plan)
   set.seed(8655)
   y <- dn\%*\%c(2,2,2,2,3,0,0,0,0,0,0) + dn[,1]*dn[,3]*2 - dn[,5]*dn[,4] + rnorm(12)/10
   plan.r <- add.response(plan, response=y)
   if (requireNamespace("BsMD", quiet=TRUE)){
   plot(bpmInt2 <- BsProb.design(plan.r), code=FALSE)
   plot(bpmInt1 <- BsProb.design(plan.r, mInt=1), code=FALSE) ## much better!
   summary(bpmInt2)
   summary(bpmInt1)
   }
   ### For comparison: A Daniel plot does not show any significant effects according 
   ### to Lenths method, but makes the right effects stick out
   DanielPlot(plan.r, half=TRUE, alpha=1)
}
\seealso{\code{\link[BsMD]{plot.BsProb}}, \code{\link[BsMD]{print.BsProb}}, 
\code{\link[BsMD]{summary.BsProb}}, \code{\link[BsMD]{BsMD}} }
\keyword{design}
