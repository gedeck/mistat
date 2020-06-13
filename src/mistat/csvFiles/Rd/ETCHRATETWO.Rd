\name{ETCHRATETWO}
\alias{ETCHRATETWO}
\docType{data}
\title{
Data on the Rate of Etching (two samples)
}
\description{
Rate of removal of field oxide in two different semiconductor plasma etching processes, A and B.
}
\usage{data(ETCHRATETWO)}
\format{
  A data frame with 12 observations on the following 2 variables.
  \describe{
    \item{\code{A}}{a numeric vector, rate of etching, sample A}
    \item{\code{B}}{a numeric vector, rate of etching, sample B}
  }
}
\source{
  Digital Equipment Corporation (1988). 
}
\examples{
data(ETCHRATETWO)

boxplot(values ~ ind, data=stack(ETCHRATETWO))
}
\keyword{datasets}
