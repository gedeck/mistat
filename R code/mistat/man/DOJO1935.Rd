\name{DOJO1935}
\alias{DOJO1935}
\docType{data}
\title{
Dow-Jones Financial Index 1935
}
\description{
The Dow-Jones financial index for the 300 business days of 1935.
}
\usage{data(DOJO1935)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(DOJO1935)

plot(DOJO1935,          
     type="b", 
     ylab="Dow Jones")
}
\keyword{datasets}
