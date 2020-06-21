\name{YARNSTRG}
\alias{YARNSTRG}
\docType{data}
\title{
Yarn strength
}
\description{
Yarn strength  is typically analyzed on a logarithmic 
scale. This logarithmic transformation produces data that is more 
symmetrically distributed. in YARNSTRG data there are \eqn{n = 100} 
values of \eqn{Y = \ln(X)}{Y = ln(X)} where \eqn{X} is the yarn-strength 
in \eqn{lb./22 yarns} of woolen fibers.
}
\usage{data(YARNSTRG)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(YARNSTRG)

hist(YARNSTRG,  
     breaks=6,  
     main="",   
     xlab = "Log yarn strength")
}
\keyword{datasets}
