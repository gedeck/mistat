\name{ELECINDX}
\alias{ELECINDX}
\docType{data}
\title{
Bernoulli Sample on OELECT Data
}
\description{
Bernoulli sample in which, we give a circuit in OELECT 
the value 1 if its electric output is in the interval 
(216, 224) and the value 0 otherwise. 
}
\usage{data(ELECINDX)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\seealso{
  \code{\link{OELECT}}
}
\examples{
data(ELECINDX)

qbinom(p=0.5, size=100, prob=mean(ELECINDX))
}
\keyword{datasets}
