\name{BLEMISHES}
\alias{BLEMISHES}
\docType{data}
\title{
Number of Blemishes on Ceramic Plates
}
\description{
Blemishes found on each of 30 ceramic plates.
}
\usage{data(BLEMISHES)}
\format{
  A data frame with 30 observations:
    \describe{
    \item{\code{plateID}}{a factor}
    \item{\code{count}}{an integer vector}
  }
}
\details{
Blemishes will affect the final product's 
(hybrid micro electronic components)
electrical performance and its overall yield
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(BLEMISHES)
table(factor(BLEMISHES$count, levels=0:5))
}
\keyword{datasets}
