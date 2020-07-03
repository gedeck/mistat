\name{CatalogueAccessors}
\alias{[.catlg}
\alias{print.catlg}
\alias{res}
\alias{nruns}
\alias{nfac}
\alias{WLP}
\alias{nclear.2fis}
\alias{clear.2fis}
%\alias{all.2fis.clear}
\alias{dominating}
\alias{res.catlg}
\alias{nruns.catlg}
\alias{nfac.catlg}
\alias{WLP.catlg}
\alias{nclear.2fis.catlg}
\alias{clear.2fis.catlg}
\alias{all.2fis.clear.catlg}
\alias{dominating.catlg}
\alias{res.character}
\alias{nruns.character}
\alias{nfac.character}
\alias{WLP.character}
\alias{nclear.2fis.character}
\alias{clear.2fis.character}
\alias{all.2fis.clear.character}
\alias{dominating.character}
\alias{catlg}
\alias{block.catlg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Catalogue file and accessor functions }
\description{
  Functions to select elements or extract information from design catalogues of class catlg
}
\usage{
res(catlg)
\method{res}{catlg}(catlg)
\method{res}{character}(catlg)
nruns(catlg)
\method{nruns}{catlg}(catlg)
\method{nruns}{character}(catlg)
nfac(catlg)
\method{nfac}{catlg}(catlg)
\method{nfac}{character}(catlg)
WLP(catlg)
\method{WLP}{catlg}(catlg)
\method{WLP}{character}(catlg)
nclear.2fis(catlg)
\method{nclear.2fis}{catlg}(catlg)
\method{nclear.2fis}{character}(catlg)
clear.2fis(catlg)
\method{clear.2fis}{catlg}(catlg)
\method{clear.2fis}{character}(catlg)
all.2fis.clear.catlg(catlg)
%\method{all.2fis.clear}{catlg}(catlg)
dominating(catlg)
\method{dominating}{catlg}(catlg)
\method{dominating}{character}(catlg)
catlg
\method{[}{catlg}(catlg,i)
\method{print}{catlg}(x, name="all", nruns="all", nfactors="all", 
                        res.min=3, MaxC2=FALSE, show=10, 
                        gen.letters=FALSE, show.alias=FALSE, ...)
block.catlg
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{catlg}{ Catalogue of designs of class \code{catlg} (cf. details section), or character vector with name(s) of \code{catlg} element(s) in case of accessor functions}
  \item{i}{ vector of index positions or logical vector that can be used for indexing a \code{catlg} object }
  \item{x}{ an object of class \code{catlg} }
  \item{name}{ character vector of entry names from \code{x}; default \dQuote{all} means: no selection made }
  \item{nruns}{ numeric integer (vector), giving the run size(s) for entries of \code{x} to be shown; 
                default \dQuote{all} means: no selection made  }
  \item{nfactors}{ numeric integer (vector), giving the factor number(s) for entries of \code{x} to be shown; 
                default \dQuote{all} means: no selection made }
  \item{res.min}{ numeric integer giving the minimum resolution for entries of \code{x} to be shown }
  \item{MaxC2}{ logical indicating whether designs are ordered by minimum aberration (default, \code{MaxC2=FALSE}) 
                or by maximum number of clear 2fis (\code{MaxC2=TRUE})}
  \item{show}{ integer number indicating maximum number of designs to be shown; default is 10 }
  \item{gen.letters}{ logical indicating whether the generators should be shown as 
                column numbers (default, \code{gen.letters=FALSE}) or as generators with 
                factor letters (e.g. E=ABCD, \code{gen.letters=TRUE})}
  \item{show.alias}{ logical indicating whether the alias structure (up to 2fis) is to be printed }
  \item{\dots}{ further arguments to function \code{print} }
  \item{block.catlg}{ data frame with block generators for full factorial designs up to 256~runs, 
                taken from Sun, Wu and Chen (1997)}
}
\details{
  The class \code{catlg} is a named list of design entries. 
  Each design entry is again a list with the following items:
  \describe{
      \item{res}{resolution, numeric, i.e. 3 denotes resolution III and so forth }
      \item{nfac}{number of factors} 
      \item{nruns}{number of runs} 
      \item{gen}{column numbers of additional factors in Yates order} 
      \item{WLP}{word length pattern (starting with words of length 1, 
              i.e. the first two entries are 0 for all designs in \code{catlg})} 
      \item{nclear.2fis}{number of clear 2-factor interactions (i.e. free of aliasing with main effects or other 2-factor interactions)} 
      \item{clear.2fis}{2x\code{nclear.2fis} matrix of clear 2-factor interactions 
              (clear to be understood in the above sense); this matrix represents 
              each designs clear interaction graph, which can be used in automated searches for 
              designs that can accomodate (i.e. clearly) a certain requirement set 
              of 2-factor interactions; cf. also \code{\link{estimable.2fis}} } 
      \item{all.2fis.clear}{vector of factors with all 2-factor interactions clear in the above sense}
      \item{dominating}{logical that indicates whether the current design adds a 
              CIG structure that has not been seen for a design with less aberration 
              (cf. Wu, Mee and Tang 2012 p.196 for dominating designs);
              TRUE, if so; FALSE, if current CIG is isomorphic to previous one or 
              has no edges (IMPORTANT: the dominance assessment refers to the current 
              catalogue; for designs with more than 64 runs, it is possible that 
              a design marked dominating in catalogue \code{catlg} is not dominating 
              when considering ALL non-isomorphic designs). \cr
              This element is helpful in omitting non-promising 
              designs from a search for a clear design.\cr
              This element may be missing. In that case, all catalogue entries 
              are assumed dominating. }
      }
  Reference to factors in components \code{clear.2fis} and \code{all.2fis.clear} 
  is via their position number (element of (1:nfac)). 
   
  The \code{print} function for class \code{catlg} gives a concise overview of selected designs in any design catalogue of class \code{catlg}. 
  It is possible to restrict attention to designs with certain run sizes, numbers of factors, and/or to request a minimum resolutions. 
  Designs are ordered in decreasing quality, where the default is aberration order, but number of clear 2fis can be requested alternatively. 
  The best 10 designs are displayed per default; this number can be changed by the \code{show} option. 
  Options \code{gen.letters} and \code{show.alias} influence the style and amount of printed output.
   
  The catalogue \code{catlg}, which is included with package \code{FrF2}, 
  is of class \code{catlg} and is a living object, since it has to be updated with 
  recent research results for larger designs. In particular, new MA designs may be found, 
  or it may be proven that previous \dQuote{good} designs are in fact of minimum aberration.
  
  Currently, the catalogue contains
  \itemize{
  \item the Chen, Sun and Wu (1993) 2-level designs 
  (complete list of 2-level fractional factorials from 4 to 32~runs, 
  complete list of resolution IV 2-level fractional factorials with 64~runs). 
  Note that the Chen Sun Wu paper only shows a selection of the 64~run designs, the 
  complete catalogue has been obtained from Don Sun and is numbered according to 
  minimum aberration (lower number = better design); numbering in the paper is 
  not everywhere in line with this numbering. 
  
  \item minimum aberration (MA) resolution III designs for 33 to 63 factors in 
  64 runs. The first few of these have been obtained from Appendix G of 
  Mee 2009, the designs for 38 and more factors have been constructed by combining 
  a duplicated minimum aberration design in 32 runs and the required number of factors 
  with columns 32 to 63 of the Yates matrix for 64 run designs. Using complementary 
  design theory (cf. e.g. Chapter 6.2.2 in Mee 2009), it can be shown that the resulting 
  designs are minimum aberration (because they are complementary to basically the same 
  designs as the designs in 32 runs on which they are based). The author is grateful 
  to Robert Mee for pointing this out.
  
  \item the MA designs in 128 runs:
  \itemize{
  \item for up to 24 factors obtained from Xu (2009),
  \item for 25 to 64 factors taken from Block and Mee (2005, with corrigendum 2006),
  \item for 65 to 127 factors (resolution III): up to 69 factors coming from Appendix G 
  in Mee, whereas the designs for 70 or more factors have been  
  constructed according to the same principle mentioned for the 64 run designs.}
  
  \item various further \dQuote{good} resolution IV designs in 128 runs obtained by evaluating 
  designs from the complete catalogue by Xu (2009, catalogue on his website) 
  w.r.t. aberration and number of clear 2fis (including also all designs that yield 
  minimum aberration clear compromise designs according to Groemping 2010); all designs 
  with resolution at least IV for up to 11 factors have been added with version 2.2.
  
  \item the MA even designs in 128 runs, in support of blocking according to the 
  Godolphin approach have been added with version 2.2.

  Note that additional non-isomorphic resolution IV designs in 128 runs are 
  available in package (\pkg{FrF2.catlg128}); since the catalogues are quite large, 
  they are not forced upon users of this package who do not need them. 
  Since version 1.1 of that package, the catalogues are not complete but contain 
  high resolution fractions and even/odd fractions only (status: version 1.2-x); 
  re-inclusion of at least selected even fractions is intended, because these 
  may yield improved support of blocking in connection with estimable 2fis.
  
  \item the best (MA) resolution IV or higher designs in \cr
  256 runs for up to 36 factors (resolution V up to 17 factors),\cr 
  512 runs for up to 29 factors (resolution V for up to 23 factors).\cr 
  These have been taken from Xu (2009) with additions by Ryan and Bulutoglu 
  (2010). 
  
  \item Further \dQuote{good} resolution IV designs with up to 80 factors in 
  256 runs and up to 160 factors in 512 runs have also been implemented from Xu (2009).
  
  \item the best (MA) resolution V or higher design for each number of factors or 
  a \dQuote{good} such design (if it is not known which one is best) in \cr
  1024 runs (up to 33 factors, MA up to 28 factors, resolution VI up to 24 factors), \cr
  2048 runs (up to 47 factors, MA up to 32 factors, resolution VI up to 34 factors),\cr
  and 4096 runs (up to 65 factors, MA up to 26 factors, resolution VI up to 48 factors).\cr 

  Most of the large designs in \code{catlg} have been taken from Xu (2009), 
  where complete catalogues of some scenarios are provided 
  (cf. also his website) as well as \dQuote{good} (not necessarily MA) designs for a larger 
  set of situations. Some of the good designs by Xu (2009) have later been shown 
  to be MA by Ryan and Bulutoglu (2010), who also found some additional larger MA designs, 
  which are also included in \code{catlg}. Non-MA designs that 
  were already available before Bulutoglu (2010) are still in the catalogue with their old name.
  (Note that designs that are not MA and cannot be placed in the ranking do not 
  have a running number in the design name; for example, the MA 2048 runs 
  design in 28 factors is named 28-17.1, the older previous design 
  that was not MA is named 28-17 (without \dQuote{.1} or another placement, 
  because the designs position in the ranking of all designs is not known.)) 
  }
  
  There are also some non-regular 2-level fractional factorial designs of resolution V 
  which may be interesting, as it is possible to increase the number of factors for which 
  resolution V is possible (cf. Mee 2009, Chapter 8). 
  These are part of package \pkg{DoE.base}, which is automatically 
  loaded with this package. With versions higher than 0.9-14 of that package, 
  the following arrays are available: \cr
  \code{L128.2.15.8.1}, which allows 4 additional factors and blocking into up to 8 blocks\cr
  \code{L256.2.19}, which allows just 2 additonal factors\cr
  \code{L2048.2.63}, which allows 16 additional factors.
  These non-regular arrays should be fine for most purposes; the difference to the arrays generated 
  by function \code{FrF2} lies in the fact that there is partial aliasing, e.g. between 3-factor interactions 
  and 2-factor interactions. This means that an affected 3-factor interaction is 
  partially aliased with several different 
  2-factor interactions rather than being aliased either fully or not at all.
  }

\value{
  \code{[} selects a subset of designs based on \code{i}, which is again a list of class \code{catlg}, even if a single element is selected.
  \code{res}, \code{nruns}, \code{nfac}, \code{nclear.2fis} 
  and \code{dominating} return a named vector, 
  the \code{print} method does not return anything (i.e. it returns \code{NULL}), and 
  the remaining functions return a list.
}
\references{ 
Block, R. and Mee, R. (2005) Resolution IV Designs with 128 Runs \emph{Journal of Quality Technology} \bold{37}, 282-293.

Block, R. and Mee, R. (2006) Corrigenda \emph{Journal of Quality Technology} \bold{38}, 196.

Chen, J., Sun, D.X. and Wu, C.F.J. (1993) A catalogue of 2-level and 3-level orthogonal arrays. \emph{Int. Statistical Review} \bold{61}, 131-145.

Groemping, U. (2010). Creating clear designs: a graph-based algorithm and a 
catalogue of clear compromise plans. 
\emph{Reports in Mathematics, Physics and Chemistry}, report 05/2010, 
Department II, Beuth University of Applied Sciences Berlin.

Mee, R. (2009). \emph{A Comprehensive Guide to Factorial Two-Level Experimentation}. 
New York: Springer.
    

Ryan, K.J. and Bulutoglu, D.A. (2010). Minimum Aberration Fractional Factorial Designs With Large N.
     \emph{Technometrics} \bold{52}, 250-255.

Sun, D.X., Wu, C.F.J. and Chen, Y.Y. (1997). 
Optimal blocking schemes for 2\^p and 2\^(n-p) designs. \emph{Technometrics} \bold{39}, 
298-307. 

Wu, H., Mee, R. and Tang, B. (2012). Fractional Factorial Designs With Admissible 
         Sets of Clear Two-Factor Interactions. \emph{Technometrics} \bold{54}, 191-197.

Xu, H. (2009) Algorithmic Construction of Efficient Fractional Factorial Designs 
         With Large Run Sizes. \emph{Technometrics} \bold{51}, 262-277.
}
\author{ Ulrike Groemping }

\seealso{ See also \code{\link{FrF2}}, \code{\link[DoE.base]{oa.design}}  }
\examples{
c8 <- catlg[nruns(catlg)==8]
nclear.2fis(c8)
clear.2fis(c8)
all.2fis.clear.catlg(c8)

## inspecting a specific catalogue element
clear.2fis("9-4.2")

## usage of print function for inspecting catalogued designs
## the first 10 resolution V+ designs in catalogue catlg
print(catlg, res.min=5)
## the 10 resolution V+ designs in catalogue catlg with the most factors
## (for more than one possible value of nfactors, MaxC2 does usually not make sense)
print(catlg, res.min=5, MaxC2=TRUE)

## designs with 12 factors in 64 runs (minimum resolution IV because 
## no resolution III designs of this size are in the catalogue)
## best 10 aberration designs
print(catlg, nfactors=12, nruns=64)
## best 10 clear 2fi designs
print(catlg, nfactors=12, nruns=64, MaxC2=TRUE)
## show alias structure
print(catlg, nfactors=12, nruns=64, MaxC2=TRUE, show.alias=TRUE)
## show best 20 designs
print(catlg, nfactors=12, nruns=64, MaxC2=TRUE, show=20)

## use vector-valued nruns 
print(catlg, nfactors=7, nruns=c(16,32))
## all designs (as show=100 is larger than available number of designs)
##    with 7 or 8 factors in 16 runs
print(catlg, nfactors=c(7,8), nruns=16, show=100)

## the irregular resolution V arrays from package DoE.base (from version 0.9-17)
## designs can be created from them using function oa.design
\dontrun{
## not run in case older version of DoE.base does not have these
length3(L128.2.15.8.1)
length4(L128.2.15.8.1)  ## aliasing of 2fis with block factor
length4(L128.2.15.8.1[,-16])

length3(L256.2.19)
length4(L256.2.19)

##length3(L2048.2.63) 
##length4(L2048.2.63) do not work resource wise
## but the array is also resolution V (but irregular)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
