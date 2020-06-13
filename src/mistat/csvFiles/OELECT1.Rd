\name{OELECT1}
\alias{OELECT1}
\docType{data}
\title{
Electric Voltage Outputs of Another Rectifying Circuit
}
\description{
25 electric voltage outputs of a rectifying circuit (\eqn{V}).
}
\usage{data(OELECT1)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(OELECT)

data(OELECT1)

randomizationTest(list(a=OELECT, b=OELECT1), 
                  R=500, calc=mean, 
                  fun=function(x) x[1]-x[2])
}
\keyword{datasets}
