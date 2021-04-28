\name{DISSOLUTION}
\alias{DISSOLUTION}
\docType{data}
\title{
DISSOLUTION
}
\description{
12 test and reference tablets measured under dissolution conditions at 5, 10, 15, 20, 30 and 45 seconds.
The level of dissolution recorded for the tested generic product is ideally identical to the brand reference.
}
\usage{data("DISSOLUTION")}
\format{
  A data frame with 144 observations on the following 4 variables.
  \describe{
    \item{\code{Product}}{a factor with levels \code{R} \code{T}}
    \item{\code{Time}}{a numeric vector}
    \item{\code{Label}}{a factor with levels \code{T1} \code{T10} \code{T10R} \code{T11} \code{T11R} \code{T12} \code{T12R} \code{T1R} \code{T2} \code{T2R} \code{T3} \code{T3R} \code{T4} \code{T4R} \code{T5} \code{T5R} \code{T6} \code{T6R} \code{T7} \code{T7R} \code{T8} \code{T8R} \code{T9} \code{T9R}}
    \item{\code{Data}}{a numeric vector}
  }
}

\examples{
data(DISSOLUTION)
Test <- subset(DISSOLUTION, Product == "T")
Test <- reshape(data = Test, v.names = "Data", timevar = "Label",idvar = "Time", direction = "wide")
summary(Test)
# library(fdapace)
# Model <- FPCA(Ly = Test[, grep("Data", colnames(Test))], 
#  Lt = Test[, rep("Time", length(grep("Data", colnames(Test))))], 
#  optns = list(maxK = 5, methodSelectK = 5))
# plot(Model)

}
\keyword{datasets}
