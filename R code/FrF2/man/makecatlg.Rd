\name{makecatlg}
\alias{makecatlg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Function for creating a class catlg catalogue from a vector of generators }
\description{
  creates a class catlg catalogue with a single element for use in functions 
  colpick or FrF2
}
\usage{
makecatlg(k, gen) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{k}{ number of base factors spanning a full factorial with the desired number of runs }
  \item{gen}{ generators as a numeric vector of Yates column numbers }
}
\details{
   If generators are available in a different format, they must be transformed to Yates column numbers. 
   
   For a character vector \code{genc} with elements like \code{ABC}, \code{ADE}, etc., 
   a code for obtaining Yates columns with order preserved is
   \code{sapply(1:length(genc), function(obj) which(names(Yates)==genc[obj]))} 
   (a solution with \code{which} applied to the entire vector at once does not preserve the order).
   
   Yet different formats like \code{123}, \code{145}, etc., can e.g. 
   be preprocessed by picking the suitable elements from \code{\link{Letters}}, e.g. 
   \code{paste(Letters[as.numeric(unlist(strsplit("123","")))],collapse="")}.
}
\value{
   The function returns a list of class \code{catlg} with a single element.
   }
\author{ Ulrike Groemping }
\note{ This package is still under development, but does already provide useful and well-tested results.}
\seealso{ See also \code{\link{FrF2}} }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
\examples{
## Xu's fraction 13-5.2
genXu <- c(127, 143, 179, 85, 150)
catXu <- makecatlg(k=8, genXu)
colpick(catXu, q=2) ## Godolphin blocking into blocks of size 4 yields 56 clear 2fis
FrF2(256, 13, blocks=64, alias.block.2fis=TRUE, select.catlg=catXu)
}
