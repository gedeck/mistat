\name{ALMPIN}
\alias{ALMPIN}
\alias{ALMPIN2}
\docType{data}
\title{
Aluminium Pins (6 dimensions)
}
\description{
Records of 6 dimension variables (a subset of 2 in \code{ALMPIN2}) 
measured in \eqn{mm} on 70 alluminium pins used in airplanes, 
in order of production.
}
\usage{data(ALMPIN)}
\format{
  A data frame with 70 observations on the following 6 variables.
  \describe{
    \item{\code{diam1}}{pin diameter at specified location, a numeric vector}
    \item{\code{diam2}}{pin diameter at specified location, a numeric vector}
    \item{\code{diam3}}{pin diameter at specified location, a numeric vector}
    \item{\code{capDiam}}{diameter of the cap on top of the pin, a numeric vector}
    \item{\code{lenNocp}}{length of the pin without the cap, a numeric vector}
    \item{\code{lenWcp}}{length of the pin with the cap, a numeric vector}
  }
}
\details{
The aluminum pins are inserted with air-guns
in pre-drilled holes in order to combine critical airplane parts such as wings,
engine supports and doors.

The measurements were taken in a
computerized numerically controlled (CNC) metal cutting operation.  The
six variables are Diameter 1, Diameter 2, Diameter 3, Cap Diameter,
Lengthncp and Lengthwcp.  All the measurements are in millimeters.  The
first three variables give the pin diameter at three specified
locations.  Cap Diameter is the diameter of the cap on top of the pin.
The last two variables are the length of the pin, without and with the
cap, respectively.
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
