\name{ALMPIN}
\alias{ALMPIN}
\alias{ALMPIN2}
\docType{data}
\title{
Aluminium Pins (2 dimensions)
}
\description{
Records of 2 dimension variables (a subset of \code{ALMPIN}) 
measured in \eqn{mm} on 70 alluminium pins used in airplanes, 
in order of production.
}
\usage{data(ALMPIN)}
\format{
  A data frame with 70 observations on the following 2 variables.
  \describe{
    \item{\code{capDiam}}{diameter of the cap on top of the pin, a numeric vector}
    \item{\code{lenNocp}}{length of the pin without the cap, a numeric vector}
  }
}
\details{
For details see dataset \code{ALMPIN}
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(ALMPIN)

cor(ALMPIN)

plot(ALMPIN)
}
\keyword{datasets}
