\name{cusumArl}
\alias{cusumArl}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Cumulative Sum Control Charts Average Run Length
}
\description{
Computes the ARL function by simulation
}
\usage{
cusumArl(..., randFunc = rnorm, N = 100, limit = 10000, seed = NA, 
         kp = 1, km = -1, hp = 3, hm = -3, side = "both", 
         printSummary = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
arguments such as mean, lambda or sd to be passed to the 
appropriate random genneration function
}
  \item{randFunc}{
a random generation function
}
  \item{N}{
the number of replicates
}
  \item{limit}{
safety parameter, stop rule for procedures with very long ARL
}
  \item{seed}{
a single value, interpreted as an integer. If specified make 
the simulation replicable.
}
  \item{kp}{
\eqn{K^+} parameter of the control scheme
}
  \item{km}{
\eqn{K^-} parameter of the control scheme
}
  \item{hp}{
\eqn{h^+} parameter of the control scheme
}
  \item{hm}{
\eqn{h^-} parameter of the control scheme
}
  \item{side}{
a character string specifying the side of the control scheme, 
must be one of "both" (default), "upper" or "lower"
}
  \item{printSummary}{
logical, if \code{TRUE} print a summary of the cusum ARL
}
}
\value{
a list with elements:
  \item{rls }{a numeric vector representing the Run Length of the 
  simulation}
  \item{statistics }{a numeric vector with summary statistics}
  \item{run}{a list of length \code{N} elements each of which 
  has single numeric elements \code{violationLower}, \code{violationUpper} 
  and \code{rl}}
}
\references{
  Kenett, R., Zacks, S. with contributions by Amberti, D.
  \emph{Modern Industrial Statistics: with applications in R, MINITAB and JMP}.
  Wiley.
}
\author{
Daniele Amberti
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{
cusumArl(mean=1, seed=123, N=100, limit=1000)

cusumArl(size=100, prob=0.05, kp=5.95, km=3.92, hp=12.87, hm=-8.66, 
  randFunc=rbinom, seed=123, N=100, limit=2000)
  
cusumArl(lambda=10, kp=12.33, km=8.41, hp=11.36, hm=-12.91, 
  randFunc=rpois, seed=123, N=100, limit=2000)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ nonparametric }
\keyword{ ts }

