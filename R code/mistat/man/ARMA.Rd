\name{ARMA}
\alias{ARMA}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Random realization of ARMA prcess
}
\description{
Creates a random realization an of ARMA prcess.
}
\usage{
ARMA(n, a, b)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{
length of the ARMA process to be generated.
}
  \item{a}{
vector p of parameters.
}
  \item{b}{
vector q of parameters.
}
}

\value{
a vector with values from the simulated AMRA process of lenght n + max(p, q)
}

\author{
Shelemyahu Zacks
}

\seealso{
\code{\link{predARMA}}
}
\examples{
ARMA(100,c(0.1, 0.2, 0.3), c(0.1, 0.2))
}

