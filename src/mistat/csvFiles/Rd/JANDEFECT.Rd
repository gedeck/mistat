\name{JANDEFECT}
\alias{JANDEFECT}
\docType{data}
\title{
January Number of Defects in Daily Samples
}
\description{
Number of defective items found in random samples of size 
\eqn{n = 100}, drawn daily from a production line in January.
}
\usage{data(JANDEFECT)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(JANDEFECT)

plot(JANDEFECT, type="b")
}
\keyword{datasets}
