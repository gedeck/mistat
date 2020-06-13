\name{PLACE}
\alias{PLACE}
\docType{data}
\title{
Displacements of Electronic Components on Printed Circuit Boards
}
\description{
The observations are the displacements (position errors) of 
electronic components on printed circuit boards. There are 26 
boards. 16 components are placed on each board. Each component 
has to be placed at a specific location (\eqn{x,y}) on a board 
and with correct orientation \eqn{\theta}.
}
\usage{data(PLACE)}
\format{
  A data frame with 416 observations on the following 4 variables.
  \describe{
    \item{\code{crcBrd}}{Circuit board number, a numeric vector}
    \item{\code{xDev}}{Error in placement along the \eqn{x}-axis, a numeric vector}
    \item{\code{yDev}}{Error in placement along the \eqn{y}-axis, a numeric vector}
    \item{\code{tDev}}{Error in orientation \eqn{\theta}, a numeric vector}
  }
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(PLACE)

plot(PLACE[,-1])

boxplot(xDev ~ crcBrd, data=PLACE, 
        ylab="xDev", xlab="crcBrd")

PLACE$code <- factor(c(rep("lDev", 9*16),
                     rep("mDev", 3*16),
                     rep("hDev", 14*16)))
                     
plot(PLACE[,"xDev"], PLACE[,"yDev"],
     pch=as.integer(PLACE[,"code"]),
     main="", xlab="xDev", ylab="yDev")
     
grid()

}
\keyword{datasets}
