\name{LATHYPPISTON}
\alias{LATHYPPISTON}
\docType{data}
\title{
Latin Hypercube Design for the Piston Simulator
}
\description{
A Latin Hypercube Design for the 7 \code{pistonSimulation} arguments
and Its response in seconds.
}
\usage{data(LATHYPPISTON)}
\format{
  A data frame with 14 observations on the following 8 variables.
  \describe{
    \item{\code{m}}{a numeric vector}
    \item{\code{s}}{a numeric vector}
    \item{\code{v0}}{a numeric vector}
    \item{\code{k}}{a numeric vector}
    \item{\code{p0}}{a numeric vector}
    \item{\code{t}}{a numeric vector}
    \item{\code{t0}}{a numeric vector}
    \item{\code{seconds}}{a numeric vector}
  }
}
\source{
  Kenett, R., Zacks, S. with contributions by Amberti, D.
  \emph{Modern Industrial Statistics: with applications in R, MINITAB and JMP}.
  Wiley.
}
\seealso{
\code{\link{pistonSimulation}}
}
\examples{
data(LATHYPPISTON)

library(DiceEval)

Dice <- km(design=LATHYPPISTON[, !names(LATHYPPISTON) \%in\% "seconds"], 
            response=LATHYPPISTON[,"seconds"])

#library(DiceView)

#sectionview(Dice, 
#            center=colMeans(LATHYPPISTON[, !names(LATHYPPISTON) \%in\% "seconds"]), 
#            conf_lev=c(0.5, 0.9, 0.95), 
#            title="", col_sur="darkgrey", lwd=2,
#            Xname=colnames(LATHYPPISTON[, !names(LATHYPPISTON) \%in\% "seconds"]))


layout(1)
}
\keyword{datasets}
