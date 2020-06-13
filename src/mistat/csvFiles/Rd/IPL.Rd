\name{IPL}
\alias{IPL}
\docType{data}
\title{
Number of Computer Crashes per Month
}
\description{
Number of computer crashes per month, due to power failures 
experienced at a computer center, over a period of 28 months. 
After a crash, the computers are made operational with an 
"Initial Program Load".
}
\usage{data(IPL)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(IPL)

plot(IPL, type="b")
}
\keyword{datasets}
