\name{Compare2Vdg}
\alias{Compare2Vdg}
\title{ this function compares Variance Dispersion Graph of two response surface designs with the same number of factors 
on the same scale
}
\description{
This function calls the function Vardsgr which uses Vining's (1993) fortran 
code to get the coordinates of a two variance dispersion graph, and then makes
the plot.
}
\usage{
Compare2Vdg(des,des2,name1,name2,ncolleg)
}
\arguments{
  \item{des}{ des is a matrix or a data frame containing the first response surface design to be compared 
in coded  or uncoded units. There should be one column for each factor in the design, and one row for each 
run in the design. The maximum number of rows allowed is 99, and the maximum number of columns is 7.}
  \item{des2}{ des2 is a matrix or a data frame containing the second response surface design to be compared 
in coded or uncoded units. There should be one column for each factor in the design, and one row for each 
run in the design. The maximum number of rows allowed is 99, and the maximum number of columns is 7.}
  \item{name1}{ name1 is a character string containing a descriptive name for the first design. This
descriptive name should be no more than 40 characters in order to fit in the space for a legend. If left out 
name1 defaults to des }
  \item{name2}{ name2 is a character string containing a descriptive name for the second design. This
descriptive name should be no more than 40 characters in order to fit in the space for a legend. If left out 
name2 defaults to des2 }
  \item{ncolleg}{ The number of columns in the legend this can be 1 or 2}
}
\value{ vdgpl
 \item{vdgpl}{This is a graph containing the two Variance Dispersion Graphs, one for each design}
}
\references{
1. Vining, G. "A Computer Program for Generating Variance Dispersion Graphs" 
Journal of Quality Technology, Vol 25, No. 1, pp. 45-58, 1993.
2. Vining, G. "Corrigenda" Journal of Quality Technology, Vol 25, No. 4,
pp 333-335. 1993.
 
}
\note{ This function calls the function Vardsgr to get the coordinates for the plot.}
\author{ John S. Lawson \email{lawson@byu.edu}}
\examples{

data(SCDH5)
data(SCDDL5)
Compare2Vdg(SCDH5,SCDDL5,"Hartley's SCD-5","Draper-Lin's SCD-5 fac",ncolleg=1)




}
\keyword{ hplot }
