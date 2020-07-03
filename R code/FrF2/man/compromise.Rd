\name{compromise}
\alias{compromise}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Function to support estimability requests for compromise designs }
\description{
  Addelman (1962) and Ke and Wu (2005) discuss compromise plans of different types. 
  Their creation is supported by the function compromise.
}
\usage{
    compromise(nfactors, G1, class=3, msg=TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{nfactors}{ overall number of factors}
  \item{G1}{ vector with indices of factors in group G1 (cf. details)}
  \item{class}{ class of compromise designs that is to be generated; 1, 2, 3, or 4, cf. details below }
  \item{msg}{ logical stating whether the \code{minnruns.clear} element of the result
      should be reported in a message}
}
\details{
  For compromise plans, the factors are decomposed into a group G1 and a group G2. 
  The different classes of compromise plans require estimability of different subsets 
  of 2fis in addition to main effects:\cr\cr
  Class 1: all 2fis within group G1 are estimable\cr
  Class 2: all 2fis within group G1 are estimable, 
  as well as all 2fis within group G2\cr
  Class 3: all 2fis within group G1 are estimable, 
  as well as all 2fis between groups G1 and G2\cr
  Class 4: all 2fis between groups G1 and G2 are estimable\cr

  The function returns a list of four components (cf. section \dQuote{Value}). 
  They can be used as input for the function \code{\link{FrF2}}, if compromise 
  plans are to be created. Both distinct designs (Addelman 1962) and clear designs 
  (Ke, Tang and Wu 2005) can be constructed, 
  depending on the settings of option \code{clear} in function 
  \code{\link{FrF2}}. More explanations on specifying estimability requirements 
  for 2fis in general are provided under \code{\link{estimable.2fis}}.
}
\value{
  Value is a list of the four components \code{perms.full}, \code{requirement}, 
  \code{class}, and \code{minnrun.clear}. The last two components are purely imformative, 
  while the first two provide input parameters for function \code{\link{FrF2}}.\cr
  \code{requirement} can be used for specifying the required 2fis in the \code{estimable} option, 
  both with \code{clear=FALSE} and \code{clear=TRUE}. 
  For \code{clear=FALSE}, \code{perms.full} can be used in the \code{perms} option 
  for speeding up the search into a hopefully realistic time frame.\cr 
  \code{minnrun.clear} indicates the minimum number of runs needed for a clear design.
  
  Note that the catalogue \code{\link{catlg}} contains all designs needed for 
  accomodating existing clear compromise designs in up to 128 runs (even minimum aberration
  among all existing clear compromise designs; for a catalogue of these, cf. Gr\"omping 2010).
}
\references{
Addelman, S. (1962). Symmetrical and asymmetrical fractional factorial plans. 
\emph{Technometrics} \bold{4}, 47-58.

Gr\"omping, U. (2010). Creating clear designs: a graph-based algorithm and a 
catalogue of clear compromise plans. 
\emph{Reports in Mathematics, Physics and Chemistry}, report 05/2010, 
Department II, Beuth University of Applied Sciences Berlin.
(Preprint for IIE Transactions; IIE Transactions is available at 
\url{http://www.tandfonline.com}.)

Ke, W., Tang, B. and Wu, H. (2005). Compromise plans with clear two-factor interactions. 
\emph{Statistica Sinica} \bold{15}, 709-715.
}
\author{ Ulrike Groemping }

\seealso{ See Also \code{\link{FrF2}} for creation of regular fractional factorial designs 
as well as \code{\link{estimable.2fis}} 
for statistical and algorithmic information on estimability of 2-factor interactions}
\examples{
## seven factors two of which are in group G1
C1 <- compromise(7, c(2,4), class=1)
C1$perms.full  ## the same for all classes
C1$requirement
C2 <- compromise(7, c(2,4), class=2)
C2$requirement
C3 <- compromise(7, c(2,4), class=3)
C3$requirement
C4 <- compromise(7, c(2,4), class=4)
C4$requirement

\dontrun{
########## usage of estimable ###########################
  ## design with with BD clear in 16 runs
  FrF2(16,7,estimable = C1$requirement)
  ## design with BD estimable on a distinct column in 16 runs (any design will do,
  ##    if resolution IV!!!
  FrF2(16,7,estimable = C1$requirement, clear=FALSE, perms=C1$perms.full)
  ## all four classes, mostly clear, for 32 runs
  FrF2(32,7,estimable = C1$requirement)
  FrF2(32,7,estimable = C2$requirement)   ## requires resolution V
         ## as clear class 2 compromise designs do not exist due to Ke et al. 2005
  FrF2(32,7,estimable = C2$requirement, clear=FALSE, perms=C2$perms.full)
  FrF2(32,7,estimable = C3$requirement)
  FrF2(32,7,estimable = C4$requirement)
  ## two additional factors H and J that do not show up in the requirement set
  FrF2(32,9,estimable = C3$requirement)
  ## two additional factors H and J that do not show up in the requirement set
  FrF2(32,9,estimable = C3$requirement, clear=FALSE)
  ## note that this is not possible for distinct designs in case perms is needed,
  ## because perms must have nfactors columns
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
