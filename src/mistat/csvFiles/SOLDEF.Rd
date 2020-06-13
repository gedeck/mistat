\name{SOLDEF}
\alias{SOLDEF}
\docType{data}
\title{
Solder Defects
}
\description{
Solder defects on 380 printed circuits boards of varying size.
}
\usage{data(SOLDEF)}

\details{
In SOLDEF we present results of testing batches
of circuit boards for defects in solder points, after wave solderings. The batches
includes boards of similar design. There were close to 1,000 solder points on each
board. The results Xtare number of defects per \eqn{10^6} points \emph{(PPM)}. The quality
standard is \eqn{\lambda_0 = 100 (PPM)}. \eqn{\lambda_t} values below \eqn{\lambda_0} 
represent high quality soldering.
In this data file there are N = 380 test results. Only 78 batches had an \eqn{X_t} value
greater than \eqn{\lambda_0 = 100}.
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(SOLDEF)

hist(SOLDEF)
}
\keyword{datasets}
