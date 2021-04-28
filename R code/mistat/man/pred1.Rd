\name{pred1}
\alias{pred1}

\title{
Linear Predictor for Covariance Stationary Time Series
}
\description{
An Optimal Linear Predictor for Covariance Stationary Time Series.
}
\usage{
pred1(x, n = 10)
}

\arguments{
  \item{x}{
a vector of data X_t.
}
  \item{n}{
the n to define the window size.
}
}

\value{
a vector with values form the linear predictor.
}

\author{
Shelemyahu Zacks
}

\examples{
pred1(rnorm(20), n = 10)
}

