\name{FrF2Large}
\alias{FrF2Large}
\alias{nrunsV}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Function to provide large (at least 8192 runs) regular Fractional Factorial designs 
that are not necessarily optimal, especially large resolution V designs.}
\description{
  Large regular fractional factorial 2-level designs in 8192 or more runs are provided: 
  Resolution V designs in 8096 to 32768 runs with up to 120 factors according to the suggestion by Sanchez and Sanchez 2005 
  are automatically created (these are not necessarily optimal). Furthermore, manual generation 
  of large regular fractional factorial designs via specification of generators is possible.
}
\usage{
FrF2Large(nruns, nfactors = NULL, factor.names = if (!is.null(nfactors)){ 
    if (nfactors <= 50) 
        Letters[1:nfactors]
    else paste("F", 1:nfactors, sep = "")
    } else NULL, 
    default.levels = c(-1, 1), ncenter = 0, center.distribute = NULL, 
    generators = NULL, 
    replications = 1, repeat.only = FALSE, 
    randomize = TRUE, seed = NULL, alias.info = 2, ...) 
nrunsV(nfactors)    
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{nruns}{ Number of runs, must be a power of 2 (8192 to 32768). 
  
      The number of runs must match the number of factors. Function \code{nrunsV} 
      can be used for determining the number of runs needed for a resolution V design, 
      and for advice on the function to be used.\cr
      For more detail on specification of the number of runs, see the Details section.
      }
  \item{nfactors}{ is the number of 2-level factors to be investigated. 
      It can be omitted, if it is obvious from options \code{factor.names} or 
      \code{generators}.\cr 
      The number of factors must match the length of \code{generators}.
      }
  \item{factor.names}{ a character vector of \code{nfactors} factor names 
      or a list with \code{nfactors} elements;\cr 
      if the list is named, list names represent factor names, otherwise default factor names are used;\cr 
      the elements of the list are \cr
      EITHER vectors of length 2 with factor levels for the respective factor\cr
      OR empty strings. 
      For each factor with an empty string in factor.names, the levels given in 
      \code{default.levels} are used;\cr
       Default factor names are the first elements of the character vector \code{\link[DoE.base:utilities]{Letters}}, 
       or the factors position numbers preceded by capital F in case of more than 50 factors. }
  \item{default.levels}{ default levels (vector of length 2) for all factors for 
      which no specific levels are given }
  \item{ncenter}{ number of center points per block; \code{ncenter > 0} 
        is permitted, if all factors are quantitative and the design is not a split-plot design }
  \item{center.distribute}{ the number of positions over which the center points 
        are to be distributed for each block; if NULL (default), center points are 
        distributed over end, beginning, and middle (in that order, if there are fewer than three center points) 
        for randomized designs, and appended to the end for non-randomized designs. 
        for more detail, see function \code{\link{add.center}}, which does the work.
        }
  \item{generators}{ There are \code{log2(nruns)} base factors the full factorial 
        of which spans the design (e.g. 10 for 1024 runs). 
        The generators specify how the remaining factors 
        are to be allocated to interactions of these. \cr
        WARNING: Of course, with manual 
        specification of generators, the structure of the design is in the users 
        responsibility; the function only prevents confounding of two main effects with each 
        other.
        
        \code{generators} can be 
        
        a list of vectors with position numbers of base factors (e.g. c(1,3,4) 
        stands for the interaction between first, third and fourth base factor) 
        
        a vector of character representations of these interactions, 
        e.g. \dQuote{ACD} stands for the same interaction as above
        
        a vector of columns numbers in Yates order (e.g. 13 stands for ACD). 
        Note that the columns 1, 2, 4, 8, etc., i.e. all powers of 2, are reserved 
        for the base factors and cannot be used for assigning additional factors, 
        because the design would become a resolution II design. For looking up 
        which column number stands for which interaction, type e.g. 
        \code{names(Yates)[1:15]} for a 16 run design.
        
        WARNING: Contrary to function \code{\link{FrF2}}, it is not possible to 
        precede generator entries with a minus sign for reversing column levels; 
        instead, the levels must be swapped.
        }
  \item{replications}{ positive integer number. Default 1 (i.e. each row just once). 
       If larger, each design run is executed replication times. 
       If \code{repeat.only}, repeated measurements 
       are carried out directly in sequence, i.e. no true replication takes place, 
       and all the repeat runs are conducted together. It is likely that the error 
       variation generated by such a procedure will be too small, so that average values 
       should be analyzed for an unreplicated design. 
       
       Otherwise (default), the full experiment is first carried out once, then 
       for the second replication and so forth. In case of randomization, 
       each such blocks is randomized separately. In this case, replication variance is 
       more likely suitable for usage as error variance 
       (unless e.g. the same parts are used for replication runs although build 
       variation is important).}
  \item{repeat.only}{ logical, relevant only if replications > 1. If TRUE, 
        replications of each run are grouped together 
       (repeated measurement rather than true replication). The default is 
       \code{repeat.only=FALSE}, i.e. the complete experiment 
       is conducted in \code{replications} blocks, and each run occurs in each block.  }
  \item{randomize}{ logical. If TRUE, the design is randomized. This is the default. 
       In case of replications, the nature of randomization depends on the setting of 
       option \code{repeat.only}.}
  \item{seed}{ optional seed for the randomization process \cr
        In R version 3.6.0 and later, the default behavior of function \code{\link{sample}}
        has changed. If you work in a new (i.e., >= 3.6.-0) R version and want to reproduce 
        a randomized design from an earlier R version (before 3.6.0), 
        you have to change the RNGkind setting by\cr
        \code{RNGkind(sample.kind="Rounding")}\cr
        before running function \code{FrF2Large}.\cr
        It is recommended to change the setting back to the new recommended way afterwards:\cr
        \code{RNGkind(sample.kind="default")}\cr
        For an example, see the documentation of the example data set \code{\link[DoE.base]{VSGFS}}.
        }
  \item{alias.info}{ can be 2 or 3, gives the order of interaction effects for which 
       alias information is to be included in the \code{aliased} component of the 
       \code{design.info} element of the output object. }
  \item{\dots}{ currently not used }
}
\details{
      If generators are not explicitly specified, function \code{FrF2Large} creates a 
      resolution V design according to the 
      rules by Sanchez and Sanchez (2005) for the specified number of factors in 
      the specified number of runs. The Sanchez and Sanchez article offers designs with \cr
      at least 1024 runs for 25 to 29 factors (1024 up to 33 factors with \code{\link{FrF2}}),\cr
      at least 2048 runs for 30 to 38 factors (2048 up to 47 factors with \code{\link{FrF2}}),\cr
      at least 4096 runs for 39 to 52 factors (4096 up to 65 factors with \code{\link{FrF2}}),\cr
      at least 8192 runs for 53 to 69 factors (up to 65 factors in half the run size with \code{\link{FrF2}}),\cr
      at least 16384 runs for 70 to 92 factors, (\cr
      at least 32768 runs for 93 to 120 factors.\cr
      For designs with up to 4096 runs, function \code{\link{FrF2}} 
      creates better automatic designs. 
      Therefore, function \code{FrF2Large} is restricted to usage for larger designs. 
  
      Users can explicitly specify a design through specifying 
      generators via the \code{generators} option. For up to 4096 runs, this is also possible 
      with function \code{\link{FrF2}}, even with more flexibility. Therefore, manual design generation 
      with function \code{FrF2Large} is also restricted to designs of at least 8192 runs.

      Manual generation of large designs with the option \code{generators} is limited by 
      computer memory only. \code{nruns} must be at least large enough to accomodate the 
      rightmost generator column; for example, if generators contains an element \code{ABEP}, 
      \code{P} is the 15th base factor (15th letter in \code{\link{Letters}}), 
      i.e. \code{nruns} must be at least \code{2^15}=32768;
      if the largest generator column number in Yates column notation is 4201, 
      \code{nruns} must be at least \code{2^ceiling(log2(4201))}=8192. 
}
\value{
  Function \code{nrunsV} invisibly returns the number of runs requested and 
  prints a message with the number of runs and the appropriate function.

  Function \code{FrF2Large} returns a data frame of S3 class 
  \code{\link[DoE.base:class-design]{design}} 
  and has attached attributes that can be accessed 
  by functions \code{\link[DoE.base:class-design-methods]{desnum}}, 
  \code{\link[DoE.base:class-design-methods]{run.order}} and 
  \code{\link[DoE.base:class-design-methods]{design.info}}. 
  
  The data frame itself contains the design with levels coded as requested. 
  If no center points have been requested, the design columns are factors with 
  contrasts \code{-1} and \code{+1} (cf. also \code{\link[DoE.base]{contr.FrF2}}); in case 
  of center points, the design columns are numeric.
  
  The following attributes are attached to it: 
  \item{desnum}{Design matrix in -1/1 coding}
  \item{run.order}{three column data frame, first column contains the run number in 
       standard order, second column the run number as randomized, third column the 
       run number with replication number as postfix;
       useful for switching back and forth between actual and standard run 
       number}
  \item{design.info}{list with the entries 
  \describe{
    \item{type}{ character string \dQuote{FrF2.large}}
    \item{nruns}{ number of runs (replications are not counted) }
    \item{nfactors}{ number of factors}
    \item{factor.names }{ list named with (treatment) factor names and containing as 
         entries vectors of length two each with coded factor levels }
    \item{generators }{ for designs of type \code{FrF2.generators} only; \cr
         character vector of generators in the form D=ABC etc.}
    \item{aliased }{ alias structure of main effects, 2fis and possibly 3fis,
         depending on the choice of \code{alias.info}; 
         For non-blocked and non-split-plot designs, \code{aliased} is 
         itself a list of the two or three components main, fi2, and optionally fi3, given 
         in terms of factor letters from \code{Letters} (up to 50~factors) 
         or \code{F1}, \code{F2}, and so forth (more than 50~factors). 
         For blocked and split-plot designs, \code{aliased} is a single list 
         with an entry for each column of the Yates matrix that accomodates 
         aliased low-order effects, and entries are in terms of factor names.)}
    \item{replications }{ option setting in call to \code{FrF2} }
    \item{repeat.only }{ option setting in call to \code{FrF2} }
    \item{randomize }{ option setting in call to \code{FrF2} }
    \item{seed }{ option setting in call to \code{FrF2} }
    \item{creator }{ call to function FrF2Large; 
         (in future, may also contain stored menu settings from R commander plugin 
         \pkg{RcmdrPlugin.DoE}, once the function has been implemented in that package) 
         }
    \item{FrF2.version }{ version number of package FrF2, 
         supporting correct usage of \code{FrF2}-specific functionality in 
         functions \code{summary} and \code{generators} 
         methods for class \code{design}}
    \item{ncube }{ number of cube points per block, in case center points have been requested }
    \item{ncenter }{ number of center points per block, in case center points have been requested }
         }
       }
}
\references{
  Mee, R. (2009). \emph{A Comprehensive Guide to Factorial Two-Level Experimentation}. 
  New York: Springer.
  
    Sanchez, S.M. and Sanchez, P.J. (2005). Very Large Fractional Factorial 
     and Central Composite Designs. 
     \emph{ACM Transactions on Modeling and Computer Simulation} 
     \bold{15}, 362-377.
}
\section{Warning}{
   Since R version 3.6.0, the behavior of function \code{\link{sample}} has changed 
   (correction of a biased previous behavior that might be relevant for the randomization 
   of very large designs). 
   For reproducing a randomized design that was produced with an earlier R version, 
   please follow the steps described with the argument \code{seed}.
}
\author{ Ulrike Groemping }

\seealso{ See also \code{\link{FrF2}} for smaller regular fractional factorials and 
\code{\link[DoE.base]{oacat}} for two non-regular resolution V fractional factorials (reported e.g. by 
Mee 2009) for up to 19 factors in 256 runs or up to 63 factors in 2048 runs }
\examples{
## numbers of runs needed for resolution V designs in different numbers of factors 
nrunsV(8)
nrunsV(18)
needed <- nrunsV(27)
needed
nrunsV(65)
nrunsV(71)

\dontrun{
plan <- FrF2Large(nrunsV(75),75)
summary(plan)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
