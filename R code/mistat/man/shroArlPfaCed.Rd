\name{shroArlPfaCed}
\alias{shroArlPfaCedPois}
\alias{shroArlPfaCedNorm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ARL, PFA and CED of Shiryayev-Roberts procedure
}
\description{
Average Run Length, the Probability of False Alarm and the 
Conditional Expected Delay, given that the alarm is
given after the change-point for Normal and Poisson cases
}
\usage{
shroArlPfaCedNorm(mean0 = 0, mean1 = NA, sd = 1, n = 10, 
                  delta = 1, tau = NA, N = 100, limit = 10000, 
                  seed = NA, w = 19, printSummary = TRUE)
                  
shroArlPfaCedPois(lambda0 = 10, lambda1 = NA, delta = 1, 
                  tau = NA, N = 100, limit = 10000, seed = NA, 
                  w = 19, printSummary = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mean0}{
value of the mean of a normal distributed process
}
  \item{mean1}{
optional value of the mean after a shift in a normal process, 
ignored if \code{delta} is not \code{NA}
}
  \item{sd}{
standard deviation of a normal distributed process
}
  \item{n}{
sample size
}
  \item{lambda0}{
mean of a Poisson distributed process
}
  \item{lambda1}{
optional value of the mean after a shift in a Poisson process, 
ignored if \code{delta} is not \code{NA}
}
  \item{delta}{
value of the shift from \code{mean0} or \code{lambda0}, set to 
\code{NA} if the alternative specification with \code{mean1} 
or \code{lambda1} is needed
}
  \item{tau}{
location of the point of change in the process parameter 
\code{mean0} or \code{lambda0}, if \code{NA} simulation is 
perfomed  without any shift: \code{mean1}, \code{lambda1} and 
\code{delta} are ignored
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
  \item{w}{
Shiryayev-Roberts statistics used as the stopping threshold
}
  \item{printSummary}{
logical, if \code{TRUE} print a summary of the Shiryayev-Roberts ARL, PFA and CED
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
shroArlPfaCedNorm(mean0=10, 
                  sd=3, 
                  n=5, 
                  delta=0.5, 
                  tau=10, 
                  w=99, 
                  seed=123)
                  
shroArlPfaCedPois(lambda0=5, 
                  delta=0.5, 
                  tau=10, 
                  w=99, 
                  seed=123)

shroArlPfaCedNorm(mean0=15, 
                  sd=3, 
                  n=5, 
                  delta=0.5, 
                  tau=NA, 
                  w=99, 
                  seed=123)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ nonparametric }
\keyword{ ts }
