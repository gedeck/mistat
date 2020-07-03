\name{utilities.blocksplitplot.aliases.shortrep}
\alias{recalc.alias.block}
\alias{recalc.alias.block.new}
\alias{struc.aliased}
\alias{struc.aliased.new}
\alias{blockfull}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Utility functions for short representation of block and splitplot generators }
\description{
  Utility functions for short representation of block and splitplot generators, 
  not intended for direct use
}
\usage{
recalc.alias.block(dia, leg)
recalc.alias.block.new(dia, leg)
struc.aliased(struc, nk, order)
struc.aliased.new(struc, nk, order) 
blockfull(block.gen, k, des.gen = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dia}{ a list of alias information from function aliases }
  \item{leg}{ a character vector of legend entries shaped as \code{A=name1} or \code{F1=name1}, 
        depending on whether there are up to 50 factors or more}
  \item{struc}{ an output from function \code{recalc.alias.block} }
  \item{nk}{ number of factors (<=50: Letters; >50: F1, F2, ...) }
  \item{order}{ 2 or 3 (aliasing order) }
  \item{block.gen}{ generators for \code{k.block} independent block columns;\cr
        a list of vectors of design column numbers\cr
        or a numeric vector of Yates column numbers\cr
        or a vector of character strings like "ABD", "CF" etc }
  \item{k}{ number of base factors (i.e. design has \eqn{2^k} runs) }
  \item{des.gen}{ generating columns for the design as Yates column numbers 
      (including base columns)}
}
\details{
   The functions are not intended for direct use. 
}
\value{The functions are not intended for direct use. 
Function \code{recalc.alias.block} outputs a character vector of alias relations, 
function \code{struc.aliased} structures these into a list with main effects, 
2fis and 3fis (the latter for \code{order=3} only). The functions with suffix \code{new} do the same thing for package version 2 in case of blocked designs (split plot functionality still uses the old ones).

\code{blockfull} supports reporting about aliasing with blocks.

These functions are used by function \code{FrF2}.
}
\author{ Ulrike Groemping }
\note{ This package is still under development regarding some of its aspects; 
especially internal functions cannot be relied upon to remain stable.}
\seealso{ See Also \code{\link[FrF2]{FrF2-package}} }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
\keyword{internal}