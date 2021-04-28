\name{dynOAB}
\alias{dynOAB}
\alias{dynOAB2}

\title{
Dynamic programming of the optimal One-Armed Bandits
}
\description{
Dynamic programming of the optimal One-Armed Bernoulli Bandits process
}
\usage{
dynOAB(N, al)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{N}{
number of trials.
}
  \item{al}{
the known probability of reward on arm A.
}
}

\value{
For dynOAB the matrix of maximal predicted rewards. 
For dynOAB2 the optimal predicted reward.
}

\author{
Shelemyahu Zacks
}

\seealso{
\code{\link{simOAB}}
}

\examples{
dynOAB(10, 0.5)
dynOAB2(10, 0.5)
}

