\name{cusumPfaCed}
\alias{cusumPfaCedBinom}
\alias{cusumPfaCedNorm}
\alias{cusumPfaCedPois}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Cusum Probability of False Alarm and Conditional Expected Delay
}
\description{
Compute the Probability of False Alarm, PFA, and the Conditional 
Expected Delay, CED, for the Normal, Binomial and Poisson distributions
}
\usage{
cusumPfaCedBinom(size0 = 0, prob0 = 1, size1 = 0, prob1 = 1, 
                 tau = 10, N = 100, limit = 10000, seed = NA, 
                 kp = 1, km = -1, hp = 3, hm = -3, side = "both", 
                 printSummary = TRUE)

cusumPfaCedNorm(mean0 = 0, sd0=1, mean1=0, sd1=1, 
                tau=10, N=100, limit=10000, seed=NA, 
                kp=1, km=-1, hp=3, hm=-3, side="both", 
                printSummary = TRUE) 

cusumPfaCedPois(lambda0 = 0, lambda1=1, 
                tau=10, N=100, limit=10000, seed=NA, 
                kp=1, km=-1, hp=3, hm=-3, side="both", 
                printSummary = TRUE) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{size0}{
number of trials (zero or more)
}
  \item{prob0}{
probability of success on each trial
}
  \item{size1}{
number of trials (zero or more) after a process level change
}
  \item{prob1}{
probability of success on each trial after a process level change
}
  \item{mean0}{
distribution mean
}
  \item{sd0}{
distribution standard deviation
}
  \item{mean1}{
distribution mean after a process level change
}
  \item{sd1}{
distribution standard deviation after a process level change
}
  \item{lambda0}{
(non-negative) mean
}
  \item{lambda1}{
(non-negative) mean after a process level change
}
  \item{tau}{
time on which the process level change occurs
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
logical, if \code{TRUE} print a summary of the cusum PFA and CED
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
cusumPfaCedNorm(mean1=1.5, 
                tau=100, 
                N=100, 
                limit=1000,
                seed=123)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ nonparametric }
\keyword{ ts }

