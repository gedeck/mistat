\name{DISS}
\alias{DISS}
\docType{data}
\title{
Dissolution Data
}
\description{
Dissolution data of a new product and a reference approved product.
}
\usage{data(DISS)}
\format{
  A data frame with 12 observations on the following 4 variables.
  \describe{
    \item{\code{batch}}{a factor with levels \code{REF} \code{TEST}}
    \item{\code{tablet}}{a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5} \code{6}}
    \item{\code{min15}}{a numeric vector}
    \item{\code{min90}}{a numeric vector}
  }
}
\source{
Tsong et al., (1996).
}
\examples{
data(DISS)
## maybe str(DISS) ; plot(DISS) ...
}
\keyword{datasets}
