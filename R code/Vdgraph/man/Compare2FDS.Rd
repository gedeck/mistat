\name{Compare2FDS}
\alias{Compare2FDS}
\title{This function compares Fraction of Design Space Plots for two response surface designs.
}
\description{This function compares Fraction of Design Space Plots for two response surface designs with the same number of factors 
over the unit hypercube design space.
}
\usage{
Compare2FDS(des1, des2, name1, name2, mod=2)
}
\arguments{
  \item{des1}{ des1 is a matrix or a data frame containing the first response surface design to be compared 
in coded  or uncoded units. There should be one column for each factor in the design, and one row for each 
run in the design. The maximum number of rows allowed is 99, and the maximum number of columns is 7.}
  \item{des2}{ des2 is a matrix or a data frame containing the second response surface design to be compared 
in coded or uncoded units. There should be one column for each factor in the design, and one row for each 
run in the design. The maximum number of rows allowed is 99, and the maximum number of columns is 7.}
  \item{name1}{ name1 is a character string containing a descriptive name for the first design. This
descriptive name should be no more than 40 characters in order to fit in the space for a legend. If left out 
name1 defaults to des1 }
  \item{name2}{ name2 is a character string containing a descriptive name for the second design. This
descriptive name should be no more than 40 characters in order to fit in the space for a legend. If left out 
name2 defaults to des2 }
  \item{mod}{mod is the model to be represented. 
              0 = linear model
              1 = linear main effects plus linear by linear 2-factor interactions
              2 = full quadratic response surface model (default.}
}
\references{1.Zahran, A., Anderson-Cook, C. M.  and Myers,R. H. "Fraction of Design Space to Assess Prediction
Capability of Response Surface Designs" Journal of Quality Technology, Vol 35, No. 4,
pp 377-386. 2003. 
}
\author{ John S. Lawson \email{lawson@byu.edu}}
\examples{
data(SCDH5)
data(SCDDL5)
Compare2FDS(SCDH5, SCDDL5, "Hartley SCD-5", "Draper-Lin SCD5", mod=2) 
}
\keyword{ hplot }
