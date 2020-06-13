\name{SOCELL}
\alias{SOCELL}
\docType{data}
\title{
Short Circuit Current of Solar Cells
}
\description{
Short circuit current (ISC) of 16 solar cells measured at 
three time epochs, one month apart.
}
\usage{data(SOCELL)}
\format{
  A data frame with 16 observations on the following 3 variables.
  \describe{
    \item{\code{t1}}{ISC at time epoch 1, a numeric vector}
    \item{\code{t2}}{ISC at time epoch 2, a numeric vector}
    \item{\code{t3}}{ISC at time epoch 3, a numeric vector}
  }
}
\details{
Telecommunication sattelites are powered while in orbit
by solar cells. Tadicell, a solar cells producer that supplies several satellite
manufacturers, was requested to provide data on the degradation of its solar
cells over time. Tadicell engineers performed a simulated experiment in which
solar cells were subjected to temperature and illumination changes similar to
those in orbit and measured the short circuit current ISC (ampers), of solar cells
at three different time periods, in order to determine their rate of degradation.
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(SOCELL)

LmISC <- lm(t2 ~ 1 + t1, 
            data=SOCELL)

summary(LmISC)
}
\keyword{datasets}
