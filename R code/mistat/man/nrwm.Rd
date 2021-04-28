\name{nrwm}
\alias{nrwm}

\title{
Normal Random Walk
}
\description{
Normal Random Walk with a Bayesian prediction.
}
\usage{
nrwm(n, v, w, c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{
length.
}
  \item{v}{ 
  prior variance of V_0.

}
  \item{w}{ 
  prior variance of W_0.

}
  \item{c}{
  variance of the prior Normal Distribution.
}
}

\value{
  \item{nrw }{realizations of a Normal Random Walk}
  \item{Mt }{posterior expectation m_t}
}

\author{
Shelemyahu Zacks
}


%% ~Make other sections like Warning with \section{Warning }{....} ~


\examples{
nrwm(n = 10, v = 5, w = 8, c = 0.5)
}

