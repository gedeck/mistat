\name{RNORM10}
\alias{RNORM10}
\docType{data}
\title{
Random Sample from N(10, 1)
}
\description{
Random sample of size \eqn{n = 28} from the normal distribution \eqn{N(10,1)}.
}
\usage{data(RNORM10)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(RNORM10)

plot(RNORM10, type="b")

abline(h=10, lwd=2, col=2)
}
\keyword{datasets}
