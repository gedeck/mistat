\name{OTURB1}
\alias{OTURB1}
\docType{data}
\title{
Cycle Times of a Piston from the Piston Simulator
}
\description{
50 cycle times (in \eqn{s})of a piston gerated with \code{pistonSimulation(seed=123)}.
Cycle times are rounded to 3 decimals.
}
\usage{data(OTURB1)}
\references{
See \code{\link{pistonSimulation}}
}
\examples{
data(OTURB1)

REF <- round(pistonSimulation(seed=123)$seconds, 3)

plot(OTURB1, type="b", lwd=6)

lines(REF, col=2, lwd=2)

sum(OTURB1 - REF)
}
\keyword{datasets}
