\name{INSERTION}
\alias{INSERTION}
\docType{data}
\title{
Components Insertions into a Board
}
\description{
Data represents a large number of insertions with \eqn{k=9} 
different components.  The result of each trial (insertion) is 
either Success (no insertion error) or Failure (insertion
error).
}
\usage{data(INSERTION)}
\format{
  A data frame with 9 (\eqn{k}) observations on the following 3 variables.
  \describe{
    \item{\code{comp}}{Component, a factor with levels \code{C1} \code{C2} \code{C3} \code{C4} \code{C5} \code{C6} \code{C7} \code{C8} \code{C9}}
    \item{\code{fail}}{Failure, a numeric vector}
    \item{\code{succ}}{Success, a numeric vector}
  }
}
\details{
Components are:

\code{C1:} Diode

\code{C2:} 1/2 Watt Canister

\code{C3:} Jump Wire

\code{C4:} Small Corning

\code{C5:} Large Corning 

\code{C6:} Small Bullet

\code{C7:} 1/8 Watt Dogbone

\code{C8:} 1/4 Watt Dogbone

\code{C9:} 1/2 Watt Dogbone
}
\source{
See \code{\link{PLACE}}
}
\examples{
data(INSERTION)

barplot(INSERTION$fail / 
          (INSERTION$fail + INSERTION$succ) * 
          100, 
        names.arg=INSERTION$comp, 
        ylab= "Percentage")
        
}
\keyword{datasets}
