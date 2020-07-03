\name{utilitiesPB}
\alias{williamson}
\alias{double.des}
\alias{circ.mat}
\alias{normalize.col.first}
\alias{normalize.row.last}
\alias{des.recode}
\alias{taguchi}
\alias{boxtyssedal}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~ Internal utility functions ~~ }
\description{
  Internal functions, mainly for calculation of Plackett-Burman and other non-regular screening designs. 
  They need not be accessed for normal use of the package. 
}
\usage{
circ.mat(gen) 
double.des(des)
normalize.col.first(mat)
normalize.row.last(mat)
williamson(A,B,C,D)
taguchi(nruns)
boxtyssedal(nruns,k)
des.recode(var, recodes, as.factor.result, char)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gen}{ ~~Generating vector for circular design matrix (used in Plackett-Burman construction)}
  \item{des}{ ~~numeric design matrix (elements -1 / +1 ) to be doubled}
  \item{mat}{ ~~numeric design matrix (elements -1 / +1 ) to be normalized }
  \item{A}{ ~~numeric square matrix (elements -1 / +1 ) to be combined with \code{B}, \code{C}, and \code{D} by Williamson construction. 
     Although the function combines any square matrices of identical dimension, 
     the matrices must observe a special structure to in order to yield a useful design matrix. }
  \item{B}{ ~~numeric square matrix (elements -1 / +1 ) with same dimensions as \code{A} }
  \item{C}{ ~~numeric square matrix (elements -1 / +1 ) with same dimensions as \code{A} }
  \item{D}{ ~~numeric square matrix (elements -1 / +1 ) with same dimensions as \code{A} }
  \item{nruns}{ number of runs; currently has to be 12 for \code{taguchi} and 16 for \code{boxtyssedal}. }
  \item{k}{ number of factors; for up to 12 factors, a different design is picked. For 15 factors, a warning against perfect aliasing (of the last columnn) is issued. }
  \item{var}{ variable }
  \item{recodes}{ character string specifying recodes, so far only used in the principal form \dQuote{-1=level[1];1=level[2]} }
  \item{as.factor.result}{ logical that specifies whether or not results are to be coerced to factor. 
            The default is that factors are coerced to factor, while numeric variables with numeric recodes are kept numeric.}
  \item{char}{ logical: should replacement be treated as character string (TRUE) or evaluated? default is FALSE}
}

\details{
Function \code{des.recode} has been adapted to the needs of this package from function \code{recode} of package \code{car}.
}
\value{
    All functions return except \code{des.recode} return a numeric matrix, \code{circ.mat} a square matrix of dimension \code{length(gen)}, 
   \code{double.des} a matrix with \code{2*nrow(des)} rows and \code{2*ncol(des)+1} columns (full foldover),
   the \code{normalize...} functions a matrix of the same dimenensions as \code{mat}, 
   and \code{williamson} a square matrix of dimension \code{4*nrow(A)}.
   \code{taguchi} returns the Plackett-Burman array in 12 runs in Taguchi order (it is isomorphic to the standard version), and \code{boxtyssedal} returns the suitable version of the 16 run Hadamard matrix described by Box and Tyssedal, which is more appropriate for screening than the standard 16 run factorial.
   
   \code{des.recode} returns a numeric vector or factor, depending on the type of var and the setting of \code{as.factor.result}. 
   This function is identical to the function in package \pkg{\link[DoE.base:DoE.base-package]{DoE.base}} and will eventually be deleted in package \pkg{FrF2}.
}
\references{ 
  Box, G.E.P. and Tyssedal, J. (2001) Sixteen Run Designs of High Projectivity for Factor Screening. 
      \emph{Communications in Statistics - Simulation and Computation} \bold{30}, 217-228. 
      
  Hedayat, A.S., Sloane, N.J.A. and Stufken, J. (1999) \emph{Orthogonal Arrays: Theory and Applications}, Springer, New York. 
  
  Plackett, R.L.; Burman, J.P. (1946) The design of optimum multifactorial experiments. \emph{Biometrika} \bold{33}, 305-325.
  
  Williamson, J. (1946) Determinants whose elements are 0 and 1. \emph{American Mathematical Monthly} \bold{53}, 427-434.
}
\author{ Ulrike Groemping }
\note{ This package is currently under intensive development. Substantial changes are to be expected in the near future.}
\seealso{ See also \code{\link{pb}} }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
\keyword{ internal }% __ONLY ONE__ keyword per line
