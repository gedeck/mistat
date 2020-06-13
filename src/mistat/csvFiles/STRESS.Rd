\name{STRESS}
\alias{STRESS}
\docType{data}
\title{
Stress Levels%%   ~~ data name/kind ... ~~
}
\description{
Results of a 33 factorial experiment to investigate the effects of three 
factors \eqn{A, B, C} on the stress levels of a membrane \eqn{Y}. 
The first three columns of the data provide the levels of the 
three factors, and column 4 presents the stress values.
}
\usage{data(STRESS)}
\format{
  A data frame with 27 observations on the following 4 variables.
  \describe{
    \item{\code{A}}{levels of factor \eqn{A}, a numeric vector}
    \item{\code{B}}{levels of factor \eqn{B}, a numeric vector}
    \item{\code{C}}{levels of factor \eqn{C}, a numeric vector}
    \item{\code{stress}}{stress levels of a membrane \eqn{Y}, a numeric vector}
  }
}
\source{
Oikawa and Oka (1987)
}
\examples{
data(STRESS)

summary(                                       
  aov(stress ~ (A+B+C)^3 +I(A^2)+I(B^2)+I(C^2),
      data=STRESS))
}
\keyword{datasets}
