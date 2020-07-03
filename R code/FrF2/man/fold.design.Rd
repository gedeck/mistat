\name{fold.design}
\Rdversion{1.1}
\alias{fold.design}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to create a foldover for 2-level fractional factorials
}
\description{
This function creates a foldover design for a 2-level fractional 
factorial. The purpose is to dealias (some) effects. 
Per default, all factors are folded upon, which makes the resulting 
design at least resolution IV. Different foldover versions can be requested.
}
\usage{
fold.design(design, columns = "full", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{design}{
  a data frame of class design that contains a 2-level fractional factorial; 
  currently, \code{design} must neither be blocked nor a long version parameter design
}
  \item{columns}{
  indicates which columns to fold on; the default \dQuote{full} folds on all columns, 
  i.e. swaps levels for all columns. \cr  
  A specific fold on certain columns can be requested giving a character vector 
  of factor names or a numeric vector of factor positions.\cr
  See the details section for some statistical comments.
   }
  \item{\dots}{
   currently not used}
}
\details{
  Foldover is a method to dealias effects in relatively small 
  2-level fractional factorial designs. The folded design has twice the number 
  of runs from the original design, and an additional column \dQuote{fold} that 
  distinguishes the original runs from the mirror runs. This column should be used 
  in analyses, since it captures a block effect on time (often the mirror runs 
  are conducted substantially later than the original experiment).
  
  Like most other software, this function conducts a full foldover per default, 
  i.e. the mirror portion reverses the levels of all factors. In terms of the 
  convenient -1/1 notation for factor levels, this can be written as 
  a multiplication with \dQuote{-1} for the mirror portion of all factors. 
  Thus, all confounding relations involving 
  an odd number of factors (e.g. A=BC) are resolved, because the odd side of the 
  equation involves a minus for the mirror runs, and the even side does not 
  (since the minuses cancel each other). (These 
  confounding relations are replaced by even ones 
  for which the odd side of the equation is multiplied with minus the new mirror factor \code{fold}.) 
  
  There are many situations, for which the default full foldover is 
  not the best possible foldover fraction, cf. e.g. Li and Mee (2002). 
  It is therefore possible to choose an arbitrary foldover fraction. For example, 
  folding on one particular factor alone dealiases all confounding relations 
  for that factor, folding on two particular factors dealiases all confounding relations 
  of these two with others but not of these two together with others and so on.
  
  Folding Plackett-Burman designs also removes the (partial) aliasing with 2-factor 
  interactions for all main effects that are mirrored.
  
}
\value{
  A data frame of class design with twice as many rows as \code{design} and 
  the additional factor \code{fold} (added as the last factor for folded \code{pb} 
  designs, as the first factor for splitplot designs, 
  and as the last \emph{base} factor for other folded regular fractional 
  factorial designs).
  
  Existing response values are of course preserved, and response values for the 
  new mirror runs are NA.
  
  The type in attribute \code{design.info} is suffixed with \dQuote{.folded}, and 
  \code{nruns} (and, if applicable, \code{nWPs}) is doubled, 
  \code{nfactors} (and, if applicable, \code{nfac.WP}) 
  is increased by one (for the factor fold, which 
  is a block factor and can also be treated as such, but will currently be treated as a fixed 
  (whole plot) factor by any automated analysis routine). The creator element receives a list entry for the fold columns.\cr
  For regular fractional factorials (design type starting with \code{FrF2}), the generator element is adjusted 
  (the generators for all generated fold factors now involve the folding factor), and an existing 
  catlg.entry element is replaced by a new generators element. The \code{aliased} element is 
  adapted to the new alias structure. Note that the fold factor enters as a new base factor and therefore 
  is added to the factor matrix after the first log2(nruns) factors. This implies that all factor 
  letters previously used for the generated factors are changed - for avoiding confusion it is always recommended to 
  work with factor names that are meaningful in a subject-matter sense.
  
  Furthermore, for the regular fractional factorial designs, 
  the column run.no.in.std.order in attribute \code{run.order} for the mirror portion of the design is 
  populated such that the base factors remain in the conventional order when ordered by 
  run.no.in.std.order (regardless whether or not they are included in the fold; 
  it is always possible to reorder runs such that the original base factors 
  together with the folding factor form the new base in standard order).
}
\references{

    Li, H. and Mee, R. (2002). Better foldover fractions for resolution III 2^(k-p) designs. 
    \emph{Technometrics} \bold{44}, 278--283. 
    New York: Springer.

    Mee, R. (2009). \emph{A Comprehensive Guide to Factorial Two-Level Experimentation}. 
    New York: Springer.

    Montgomery, D.C. (2001). \emph{Design and Analysis of Experiments (5th ed.)}. Wiley, New York.

}
\author{
Ulrike Groemping
}
\note{
    This function is still somewhat experimental.
}

\seealso{
See also as \code{\link{pb}}, \code{\link{FrF2}}
}
\examples{
  ## create resolution III design
  plan <- FrF2(8,5, factor.names=c("one","two","three","four","five"))
  ## add some resonse data
  y <- c(2+desnum(plan)\%*\%c(2,3,0,0,0) +
     1.5*apply(desnum(plan)[,c(1,2)],1,"prod") + rnorm(8))
     ## the "c()" makes y into a vector rather than a 1-column matrix
  plan <- add.response(plan, y)
  DanielPlot(lm(y~(.)^2,plan), alpha=0.2, half=TRUE)
  ## alias information
  design.info(plan)
  ## full foldover for dealiasing all main effects
  plan <- fold.design(plan)
  design.info(plan)
  ## further data, shifted by -2
  y <- c(y, desnum(plan)[9:16,1:5]\%*\%c(2,3,0,0,0) +
     1.5*apply(desnum(plan)[9:16,c(1,2)],1,"prod") + rnorm(8))
  plan <- add.response(plan, y, replace=TRUE)
  linmod <- lm(y~(.)^2,plan)
  DanielPlot(linmod, alpha=0.2, half=TRUE)
  MEPlot(linmod)
  IAPlot(linmod)
  
  ## fold on factor a only (also removes main effect aliasing here)
  plan <- FrF2(8,5, factor.names=c("one","two","three","four","five"))
  aliasprint(plan)
  plan <- fold.design(plan, columns=1)
  aliasprint(plan)
  
  ## fold a Plackett-Burman design with 11 factors
  plan <- pb(12)
  fold.design(plan)
   }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ design }
\keyword{ array }% __ONLY ONE__ keyword per line
