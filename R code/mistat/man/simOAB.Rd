\name{simOAB}
\alias{simOAB}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bayesian One-Armed Bernoulli Bandits process
}
\description{
Simulate the expected number of trials on arm B before switching to the known arm A, and the expected reward. 

}
\usage{
simOAB(N, p, al, k, gam, Ns)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{N}{
number of trials.
}
  \item{p}{
the probability of reward on arm B (unknown).
}
  \item{al}{
the known probability of reward on arm A.
}
  \item{k}{
the initial sample size on arm B.
}
  \item{gam}{
Bayesian confidence level.
}
  \item{Ns}{
number of runs in the simulation.
}
}


\value{
  \item{MeanValueStoppingTime }{mean value at the stopping time}
  \item{StandardDeviationST }{standard deviation of the value at the stopping time}
  \item{MeanValueExpectedReward }{mean value of the expected reward}
  \item{StandardDeviationST }{standard deviation of the expected reward}
}

\author{
Shelemyahu Zacks
}

\seealso{
\code{\link{dynOAB}}
}
\examples{
set.seed(123)
simOAB(N = 50, p = 0.6, al = 0.5, k = 10, gam = 0.95, Ns = 1000)
}

