\name{MPG}
\alias{MPG}
\docType{data}
\title{
Gasoline Consumption of Cars by Origin
}
\description{
Gasoline consumption (in miles per gallon in city driving) of 
cars by origin. There are 3 variables representing samples of 
sizes \eqn{n1 = 58}, \eqn{n2 = 14} and \eqn{n3 = 37}.
}
\usage{data(MPG)}
\format{
  A data frame with 58 observations on the following 3 variables.
  \describe{
    \item{\code{origin1}}{Gasoline consumption, a numeric vector}
    \item{\code{origin2}}{Gasoline consumption, a numeric vector}
    \item{\code{origin3}}{Gasoline consumption, a numeric vector}
  }
}
\source{
See \code{\link{CAR}}
}
\examples{
data(MPG)

library(boot)

set.seed(123)

B <- apply(MPG, MARGIN=2, 
           FUN=boot, 
           statistic=function(x, i){
             var(x[i], na.rm = TRUE)
           }, 
           R = 500)

Bt0 <- sapply(B, 
              FUN=function(x) x$t0)

Bt <-  sapply(B, 
              FUN=function(x) x$t)

Bf <- max(Bt0)/min(Bt0)

FBoot <- apply(Bt, MARGIN=1, 
               FUN=function(x){
                 max(x)/min(x)
               })

Bf

quantile(FBoot, 0.95)

sum(FBoot >= Bf)/length(FBoot)

rm(Bt0, Bt, Bf, FBoot)
}
\keyword{datasets}
