\name{CAR}
\alias{CAR}
\docType{data}
\title{
Car
}
\description{
Records on 109 different car models, including number of cylinders,
origin, turn diamater, horsepower, and number of miles per gallon 
in city driving.
}
\usage{data(CAR)}
\format{
  A data frame with 109 observations on the following 5 variables.
  \describe{
    \item{\code{cyl}}{Number of cylinders, an integer vector}
    \item{\code{origin}}{Car origin, 1 = US; 2 = Europe; 3 = Asia, an integer vector}
    \item{\code{turn}}{Turn diamater, a numeric vector}
    \item{\code{hp}}{Horsepower, a numeric vector}
    \item{\code{mpg}}{Miles per gallon in city driving, a numeric vector}
  }
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(CAR)

with(data=CAR, expr=table(cyl, origin))
}
\keyword{datasets}
