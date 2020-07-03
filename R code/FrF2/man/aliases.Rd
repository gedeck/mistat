\name{aliases}
\alias{aliases}
\alias{aliasprint}
\alias{print.aliases}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Alias structure for fractional factorial 2-level designs }
\description{
  Functions to examine the alias structure of a 
  fractional factorial 2-level design
}
\usage{
aliases(fit, code = FALSE, condense=FALSE)
aliasprint(design, ...)
\method{print}{aliases}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fit}{ a linear model object with only 2-level factors as explanatory variables;
              the function will return an error, if the model contains partially
              aliased effects (like interactions in a Plackett-Burman design 
              for most cases) }
  \item{code}{ if TRUE, requests that aliasing is given in code letters (A, B, C 
              etc.) instead of (potentially lengthy) variable names; 
              in this case, a legend is included in the output object.}
  \item{condense}{ if TRUE, reformats the alias information to 
              be comparable to the version calculated by internal function alias3fi;
              does not work with models with higher than 3-way interactions;
              for up to 3-way interactions, the output may be more easily readible}
  \item{design}{ a data frame of class \code{design} that should contain a fractional 
              factorial 2-level design; the function does not print anything if 
              the design is of different nature}
  \item{x}{   an object of class \code{aliases} that should be the output from 
              function \code{aliases} }
  \item{\dots}{further arguments to function \code{\link{print.default}};\cr
              the \code{quote} argument cannot be used}
}
\value{
  Function \code{aliasprint} returns NULL and is called for its side effects only.
  
  Per default, Function \code{aliases} returns a list with two elements:
  \item{legend }{links the codes to variable names, if \code{code=TRUE}.}
  \item{aliases }{is a list of vectors of aliased effects.}
  
  If option \code{condense} is TRUE, the function returns a list with elements legend, 
  main, fi2 and fi3; this may be preferrable for looking at the alias structure of larger designs. 
  
  The output object of function \code{aliases} has class \code{aliases}, 
  which is used for customized printing with the \code{print} method.
}
\references{ 
    Box G. E. P, Hunter, W. C. and Hunter, J. S. (2005) 
    \emph{Statistics for Experimenters, 2nd edition}.
    New York: Wiley.
    }
\author{ Ulrike Groemping }
\seealso{ \code{\link{FrF2-package}} for information on the package, 
     \code{\link{alias}} for the built-in R-function, 
     \code{\link{IAPlot}} for effects plots }
\keyword{ design }

\examples{
    ### Injection Molding Experiment. Box et al. 1978.
    data(BM93.e3.data, package="BsMD")  #from BsMD
    iMdat <- BM93.e3.data[1:16,2:10]  #only original experiment
    # make data more user-friendly
    colnames(iMdat) <- c("MoldTemp","Moisture","HoldPress","CavityThick",
             "BoostPress","CycleTime","GateSize","ScrewSpeed","y")
    # determine aliases with all 2-factor-interactions
    aliases(lm(y ~ (.)^2, data = iMdat))
    # coded version
    aliases(lm(y ~ (.)^2, data = iMdat), code=TRUE)
    # determine aliases with all 3-factor-interactions
    aliases(lm(y ~ (.)^3, data = iMdat), code=TRUE)
    # show condensed form
    aliases(lm(y ~ (.)^3, data = iMdat), code=TRUE, condense=TRUE)
    # determine aliases for unaliased model
    aliases(lm(y ~ ., data = iMdat))
}
