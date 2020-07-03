\name{splitplot}
\alias{splitplot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Statistical and algorithmic aspects of split-plot designs in FrF2 }
\description{
  This help page documents the statistical and algorithmic details of split-plot designs in FrF2
}
\details{
  A split-plot design is similar to a \code{\link{block}}ed design, with the difference that 
  there are also factors of interest that can be only changed on block level (so-called whole 
  plot factors). The blocks are called \dQuote{plots} in the context of split-plot designs. 
  The factors that can (and should!) be varied within a plot are called split-plot factors. 
  Note that the experiment provides more information on split-plot factors than on whole-plot factors.
  
  \emph{Warning:} In terms of analysis, split-plot designs would have to be treated by advanced random effects models, 
  but often are not. At the very least, the user must be aware that all whole-plot effects (i.e. effects 
  on columns that only change between plots) are (likely to be) more variable than split-plot effects so that 
  e.g. it does not necessarily mean anything if they stick out in a normal or half-normal effects plot. 
  
  Designs for hard-to-change factors are also treated by the split-plot approach in function \code{FrF2}, 
  although they are not quite split-plot designs: The are non-randomized split-plot designs arranged in an order 
  such that the first whole-plot factors have as few as possible changes. This gives very poor information on 
  these first whole-plot factors (which in the extreme are only changed once or twice), 
  if there is variability involved with setting the factor levels. \cr
  If hard-to-change factors can be implemented as true whole-plot factors with randomization, this is by far preferrable from a statistical 
  point of view (but may nevertheless be rejected from a feasibility point of view, as the necessary changes may seem unaffordable). 
  
  For design generation, there are two principal ways to handle split-plot designs, manual definition 
  (i.e. the user specifies exactly which columns are to be used for which purpose) and automatic 
  definition. Each situation has its specifics. These are detailed below. For users with 
  not so much mathematical/statistical background, it will often be best to use the automatic way, 
  specifying the treatement factors of interest via \code{nfactors} or \code{factor.names} 
  and a single number for \code{WPs}. 
  Users with more mathematical background may want to use the manual definitions, perhaps 
  in conjunction with published catalogues of good split-plot designs, or 
  after inspecting possibilities with function \code{\link{splitpick}}.
  
  \describe{
  \item{Manual definition of split-plot designs}{
  The user can specify a design with the \code{design} or the \code{generators} option 
  and specify manually with the \code{WPfacs} option, which factors are whole plot factors 
  (i.e. factors that do not change within a plot). 
  The other factors become split-plot factors (i.e. factors that do change within a plot). 
  If the user chooses this route, \code{WPfacs} must be character vectors of factor names, factor letters, 
  factor numbers preceded by capital F, or a vector or list of factor position numbers (NOT: Yates column numbers). 
  Caution: It is the users responsibility to ensure a 
  good choice of split-plot design (e.g. by using a catalogued design from Huang, Chen and Voelkel 1998, 
  Bingham and Sitter 2003, or Bingham Schoen and Sitter 2004).
  In case of a user-mistake such that the resulting design is not a split-plot design with 
  the alleged number of whole plots, an error is thrown.
  }
  \item{Automatic definition of split-plot designs}{
  As mentioned above, split-plot designs differ from block designs by the fact that the block main 
  effects are purely nuisance parameters which are assumed (based on prior knowledge) 
  to be relevant but are not of interest, while the plots are structured by 
  \code{nfac.WP} whole plot factors, which are of interest. 
  The user has to decide on a number of whole plots (\code{WPs}) as well as 
  the number of whole plot factors \code{nfac.WP}. 
  If \code{log2(WPs) <= nfac.WP <= WPs-1}, it is obviously in principle possible to accomodate the 
  desired number of whole plot factors in the desired number of whole plots. If \code{nfac.WP > WPs/2}, 
  the base design for the split-plot structure has to be of resolution III. Sometimes, 
  subject matter considerations limit whole plot sizes, and there are only few interesting 
  whole plot factors, i.e. \code{nfac.WP < log2(WPs)}. 
  In this case, it is of course nevertheless necessary to 
  have a total of \code{log2(WPs)} whole plot \emph{construction} factors; 
  the missing \code{log2(WPs) - nfac.WP} factors are added 
  to the design (names starting with \code{WP}), and \code{nfactors} is increased accordingly. 
    
  In all cases, the first \code{nfac.WPs} user-specified factors are treated as whole plot factors, the 
  remaining factors as split-plot factors. 
  
  From there, function \code{\link{FrF2}} proceeds like in the blocked situation by starting 
  with the best design and working its way down to worse designs, if the best design cannot 
  accomodate the desired split-plot structure. For each design, function \code{\link{FrF2}} 
  calls function \code{\link{splitpick}}, which permutes base factors until 
  the requested whole plot / split-plot structure is achieved, or until impossibility for 
  this design with these base factors has been ascertained. In the latter case, function \code{FrF2} 
  proceeds to the next best design and so forth. 
  
  If several competing split-plot designs based on the same base design are found, 
  the best possible resolution among the first \code{check.WPs} such designs is chosen. 
  No further criteria are automatically implemented, and no more than \code{check.WPs} 
  designs are checked. If not satisfied with the structure of the whole plot portion of the experiment, 
  increasing \code{check.WPs} vs. the default 10 may help. 
  Expert users may want to inspect possibilities, 
  using function \code{\link{splitpick}} directly.
  
  Note that the algorithm does not necessarily find an existing split-plot design. 
  It has been checked out which catalogued designs it can find: designs for all catalogued situations 
  from Bingham and Sitter (2003) have been found, as well as for most catalogued situations 
  from Huang, Chen and Voelkel (1998). Occasionally, a better design than catalogued has been found, e.g. 
  for 4 whole plot and 10 split plot factors in 32 runs with 16 whole plots, the design found by the algorithm 
  is resolution IV, while Huang, Chen and Voelkel propose a resolution III design. 
  The algorithm has the largest difficulties with extreme designs in the sense that a large number of 
  whole plots with a small number of whole plot factors are to be accomodated; thus it does not find designs for 
  the more extreme situations in Bingham, Schoen and Sitter (2004).
  }
  } 
  Please contact me with any suggestions for improvements.
  }

\references{
Bingham, D.R., Schoen, E.D. and Sitter, R.R. (2004). 
Designing Fractional Factorial Split-Plot Experiments with Few Whole-Plot Factors. 
\emph{Applied Statistics} \bold{53}, 325-339.

Bingham, D. and Sitter, R.R. (2003). Fractional Factorial Split-Plot Designs
for Robust Parameter Experiments. \emph{Technometrics} \bold{45}, 80-89.

Chen, J., Sun, D.X. and Wu, C.F.J. (1993) 
A catalogue of 2-level and 3-level orthogonal arrays. 
\emph{International Statistical Review} \bold{61}, 131-145. 

Cheng, C.-S. and Tsai, P.-W. (2009). 
Optimal two-level regular fractional factorial block and split-plot designs. 
\emph{Biometrika} \bold{96}, 83-93.

Huang, P., Chen, D. and Voelkel, J.O. (1998). Minimum-Aberration Two-Level Split-Plot Designs. 
\emph{Technometrics} \bold{40}, 314-326. 

}
\author{ Ulrike Groemping }

\seealso{ See Also \code{\link{FrF2}} for regular fractional factorials, 
\code{\link{catlg}} for the Chen, Sun, Wu catalogue of designs 
and some accessor functions, 
and \code{\link{block}} for the statistical aspects of blocked designs.}
\examples{
########## hard to change factors ####################
## example from Bingham and Sitter Technometrics 19999
## MotorSpeed, FeedMode,FeedSizing,MaterialType are hard to change
BS.ex <- FrF2(16,7,hard=4,
     factor.names=c("MotorSpeed", "FeedMode","FeedSizing","MaterialType",
                  "Gain","ScreenAngle","ScreenVibLevel"), 
     default.levels=c("-","+"))
design.info(BS.ex)
BS.ex
## NOTE: the design has 8 whole plots.
## The first hard-to-change factors have very few changes only 
## between whole plots. 
## A conscious and honest decision is required whether it is 
##    acceptable for the situation at hand not to reset them!
## A proper split-plot design with resetting all whole plot factors 
## for each whole plot would be strongly preferred from a 
## statistical point of view. 

########## automatic generation for split plot ##########
## 3 control factors, 5 noise factors, control factors are whole plot factors
## 8 plots desired in a total of 32 runs
## Bingham Sitter 2003
BS.ex2a <- FrF2(32, 8, WPs=8, nfac.WP=3, 
      factor.names=c(paste("C",1:3,sep=""), paste("N",1:5,sep="")),randomize=TRUE)

## manual generation of this same design
BS.ex2m <- FrF2(32, 8, generators=c("ABD","ACD","BCDE"),WPs=8, WPfacs=c("C1","C2","C3"), nfac.WP=3, 
      factor.names=c(paste("C",1:3,sep=""),paste("N",1:5,sep="")),randomize=TRUE)

## design with few whole plot factors
## 2 whole plot factors, 7 split plot factors
## 8 whole plots, i.e. one extra WP factor needed
BSS.cheese.exa <- FrF2(32, 9, WPs=8, nfac.WP=2, 
      factor.names=c("A","B","p","q","r","s","t","u","v"))
design.info(BSS.cheese.exa)
## manual generation of the design used by Bingham, Schoen and Sitter
## note that the generators include a generator for the 10th spplitting factor
    ## s= ABq, t = Apq, u = ABpr and v = Aqr, splitting factor rho=Apqr
BSS.cheese.exm <- FrF2(32, gen=list(c(1,2,4),c(1,3,4),c(1,2,3,5),c(1,4,5),c(1,3,4,5)), 
      WPs=8, nfac.WP=3, WPfacs=c(1,2,10),
      factor.names=c("A","B","p","q","r","s","t","u","v","rho"))
design.info(BSS.cheese.exm)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
