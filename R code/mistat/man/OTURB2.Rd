\name{OTURB2}
\alias{OTURB2}
\docType{data}
\title{
Sample Mean and Standard Deviation of Cycle Times of a Piston
}
\description{
In this data frame we have three variables.
In the first we have the sample size. 
In the second and third we have the sample means and standard 
deviation.
}
\usage{data(OTURB2)}
\format{
  A data frame with 10 observations on the following 3 variables.
  \describe{
    \item{\code{groupSize}}{a numeric vector}
    \item{\code{xbar}}{a numeric vector}
    \item{\code{std}}{a numeric vector}
  }
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(OTURB2)
plot(OTURB2$xbar, type="b")
plot(OTURB2$std, type="b")

}
\keyword{datasets}
