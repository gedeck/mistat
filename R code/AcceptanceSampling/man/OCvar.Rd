\name{OCvar}
\alias{OCvar}
\alias{plot,OCvar-method}
\alias{plot,OCnormal,missing-method}
\alias{plot,numeric,OCnormal-method}
\alias{show,OCvar-method}
\alias{summary,OCvar-method}

\title{Operating Characteristics of an Acceptance Sampling Plan}

\description{The preferred way of creating new objects from the family
  of \code{"OCvar"} classes.}

\usage{OCvar(n, k, type=c("normal"), ...)}

\arguments{
    \item{n}{A vector of length 1 giving the sample size.}

    \item{k}{A vector of length 1 giving the absolute distance, in units
      of the standard deviation, between the specification limit (based
      on the distribution of the items) and the acceptance limit (based
      on the distribution of the sample mean). See Schilling (1982) page
      226 for details.}
    
    \item{type}{The possible types relate to the distribution on
      which the plans are based on, namely, \code{normal}.}
    
    \item{...}{Additional parameters passed to the class
      generating function for each type. See Details for options.}  }

\details{
  Typical usages are:
  \preformatted{
    OCvar(n, k, s)
    OCvar(n, k, pd, s)
    OCvar(n, k, pd, s, s.type)
  }
  
  The two forms use a default \code{type} of "normal". Note that for the
  normal distribution the value of the standard deviation must be
  given. It is assumed to be the population standard deviation; this can
  be changed by letting \code{s.type="unknown"}.

  The second form provides a the proportion of defectives, \code{pd},
  for which the OC function should be calculated (default is
  \code{pd=seq(0, 1, 0.01)}.
}

\value{
  An object from the family of \code{OCvar-class}, namely of class
  \code{OCnormal}.
}

\references{
  Schilling, E. G. (1982), \emph{Acceptance Sampling in Quality
    Control}, Dekker

  Guenther, W. C (1977), \emph{Sampling Inspection in Statistical
    Quality Control}, Charles Griffin and Co Ltd
}

\seealso{
  \code{\link{OC2c-class}}
}

\examples{
## A normal sampling plan - st. dev. known
x <- OCvar(14, 1.205)
x ## print out a brief summary
plot(x) ## plot the OC curve
plot(x, xlim=c(0,0.4)) ## plot the useful part of the OC curve

## Assess whether the plan can meet desired risk points
assess(x, PRP=c(0.05, 0.95), CRP=c(0.2, 0.1))

summary(x, full=TRUE)
}

\keyword{classes}
