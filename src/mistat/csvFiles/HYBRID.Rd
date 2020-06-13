\name{HYBRID}
\alias{HYBRID}
\alias{HYBRID1}
\alias{HYBRID2}
\docType{data}
\title{
Resistance Values of Res 3
}
\description{
A subset of data in HADPAS, only variable \code{res3} is 
recorded. HYBRID contains values for hybrids 1 to 3, HYBRID1 contains 
hybrid 1 data and HYBRID2 contains values of hybrids 1 and 2.
}
\usage{data(HYBRID)}
\format{
  A data frame (a vector for HYBRID1) with 32 observations on the following variables.
  \describe{
    \item{\code{hyb1}}{resistance measurements (\eqn{\Omega}) of Res 3, a numeric vector}
    \item{\code{hyb2}}{resistance measurements (\eqn{\Omega}) of Res 3, a numeric vector}
    \item{\code{hyb3}}{resistance measurements (\eqn{\Omega}) of Res 3, a numeric vector}
  }
}
\source{
See \code{\link{HADPAS}}
}
\examples{
data(HYBRID)

lapply(HYBRID, var)
}
\keyword{datasets}
