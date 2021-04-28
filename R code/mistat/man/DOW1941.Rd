\name{DOW1941}
\alias{DOW1941}
\docType{data}
\title{
Dow-Jones Financial Index 1941
}
\description{
The Dow-Jones daily index of 1941.
}
\usage{data("DOW1941")}
\format{
  A data frame with 302 observations on the following 5 variables.
  \describe{
    \item{\code{DOW1941}}{ Dow-Jones daily value}
    \item{\code{Date}}{a POSIXlt}
    \item{\code{Day}}{a progressive number}
    \item{\code{DayOfWeek}}{a factor representing the weekday with levels \code{1} \code{2} \code{3} \code{4} \code{5} \code{6}}
    \item{\code{Month}}{a factor representing the month with levels \code{1} \code{2} \code{3} \code{4} \code{5} \code{6} \code{7} \code{8} \code{9} \code{10} \code{11} \code{12}}
  }
}

\examples{
data(DOW1941)

plot(DOW1941$Date, DOW1941$DOW1941,          
     type="l", 
     ylab="Dow Jones 1941", xlab="Date")
}
\keyword{datasets}
