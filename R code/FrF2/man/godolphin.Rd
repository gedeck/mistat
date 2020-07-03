\name{godolphin}
\alias{colpick}
\alias{FF_from_X}
\alias{X_from_parts}
\alias{X_from_profile}
\alias{clear2fis_from_profile}
\alias{blockgencreate}
\alias{phimax}
\alias{Xcalc}
\alias{blockgengroup}
\alias{colpickIV}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Functions in support of Godolphin's approach for blocking designs }
\description{
  Function colpick handles the creation of X matrices for blocking, 
  function FF_from_X blocks a full factorial, function X_from_profile creates 
  an X matrix from a profile, 
  function phimax calculations the maximum number of clear 2fis from Godolphin's approach.
  Further helper functions support the use of the method. 
  The functions are meant for expert users only.
}
\usage{
colpick(design, q, all = FALSE, select.catlg = catlg, 
      estimable = NULL, method = "VF2", sort = "natural",
      res3 = FALSE, all0 = FALSE, quiet = FALSE, 
      firsthit = is.numeric(design))
FF_from_X(X, randomize = TRUE, seed = NULL, alias.info=2)
X_from_profile(n, q, profile = NULL)
clear2fis_from_profile(n, q, profile = NULL)
X_from_parts(n, q, parts)
phimax(n, q, profile = NULL)
blockgencreate(X, p = 0)
Xcalc(XI, gen)
blockgengroup(X, p = 0, num = FALSE)
colpickIV(design, q, all = FALSE, select.catlg = catlg, 
      estimable = NULL, method = "VF2", sort = "natural",
      res3 = FALSE, all0 = FALSE, quiet = FALSE, 
      firsthit = is.numeric(design))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{design}{a character string that identifies a design in the cataloge specified 
       by option \code{select.catlg}, \cr
       OR a class \code{catlg} object with a single entry (of longer, only the first one is used), \cr
       OR an integer number of factors for which a full factorial is assumed.}
  \item{q}{the requested block size is \eqn{2^q}}
  \item{all}{if TRUE (default FALSE), all possible \bold{X} matrices are returned; 
       otherwise, \code{colpick} returns the first successful one (if \code{estimable} 
       is not NULL) or the best one (otherwise)}
  \item{select.catlg}{name of catalogue (not in quotes); 
        only relevant, if \code{design} is a character string}
  \item{estimable}{a specification of 2fis to be kept clear in the blocked design, 
       either as a character vector of pairs of factor letters (using the first 
       elements of `Letters`) or as a two-row matrix of pairs of factor numbers occurring 
       in 2fis)}
  \item{method}{character string identifying a subgraph isomorphism method
       (VF2 or LAD), see \code{\link{FrF2}}}
  \item{sort}{character string specifying a presort strategy for subgraph 
       isomorphism search, see \code{\link{FrF2}}}
  \item{res3}{relevant only if \code{estimable} is not NULL;\cr
       per default (\code{res3=FALSE}), \code{design} will yield no result, 
       if it has resolution III only; 
       set \code{res3} to TRUE for allowing a \code{design} of resolution III 
       (almost never useful)}
  \item{all0}{per default (\code{all0=FALSE}), \bold{X} matrices are requested to be 
       free of all-zero columns. Set \code{all0} to TRUE for permitting aliasing 
       between blocks and factor main effects, i.e. for finding a suitable split-plot
       constructor. }
  \item{quiet}{if TRUE, the message about failure is suppressed (for using the function 
       inside other functions, like \code{FrF2}) }
  \item{firsthit}{if TRUE, the function does not attempt to optimize the 
       number of clear 2fis but accepts the first acceptable blocking
       (relevant for non-null \code{estimable} only); \cr
       per default, optimizing is suppressed for full factorials only (where it 
       is not very reasonable to use function \code{colpick} instead of simply
       hand-crafting an \bold{X} matrix; function \code{FrF2} sets it to FALSE 
       for creation of full factorials with estimability requirements); \cr
       for large applications with estimability requirements, 
       specifying \code{firsthit} as TRUE may allow to inspect more candidates 
       and to then possibly deepdive some of them}
  \item{X}{a \eqn{q \times n}{q times n} \bold{X} matrix 
       with only 0/1 elements for block construction }
  \item{randomize}{ logical. If TRUE, the design is randomized. This is the default.
       Randomization is implemented using function 
       \code{\link[DoE.base]{rerandomize.design}} of package \pkg{DoE.base} 
       as the last step in design creation.
       }
  \item{seed}{ optional seed for the randomization process \cr
        In R version 3.6.0 and later, the default behavior of function \code{\link{sample}}
        has changed. If you work in a new (i.e., >= 3.6.-0) R version and want to reproduce 
        a randomized design from an earlier R version (before 3.6.0), 
        you have to change the RNGkind setting by\cr
        \code{RNGkind(sample.kind="Rounding")}\cr
        before running function \code{FrF2}.\cr
        It is recommended to change the setting back to the new recommended way afterwards:\cr
        \code{RNGkind(sample.kind="default")}\cr
        For an example, see the documentation of the example data set \code{\link[DoE.base]{VSGFS}}.
        }
  \item{alias.info}{degree of effects aliased with blocks to be included in the 
       \code{design.info} attribute}
  \item{profile}{profile to use for calculation 
       (NULL or integer vector of up to \eqn{2^q-1} elements that sum to \eqn{n}); 
       if NULL, the maximally balanced profile is used (which yields the overall maximum
       number of clear 2fis when blocking a full factorial)}
  \item{parts}{list that provides factor partitions; list entries 
        must either be all integers from 1 to \code{n} or the elements
        of \code{Letters[1:n]}}
  \item{n}{number of factors}
  \item{p}{the number of generated factors (among the n factors); 
       \eqn{2^(n-p)} is the number of runs in the experiment)}
  \item{XI}{a \eqn{q \times k}{q times k} \bold{X}_I matrix 
       with only 0/1 elements, 
       to be extended into a \eqn{q \times n}{q times n} \bold{X} matrix for 
       block construction, given the generators in \code{gen} (\eqn{k=n-p})}
  \item{gen}{generators for extending \code{XI}: \code{gen} can be\cr 
        a class \code{catlg} object (e.g. \code{catlg["7-2.1"]} or 
        \code{catlg[nruns(catlg)==32 & nfac(catlg)==7])}; each \code{nfac} 
        entry must be the sum of \eqn{k} and the length of the \code{gen} element)\cr
        a vector of Yates column numbers (e.g. \code{c(7, 27)})\cr
        a vector of defining contrasts (e.g. \code{c("ABC","ABDE")})
        a list of vectors of base column numbers}
  \item{num}{if TRUE (default FALSE), Yates column numbers are returned 
        instead of their character representations}
}

\details{
    These are the functions for the Godolphin (2019) approach to blocking; 
    most of them are user-visible. 
    This approach and its implementation are described in Groemping (2019). 
    Direct use of this functions is intended for expert use only.

    Function \code{colpick} is
    the main workhorse function for blocking larger situations 
    in function \code{\link{FrF2}} 
    (since version 2 of the package, it replaces the earlier approach 
    with function \code{\link{blockpick.big}}); it makes use of function 
    \code{blockgencreate}, and of the internal function \code{blockgengroup}.
    
    Function \code{FF_from_X} creates a class \code{design} object. 
    Design size is limited by computer memory and run time. 
    The function can use an \bold{X} matrix that was produced by function 
    \code{colpick}; but note that it is quite easy to hand-craft 
    an \bold{X} matrix for a full factorial, even with estimability requirements.
    The light-weight function does not have arguments for customization; it can 
    be post-processed, however, e.g. using function 
    \code{\link[DoE.base]{factor.names<-}}.
    
    Function \code{X_from_profile} creates an X matrix that corresponds to 
    the specified profile.
    
    Function \code{phimax} returns the maximum number of 2fis that can 
    be kept clear when blocking a full factorial design in \eqn{n} factors into 
    blocks of size \eqn{2^q}, given the specified profile.
    
    Function \code{blockgencreate} creates block generators from an \bold{X} matrix 
    for blocking a design in \eqn{2^(n-p)=2^k} runs into blocks of size \eqn{2^q}, 
    where \eqn{n} and \eqn{q} are derived from \code{X} as the number of columns and rows, 
    respectively. The generators are returned as a character vector that consists of 
    strings of base factor letters.
    
    Function \code{Xcalc} extends a \eqn{q\times k}{q times k} 
    matrix \bold{X}_I by \eqn{p=n-k} columns 
    (\bold{X}_II in Godolphin notatation) based 
    on the generators provided in \code{gen}.
    
    Function \code{blockgengroup} is internal only, 
    as are functions \code{colpickIV} and \code{clear2fis_from_profile}.
}

\value{
    Function \code{colpick} returns a list of at least two elements: \cr
    if \code{all} is FALSE, the list consists of the matrix \code{X}, 
    the character vector 
    \code{clear.2fis} and possibly the integer vector \code{map}, \cr
    otherwise of list-valued elements \code{X_matrices}, \code{clearlist} and 
    \code{profiles} and \code{maplist}.
    
    Function \code{FF_from_X} returns a class design object of type \code{FrF2.blocked}.
    
    Function \code{phimax} returns a real number.
    
    Function \code{blockgencreate} returns a character vector of generators
    in terms of \code{Letters} combinations of the first $n-p$ factors.
    
    Function \code{Xcalc} returns a \eqn{q\times n}{\code{q} times \code{n}} 
    matrix (in case of a single generator) or a list of such matrices 
    (if \code{gen} is a class \code{catlg} object with more than one element).
    
    The internal function \code{blockgengroup} returns a character vector of all effects 
    (denoted as base column letter combinations) aliased with the block main effect, 
    or corresponding Yates column numbers.
    
    The internal function \code{colpickIV} returns almost the same type of results as \code{colpick}. 
    The difference: \cr
    if \code{all} is TRUE, there is an integer vector \code{map} instead of the 
    \code{maplist} element, because the \code{map} does not depend on the choice of X-matrix 
    (separate subgraph isomorphism checking is skipped with this function).

}

\references{
Groemping, U. (2010). Creating clear designs: a graph-based algorithm and a 
   catalogue of clear compromise plans. 
   \emph{Reports in Mathematics, Physics and Chemistry}, \href{http://www1.beuth-hochschule.de/FB_II/reports/Report-2010-005.pdf}{Report 05/2010}, 
   Department II, Beuth University of Applied Sciences Berlin.
   (Preprint for IIE Transactions; IIE Transactions is available at 
   \url{http://www.tandfonline.com}.)
   
Godolphin, J. (2019). Construction of Blocked Factorial Designs to Estimate 
   Main Effects and Selected Two-Factor Interactions. *Unpublished report* 
   available at \url{https://arxiv.org/abs/1907.02373}.
   
Groemping, U. (2019). An algorithm for blocking regular fractional 
  factorial 2-level designs with clear two-factor interactions. 
   \emph{Reports in Mathematics, Physics and Chemistry}, \href{http://www1.beuth-hochschule.de/FB_II/reports/Report-2019-003.pdf}{Report 3/2019}, 
   Department II, Beuth University of Applied Sciences Berlin.

}
\examples{
phimax(7, 2)  ## 16 2fis can be clear, if 128 run full factorial is blocked 
              ## into 32 blocks of size 2^2=4

## X matrices for blocking full factorials
## do not care about which factors have which role
X_from_profile(7, 2, c(3,2,2))
   # X_from_profile(7, 2, c(2,2,3)) returns same matrix
## ensure specific partition, i.e. specific requirement CIG to be accommodated
X <- X_from_parts(7, 2, parts=list(c("A","D","F"), c("B","G"), c("C","E")))

## blocked full factorial
summary(FF_from_X(X))

## using colpick
## estimable in standard letters
requ <- c("BA", "BC", "BD", "BE", "BF", "BG", "BH", "BJ")
## estimability requirement in factor names
fn <- Letters[15:23] ## P to X
requfn <- requ
requfn <- sapply(1:8, function(obj) gsub(Letters[obj], fn[obj], requfn[obj]))

## obtain X matrix for accommodating estimability requirement in 9-4.2
(aus <- colpick("9-4.2", 2, estimable=requ))
## obtain the same matrix manually with Xcalc
XI <- aus$X[,1:5]
## obtain the same matrix manually with Xcalc
all(Xcalc(XI, catlg["9-4.2"])==aus$X)
## inspect X matrices generated from XI
Xcalc(XI, catlg[nruns(catlg)==32 & nfac(catlg)==9 & res(catlg)>=4])

## factor permutation needed
aus$map
## calculate block generators
blockgencreate(aus$X, p=4)
## automatic creation from the design 9-4.2 uses these block generators
summary(FrF2(32, 9, blocks=8, estimable=requ, factor.names=fn, 
    alias.block.2fis = TRUE, select.catlg = catlg["9-4.2"]), 
    brief=TRUE)
## can also be reproduced manually (internal function invperm does the permuting)
summary(FrF2(design="9-4.2", blocks=blockgencreate(aus$X, p=4), 
    factor.names=fn[FrF2:::invperm(aus$map)], 
    alias.block.2fis = TRUE), 
    brief=TRUE)
}
\author{Ulrike Groemping}
\seealso{\code{\link[igraph]{plot.igraph}}, \code{\link[igraph]{tkplot}},
   \code{\link[igraph]{plot.common}} }
\keyword{design}
