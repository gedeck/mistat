\name{GASOL}
\alias{GASOL}
\docType{data}
\title{
Distillation Properties of Crude Oils
}
\description{
32 measurements of distillation properties of crude oils.
}
\usage{data(GASOL)}
\format{
  A data frame with 32 observations on the following 5 variables.
  \describe{
    \item{\code{x1}}{crude oil gravity (\eqn{API}), a numeric vector}
    \item{\code{x2}}{crude oil vapour pressure (\eqn{psi}), a numeric vector}
    \item{\code{astm}}{crude oil ASTM 10\% point (\eqn{Fahrenheit}), a numeric vector}
    \item{\code{endPt}}{gasoline ASTM endpoint (\eqn{Fahrenheit}), a numeric vector}
    \item{\code{yield}}{yield of gasoline (in percentage of crude oil), a numeric vector}
  }
}
\source{
Daniel and Wood (1971) pp. 165
}
\examples{
data(GASOL)

LmYield <- lm(yield ~ 1 + astm + endPt, 
              data=GASOL)

summary(LmYield)
}
\keyword{datasets}
