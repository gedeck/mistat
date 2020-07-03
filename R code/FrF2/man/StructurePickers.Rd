\name{StructurePickers}
\alias{splitpick}
\alias{leftadjust}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Functions to find split-plot or left-adjusted designs }
\description{
  Functions to restructure a fractional factorial by permuting the base factors 
  such that the leftmost base factors have a suitable alias structure for the 
  problem at hand; meant for expert users
}
\usage{
splitpick(k, gen, k.WP, nfac.WP, show=10)
leftadjust(k, gen, early=NULL, show=10)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{k}{ the number of base factors (designs have \code{2^k} runs) }
  \item{gen}{ vector of generating columns from Yates matrix }
  \item{k.WP}{ integer number of base factors used for whole plot generation; 
        there will be \code{2^k.WP} plots in the design}
  \item{nfac.WP}{ integer number of whole plot factors, must not be smaller than \code{k.WP};
        the other \code{k + length(gen)} factors are split-plot factors, i.e. 
        they change within plots }
  \item{show}{ numeric integer indicating how many results are to be shown;
        for function \code{splitpick}, this number also determines how many designs 
        are investigated;
        the other two functions investigate all designs and show the best results only }
  \item{early}{ number that indicates how many \dQuote{leftmost} factors are 
        needed in the design; used by \code{FrF2} for accomodating hard-to-change 
        factors }
}
\details{
  These functions exploit the fact that a factorial design can be arranged such 
  that the \code{2^k.WP-1} leftmost columns have exactly \code{2^k.WP} 
  different patterns. They can thus accomodate whole plot effects if \code{2^k.WP} 
  plots are available; also, with a specially rearranged version of the Yates matrix, 
  the leftmost columns can have particularly few or particularly many level changes, 
  cf. e.g. Cheng, Martin and Tang 1998.
  
  By permuting the \code{k} base factors , the functions try to find \code{2^k.WP} 
  ones that accomodate the current needs, if taken as the first base factors. They are 
  used by function \code{FrF2}, if a user requests an automatically-generated 
  split-plot design or a design with some factors declared hard-to-change.
  
  There may be a possibility to better accomodate the experimenters needs within 
  a given design by trying different sets of base factors. This is not done 
  in these functions. Also, custom user needs may be better fulfilled, if an expert 
  user directly uses one of these functions for inspecting the possibilities, rather 
  than relying on the automatic selection routine in function \code{FrF2}. 
  }

\value{
  Both functions output a list of entries with information on at most \code{show} suitable 
  permutations. \code{splitpick} ends with an error, if no suitable 
  solution can be found.
  
  \item{orig}{original generator column numbers}
  \item{basics}{named vector with the following entries: \cr
        for function \code{splitpick}, 
        entries are the number of runs, the number of plots, the
        number of whole plot factors and the number of split-plot factors \cr
        for function \code{leftadjust}, 
        entries are the number of runs, the number of factors, 
        and - if \code{early} is not NULL - the entry for \code{early} }
  \item{perms}{matrix with rows containing permutations of base factors}
  \item{res.WP}{for \code{splitpick} only; \cr 
        vector of resolutions for the respective rows of perms}
  \item{maxpos}{for \code{leftadjust} only; \cr 
        vector of maximum positions for the \code{early} leftmost factors for the respective rows of perms}
  \item{k.early}{for \code{leftadjust} only; \cr 
        vector of numbers of base factors needed for spanning the \code{early} leftmost factors for the respective rows of perms}
  \item{gen}{matrix the rows of which contain the generator columns 
        for the respective rows of perms}
}
\references{ 
Cheng, C.-S., Martin, R.J., and Tang, B. (1998). 
Two-level factorial designs with extreme numbers of level changes. \emph{Annals of Statistics} 
\bold{26}, 1522-1539.
}
\author{ Ulrike Groemping }

\seealso{ See Also \code{\link{FrF2}}  }
\examples{
## leftadjusting MA design from table 6.22 in BHH2, 9 factors, 32 runs
## NOTE: nevertheless not as well left-adjusted as the isomorphic design 9-4.1 from catlg
leftadjust(5,c(30,29,27,23))
## with option early=4 (i.e. 4 columns as early as possible are requested)
leftadjust(5,c(30,29,27,23),early=4)
leftadjust(5,catlg$'9-4.1'$gen,early=4)

## look for a split plot design in 32 runs with 7 factors, 
##       3 of which are whole plot factors, 
##       and 8 plots
splitpick(5,catlg$'7-2.1'$gen,nfac.WP=3,k.WP=3)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
