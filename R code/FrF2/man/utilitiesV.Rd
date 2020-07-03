\name{utilitiesV}
\alias{revdigits}
\alias{indexcalc}
\alias{gencalc}
\alias{YatesFly}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~ Internal utility functions for generating regular fractional factorials ~~ }
\description{
  ~~ Internal functions, mainly for generating designs without relying on a catalogue of designs ~~
}
\usage{
revdigits(obj, ndigits = 1 + floor(log2(max(obj))))

indexcalc(obj, k = 1 + floor(log2(max(obj))))

gencalc(gen)

YatesFly(walshindex, k=NULL)

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{ non-negative integer (vector) with Yates matrix column numbers 
          (called Walsh indices by Sanchez and Sanchez 2005) }
  \item{ndigits}{ number of binary digits; default is the necessary number for the largest element of \code{obj} }
  \item{k}{ number of base factors; default is the minimum necessary number for the maximum of \code{obj} }
  \item{gen}{ generators in any admissible format (\code{gen.check} transforms any admissible format to the default needed for calculations)) }
  \item{walshindex}{ non-negative integer (vector) with Yates matrix column numbers 
       (called Walsh indices by Sanchez and Sanchez 2005; \cr
       must contain the base column numbers 1, 2, 4, 8 and so forth for the desired dimension;
       if this rule is violated, the first non-base column(s) are omitted in favor of supplementing 
       the set of base columns)  }
}
\details{
    These internal functions are used for generating regular 2-level fractional factorials. 
    The Sanchez and Sanchez (2005) way of providing large resolution V designs 
    is supported, as well as manual design generation of large designs with 
    functions \code{\link{FrF2}} and \code{\link{FrF2Large}}.
    }
\value{
    \code{revdigits} creates a matrix with 0-1 entries in an order appropriate for 
       creating character generators from Yates matrix column numbers,\cr 
    \code{indexcalc} calculates a named list of vectors of base column numbers, 
        named by the corresponding character generator, \cr
    \code{gencalc} calculates Yates column numbers from arbitrary types of generator 
        representations (except for negative numbers),\cr
    \code{YatesFly} produces an experimental plan from a vector of Yates column numbers 
        which have to include the base column numbers (contrary to the 
        \code{generators} option in \code{FrF2} or \code{FrF2Large}
}
\references{ 
    Sanchez, S.M. and Sanchez, P.J. (2005). Very Large Fractional Factorial 
     and Central Composite Designs. 
     \emph{ACM Transactions on Modeling and Computer Simulation} 
     \bold{15}, 362-377.
}
\author{ Ulrike Groemping }
\note{ This package is still under development, but does already provide useful and well-tested results.}
\seealso{ See also \code{\link{FrF2Large}} }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
\keyword{ internal }
