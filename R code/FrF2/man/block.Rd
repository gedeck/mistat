\name{block}
\alias{block}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Statistical and algorithmic aspects of blocking in FrF2 }
\description{
  This help page documents the statistical and algorithmic details of blocking in FrF2 
}
\details{
  Blocking is done with the purpose to balance the design with respect to a factor 
  that is known or strongly suspected to have an influence but is not in itself of interest, 
  and it is usually assumed that block factors do not interact with experimental factors. 
  Examples are batches of material that are not large enough to accomodate the complete 
  experiment so that e.g. half the experiment is done on the first batch and the other half 
  on the second batch (two blocks). The block factor should be orthogonal to the experimental 
  factors, at least to their main effects. Per default, it is also requested that the block 
  factor is orthogonal to the 2-factor interactions. This can be changed by the user, if no 
  such design can be found.

  Blocking is currently implemented for regular fractional factorial designs only.\cr
  There are two principal ways to handle blocked designs, manual definition 
  (i.e. the user specifies exactly which columns are to be used for which purpose) and automatic 
  definition. Each situation has its specifics. These are detailed below. For users with 
  not so much mathematical/statistical background, it will often be best to use the automatic way, 
  specifying the treatment factors of interest via \code{nfactors} or \code{factor.names} 
  and a single number for \code{blocks} or \code{WPs}. 
  Users with more mathematical background may want to use the manual definitions, perhaps 
  in conjunction with published catalogues of good block designs, or 
  after inspecting possibilities with functions \code{\link{blockpick}}, \code{\link{blockpick.big}} (default before version 2 for large settings) or \code{\link{colpick}} (default since version 2 for large settings or settings with estimability requirements).
  
  \describe{
  \item{Manual definition of blocked designs for regular fractional factorials}{
  The user can start from a design with a number of factors and manually specify which factors or 
  interactions are to be used as block generators. If this route is chosen, \code{blocks} 
  can be a vector of factor names or factor letters, or of the same form as generators, except that 
  not only base factors but all factors can be used and single factors are permitted 
  (which would lead to resolution II designs if used in generators). For example, \cr
    \code{block = Letters[c(2,4,5)]} \cr
  or \cr
    \code{block = list(2,4,5)} \cr
  specify that the 2nd, 4th and 5th factor are to be used as block generators, while \cr
    \code{block = c("Day","Shift")}\cr
  indicates that the named factors \dQuote{Day} and \dQuote{Shift} specified in \code{factor.names} 
  are to be treated as blocking factors). In this case, the number of blocks is calculated, 
  and a new factor with the default name \dQuote{Blocks} (in general the name chosen in 
  option \code{block.name}) is generated, which would for example contain as levels 
  the Day/Shift combinations. It is also possible to choose interaction effects rather than factors themselves 
  as block generators, e.g. \cr
    \code{block = c("ABCD","EFGH") } \cr
  or\cr
    \code{block = list(c(1,2,3,4),c(5,6,7,8)) }. \cr
  Finally, it is also possible to specify choice of blocks using a vector of Yates column numbers, 
  in order to be able to use catalogued blocking structures of this form, e.g. from Sitter, Chen and Feder 
  (1997).\cr
  The block main effects are defined by the \code{k.block} specified effect 
  and all interactions between them. The specified block effects are required to be independent from each other, 
  which implies that they generate \code{2^k.block} blocks. \cr
  CAUTION: If the user manually generates a blocked design, it is his/her responsibility to ensure a 
  good choice of design (e.g. by using a catalogued design from Bisgaard 1994, 
  Sun, Wu and Chen 1997, Sitter, Chen and Feder (1997), or Cheng and Wu 2002).
  Since version 2 of package \pkg{FrF2}, manual blocking is also checked for confounding of the block factor with main effects or two-factor interactions; this implies that some earlier code will now require the additional specification of argument \code{alias.block.2fis=TRUE} in order to avoid errors.
  }
    \item{Automatic definition of blocked designs for regular fractional factorials}{
  If the user only specifies the number of blocks required for the experiment, function \code{\link{FrF2}} 
  automatically generates the blocks. For full factorial designs, function \code{\link{FrF2}} uses function \code{\link{colpick}} 
  with subsequent \code{\link{blockgencreate}}, except where the Sun, Wu and Chen (1997) catalogue of blocked designs 
  contains suitable block generators for a design without estimability requirements 
  (implemented in function \code{\link{blockpick}}, which also calls \code{colpick}, if that 
  catalogue does not offer a solution). 
  Otherwise, depending on the situation, 
  function \code{\link{FrF2}} uses function \code{\link{blockpick}} or function \code{\link{colpick}} with subsequent \code{\link{blockgencreate}}; 
  function \code{\link{blockpick}} treats smaller problems (\code{choose(nruns-1-nfactors,k.block) < 100000}) without estimability requirements, other problems are treated by 
  function \code{\link{colpick}}.
  
  Use of the earlier default function \code{\link{blockpick.big}} for large cases or the earlier behavior for full factorial designs 
  can be requested with the argument 
  \code{block.old=TRUE}; this should only be done for reproducing earlier results, as the new methodology is definitely superior. 
  
  The search for an appropriate blocked design starts with the overall best unblocked design 
  (in terms of aberration or MaxC2, if requested). 
  If this best design does not yield an adequate blocking possibility, the search continues with 
  the next best design and so forth (exception: with an estimability requirement, only a single design, prefiltered for the estimability requirement, is subjected to the blocking algorithm). \cr
  For the smaller problems, function \code{\link{blockpick}} 
  looks for \code{k.block} independent subsets among the eligible columns of the design. 
  (The eligible columns are all columns of the Yates matrix that are neither occupied 
  by treatment main effects nor by 2fis among treatments (if \code{alias.block.2fis=FALSE}, 
  which is the default), or all columns of the Yates matrix that are not occupied by treatment main effects 
  (if \code{alias.block.2fis=TRUE}). Note that no effort is made to avoid aliasing with 2-factor interactions, 
  if \code{alias.block.2fis=TRUE} is chosen. 
  
  For the larger problems, or blocking in combination with requiring some 2fis to be clear of aliasing,
  function \code{\link{colpick}} creates a \eqn{q \times}{q times} \code{nfactors} \bold{X} matrix for creating 
  blocks of size \eqn{2^q} based on the approach described by Godolphin (2019); 
  function \code{blockgencreate} creates block generators from this matrix. 
  This approach can be used in combination with argument \code{estimable}, 
  as long as \code{clear=TRUE}. The implementation of this approach is described in Groemping (2019).
  The argument \code{force.godolphin} of function \code{\link{FrF2}} can enforce the Godolphin approach instead 
  of the default approach for small blocked designs. Note that the Godolphin approach solely focuses on clear 2fis 
  of the blocked design and does not attempt to avoid confounding of the block factor with non-clear 2fis; it may 
  thus confound 2fis with the block factor even if this were avoidable, maintaining the same number of clear 2fis.
  
  For the larger problems, in versions before 2.0, which can be activated in current versions with \code{block.old=TRUE},
  function \code{\link{blockpick.big}} permutes the k~base factors of candidate designs with \code{nfactors + k.block} factors 
  in search of a design the first \code{k.block}~factors of which can be used for block construction. Any 
  specification of design (via options \code{design} or \code{generators}) is ignored. Note that function 
  \code{\link{blockpick.big}} is not guaranteed to find an existing blocked design.
  
  Sun, Wu and Chen (1997) provided a catalogue of blocked designs 
  with a few quality criteria, and they stated that there is no single best design, but that the choice 
  depends on the situation. \code{FrF2} always comes up with one specific solution design. 
  Comparisons to the catalogued designs in Sun, Wu and Chen (1997) have shown that 
  the designs found in \code{FrF2} are often but not always isomorphic to the catalogued ones. 
  Differences do occur, especially if the base designs are resolution III, or if \code{\link{blockpick.big}} 
  has to be used. Expert users who want to be certain to use a \dQuote{best} blocked design should manually 
  implement a specific catalogued design or inspect several solutions from functions \code{\link{blockpick}} or \code{\link{colpick}} (or, if desparate, \code{\link{blockpick.big}}). 
  }
  }
  
  Please contact me with any suggestions for improvements.
}
\references{
Bisgaard, S. (1994a). Blocking generators for small 2\^(k-p) designs. 
\emph{J. Quality Technology} \bold{26}, 288-294.

Chen, J., Sun, D.X. and Wu, C.F.J. (1993) 
A catalogue of 2-level and 3-level orthogonal arrays. 
\emph{International Statistical Review} \bold{61}, 131-145. 

Cheng, C.-S. and Tsai, P.-W. (2009). 
Optimal two-level regular fractional factorial block and split-plot designs. 
\emph{Biometrika} \bold{96}, 83-93.

Cheng, S.W. and Wu, C.F.J. (2002). 
Choice of optimal blocking schemes in 2-level and 3-level designs. 
\emph{Technometrics} \bold{44}, 269-277. 

Godolphin, J. (2019). Construction of blocked factorial designs to estimate main effects and selected two-factor interactions. \url{https://arxiv.org/abs/1907.02373}

Groemping, U. (2019). An algorithm for blocking regular fractional 
  factorial 2-level designs with clear two-factor interactions. 
   \emph{Reports in Mathematics, Physics and Chemistry}, \href{http://www1.beuth-hochschule.de/FB_II/reports/Report-2019-003.pdf}{Report 3/2019}, 
   Department II, Beuth University of Applied Sciences Berlin.

Sitter, R.R., Chen, J. and Feder, M. (1997). 
Fractional Resolution and Minimum Aberration in Blocked 2n-k Designs.
\emph{Technometrics} \bold{39}, 382--390.

Sun, D.X., Wu, C.F.J. and Chen, Y.Y. (1997). 
Optimal blocking schemes for 2\^p and 2\^(n-p) designs. \emph{Technometrics} \bold{39}, 
298-307. 

}
\author{ Ulrike Groemping }

\seealso{ See Also \code{\link{FrF2}} for regular fractional factorials, 
\code{\link{catlg}} for the Chen, Sun, Wu catalogue of designs 
and some accessor functions, 
and \code{\link{splitplot}} for the statistical aspects of split-plot designs.}
\examples{
########## automatic blocked designs ###################
## from a full factorial ##
FrF2(8,3,blocks=2)
## with replication
run.order(FrF2(8,3,blocks=2,wbreps=2))
run.order(FrF2(8,3,blocks=2,wbreps=2,repeat.only=TRUE))
run.order(FrF2(8,3,blocks=2,bbreps=2))
run.order(FrF2(8,3,blocks=2,bbreps=2,wbreps=2))

## automatic blocked design with fractions
FrF2(16,7,blocks=4,alias.block.2fis=TRUE)
## isomorphic non-catalogued design as basis
FrF2(16,gen=c(7,11,14),blocks=4,alias.block.2fis=TRUE)
## FrF2 uses blockpick.big and ignores the generator
FrF2(64,gen=c(7,11,14),blocks=16,alias.block.2fis=TRUE)

########## manual blocked design ####################
### example that shows why order of blocks is not randomized
### can of course be randomized by user, if appropriate
FrF2(32,9,blocks=c("Day","Shift"),alias.block.2fis=TRUE, 
    factor.names=list(Day=c("Wednesday","Thursday"), Shift=c("Morning","Afternoon"),
        F1="",F2="",F3="",F4="",F5="",F6="",F7=""), default.levels=c("current","new"))

########## blocked design with estimable 2fis ####################
### all interactions of last two factors to be estimable clearly
### in 64 run design with blocks of size 4
### not possible with catalogue entry 9-3.1
FrF2(design="9-3.2", blocks=16, alias.block.2fis=TRUE, 
    factor.names = list(C1="",C2="",C3="",C4="",C5="",C6="",C7="",
    N1=c("low","high"),N2=c("low","high")), 
    default.levels = c("current","new"),
    estimable=compromise(9, 8:9)$requirement)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
