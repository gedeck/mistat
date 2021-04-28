\name{predARMA}
\alias{predARMA}

\title{
Prediction of an AR 3 process
}
\description{
For isslustration purposes this implements the prediction of an ARMA(3, 0) process.
}
\usage{
predARMA(X, a)
}

\arguments{
  \item{X}{
a vector of data X_t.
}
  \item{a}{
vector p of parameters.
}
}

\value{
a vector with values from the quadratic predictor.
}

\author{
Shelemyahu Zacks
}

\seealso{
\code{\link{ARMA}}
}
\examples{
set.seed(123)
predARMA(ARMA(100,c(0.1, 0.2, 0.3), c(0.1, 0.2)), c(0.1, 0.2, 0.3))
}
