\name{FAILTIME}
\alias{FAILTIME}
\docType{data}
\title{
Failure Times
}
\description{
Failure times of 20 electric generators (in \eqn{hr}).
}
\usage{data(FAILTIME)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(FAILTIME)

library(survival)

SuRe <- survreg(
  Surv(time=FAILTIME) ~ 1 , 
  dist = "exponential")

summary(SuRe)
}
\keyword{datasets}
