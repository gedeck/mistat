\name{CONTACTLEN}
\alias{CONTACTLEN}
\docType{data}
\title{
Length of the Electrical Contacts
}
\description{
length (in \eqn{cm}) of the electrical contacts of relays in samples 
of size five, taken hourly from a running process.
}
\usage{data(CONTACTLEN)}
\format{
  A numeric matrix with five columns representing a sample and
  twenty rows representing hourly samples.
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(CONTACTLEN)

library(qcc)

qcc(CONTACTLEN, type="xbar")
}
\keyword{datasets}
