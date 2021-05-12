\name{Vardsgr}
\alias{Vardsgr}
\title{ Loads compiled fortran in shared file vdg}
\description{This function loads and runs the compiled fortran code vdg. vdg is Vining's 1999 JQT fortran code for producing variance dispersion graphs. }
\usage{  
Vardsgr(ndpts, kvar1, kdv1, rdes)
}
\arguments{
  \item{ndpts}{ This is the number of runs in the response surface design (maximum=99).}
  \item{kvar1}{ This is the  number of factors in the design matrix (maximum=6).}
  \item{kdv1}{ This is the product of ndpts and kvar1.}
  \item{rdes}{ This is the response surface design matrix stored as a vector of the 
concatenated columns of the design matrix, one column for each factor in the design.}
}
\value{ vdgr
\item{vdgr }{ This is the matrix of coordinates for the variance dispersion graph. It is stored 
as a vector of concatenated columns. Each column is of length 20, and there are 
four columns in the matrix. The first column is the radius from the center of the 
response surface design. The second column is the maximum variance of
a predicted value, the third column is the minimum variance
of a predicted value, and the fourth column is the average variance of a predicted value. }
}
\references{
1. Vining, G. "A Computer Program for Generating Variance Dispersion Graphs"
Journal of Quality Technology, Vol 25, No. 1, pp. 45-58, 1993.
2. Vining, G. "Corrigenda" Journal of Quality Technology, Vol 25, No. 4, pp 333-335. 1993.
 
}
\note{ This function is called by the function Vdgraph.}
\author{ John S. Lawson \email{lawson@byu.edu}}
\keyword{interface}
