\name{FDSPlot}
\alias{FDSPlot}
\title{This function makes a Fraction of Design Space Plot of a response surface design.
}
\description{
This function creates a Fraction of Design Space Plot over the hypercube design space from
-1 to 1 on each component.
}
\usage{
FDSPlot(des, mod=2)
}
\arguments{
  \item{des}{ des is a matrix or a data frame containing a response surface design in coded  or uncoded units. 
There should be one column for each factor in the design, and one row for each run in the design. 
The maximum number of rows allowed is 99, and the maximum number of columns is 7.}
  \item{mod}{ mod is the model to be represented. 
              0 = linear model
              1 = linear main effects plus linear by linear 2-factor interactions
              2 = full quadratic response surface model (default.}
}
\references{
1.Zahran, A., Anderson-Cook, C. M.  and Myers,R. H. "Fraction of Design Space to Assess Prediction
Capability of Response Surface Designs" Journal of Quality Technology, Vol 35, No. 4,
pp 377-386. 2003.
}
\author{ John S. Lawson \email{lawson@byu.edu}}
\examples{

data(D310)
FDSPlot(D310)
}
\keyword{hplot }
