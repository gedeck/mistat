\name{PRED}
\alias{PRED}
\docType{data}
\title{
Soldering Points
}
\description{
1,000 records on variable \code{x} and \code{y}. \code{x} is 
the number of soldering points on a board, and \code{y} is the 
number of defective soldering points.
}
\usage{data(PRED)}
\format{
  A data frame with 1000 observations on the following 2 variables.
  \describe{
    \item{\code{x}}{Number of soldering points, a numeric vector}
    \item{\code{y}}{Number of defective soldering points, a numeric vector}
  }
}
\details{
Electronic systems such as television sets, radios or computers 
contain printed circuit boards with electronic components 
positioned in patterns determined by design engineers. After 
assembly (either by automatic insertion machines or manually) 
the components are soldered to the board. In the relatively new 
Surface Mount Technology minute components are simultaneously 
positioned and soldered to the boards. The occurrence of 
defective soldering points impacts the assembly plant 
productivity and is therefore closely monitored
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(PRED)

library(boot)

set.seed(123)

YRatioPred <- boot(data=PRED$x, 
                   statistic=function(x,i){
                     mean(x[i[1:100]])*7.495/148.58
                     }, 
                   R=1000)$t

hist(YRatioPred, main="", 
     xlab="", 
     xlim=c(7, 8))
}
\keyword{datasets}
