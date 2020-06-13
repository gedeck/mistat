\name{HADPAS}
\alias{HADPAS}
\docType{data}
\title{
Resistance Values of Hybrids
}
\description{
Several resistance measurements (\eqn{\Omega}) of five types 
of resistances (Res 3, Res 18, Res 14, Res 7 and Res 20), 
which are located in six hybrid micro circuits simultaneously
manufactured on ceramic substrates. 
There are altogether 192 records for 32 ceramic plates.
}
\usage{data(HADPAS)}
\format{
  A data frame with 192 observations on the following 7 variables.
  \describe{
    \item{\code{diska}}{ceramic plate, a numeric vector}
    \item{\code{hyb}}{hybrid micro circuit, a numeric vector}
    \item{\code{res3}}{a numeric vector}
    \item{\code{res18}}{a numeric vector}
    \item{\code{res14}}{a numeric vector}
    \item{\code{res7}}{a numeric vector}
    \item{\code{res20}}{a numeric vector}
  }
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(HADPAS)

boxplot(HADPAS$res3 ~ HADPAS$hyb)
}
\keyword{datasets}
