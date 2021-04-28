\name{SeasCom}
\alias{SeasCom}
\docType{data}
\title{
Monthly demand for a commodity
}
\description{
Monthly demand for a seasonal commodity during 102 months.
}
\usage{data("SeasCom")}
\format{
  The format is:
 num [1:102] 72 56.4 64.9 59.9 51.6 ...
}

\examples{
data(SeasCom)

plot(SeasCom,          
     type="b", 
     ylab="Dow Jones")
}
\keyword{datasets}
