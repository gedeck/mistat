\name{GASTURBINE}
\alias{GASTURBINE}
\docType{data}
\title{
Gas Turbine Cycle Times
}
\description{
125 gas turbine cycle times divided in 25 samples of 5 observations.
}
\usage{data(GASTURBINE)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(GASTURBINE)

plot(rowMeans(GASTURBINE), type="b")
}
\keyword{datasets}
