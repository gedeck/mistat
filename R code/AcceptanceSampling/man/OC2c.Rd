\name{OC2c}
\alias{OC2c}
\alias{plot,OC2c-method}
\alias{plot,OCbinomial,missing-method}
\alias{plot,numeric,OCbinomial-method}
\alias{plot,OChypergeom,missing-method}
\alias{plot,numeric,OChypergeom-method}
\alias{plot,OCpoisson,missing-method}
\alias{plot,numeric,OCpoisson-method}
\alias{show,OC2c-method}
\alias{show,OChypergeom-method}
\alias{summary,OC2c-method}
\alias{summary,OChypergeom-method}

\title{Operating Characteristics of an Acceptance Sampling Plan}

\description{ The preferred way of creating new objects from the family
  of \code{"OC2c"} classes.}

\usage{OC2c(n,c,r=if (length(c)<=2) rep(1+c[length(c)], length(c)) else NULL,
  type=c("binomial","hypergeom", "poisson"), ...) }

\arguments{
    \item{n}{A vector of length k giving the sample size at each
      of the k stages of sampling, e.g. for double sampling k=2.}

    \item{c}{A vector of length k giving the \bold{cumulative}
      acceptance numbers at each of the k stages of sampling.}
    
    \item{r}{A vector of length k giving the \bold{cumulative}
      rejection numbers at each of the k stages of sampling.}
    
    \item{type}{The possible types relate to the distribution on
      which the plans are based on, namely, \code{binomial},
      \code{hypergeom}, and \code{poisson}.}
    
    \item{...}{Additional parameters passed to the class
      generating function for each type. See Details for options.}  }

\details{
  Typical usages are:
  \preformatted{
    OC2c(n, c)
    OC2c(n, c, r, pd)
    OC2c(n, c, r, type="hypergeom", N, pd)
    OC2c(n, c, r, type="poisson", pd)
  }
  
  The first and second forms use a default \code{type} of
  "binomial". The first form can calculate \code{r} \emph{only} when
  \code{n} and \code{c} are of length 1 or 2.

  The second form provides a the proportion of defectives, \code{pd}, for
  which the OC function should be calculated (default is \code{pd=seq(0,
  1, 0.01)}.
  
  The third form states that the OC function based on a Hypergeometric
  distribution is desired. In this case the population size \code{N}
  also needs to be specified. In this case, \code{pd} indicates the
  proportion of population defectives, such that \code{pd*N} gives the
  actual number of defectives in the population. If \code{N} or
  \code{pd} are not specified they take defaults of \code{N=100} and
  \code{pd=seq(0, 1, 0.01)}.  A warning is issued if N and D=N*pd are
  not integers by checking the value, not the object type.
}

\value{
  An object from the family of \code{OC2c-class}, namely of class
  \code{OCbinomial}, \code{OChypergeom}, or \code{OCpoisson}.
}

\seealso{
  \code{\link{OC2c-class}}
}

\examples{
## A standard binomial sampling plan
x <- OC2c(10,1)
x ## print out a brief summary
plot(x) ## plot the OC curve
plot(x, xlim=c(0,0.5)) ## plot the useful part of the OC curve

## A double sampling plan
x <- OC2c(c(125,125), c(1,4), c(4,5), pd=seq(0,0.1,0.001))
x
plot(x) ## Plot the plan

## Assess whether the plan can meet desired risk points
assess(x, PRP=c(0.01, 0.95), CRP=c(0.05, 0.04))

## A plan based on the Hypergeometric distribution
x <- OC2c(10,1, type="hypergeom", N=5000, pd=seq(0,0.5, 0.025))
plot(x)

## The summary
x <- OC2c(10,1, type="hypergeom", N=5000, pd=seq(0,0.5, 0.1))
summary(x, full=TRUE)

## Plotting against a function which generates P(defective)
xm <- seq(-3, 3, 0.05) ## The mean of the underlying characteristic
x <- OC2c(10, 1, pd=1-pnorm(0, mean=xm, sd=1))
plot(xm, x) ## Plot P(accept) against mean
}

\keyword{classes}
