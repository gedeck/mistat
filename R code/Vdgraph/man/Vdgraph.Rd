\name{Vdgraph}
\alias{Vdgraph}
\title{ this function makes a Variance Dispersion Graph of a response surface design 
}
\description{
This function calls the function Vardsgr which uses Vining's (1993) fortran 
code to get the coordinates of a variance dispersion graph, and then makes
the plot.
}
\usage{
Vdgraph(des)
}
\arguments{
  \item{des}{ des is a matrix or a data frame containing a response surface design in coded  or uncoded units. 
There should be one column for each factor in the design, and one row for each run in the design. 
The maximum number of rows allowed is 99, and the maximum number of columns is 7.}
}
\value{ vdgpl
 \item{vdgpl}{This is a graph containing the Variance Dispersion Graph}
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

data(D310)
Vdgraph(D310)



}
\keyword{hplot }
