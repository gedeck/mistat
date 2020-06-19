\name{find.plan}
\alias{find.plan}

\title{Utility function for finding sampling plans.}

\description{Find the sampling plan with smallest sample size (single
  sample only) such that specified \emph{Producer Risk Point (PRP)} and
  \emph{Consumer Risk Point (CRP)} are both met.}
  
\section{Usage}{
  find.plan(PRP, CRP, type="binomial")
  
  find.plan(PRP, CRP, type="hypergeom", N)
  
  find.plan(PRP, CRP, type="normal", s.type="unknown")
}

\arguments{

  \item{PRP}{The Producer Risk Point in the form of a two element
  numeric vector of the form \code{c(pd, pa)}. The first element,
  \code{pd}, specifies the quality level at which to evaluate the
  plan. The second element, \code{pa}, indicates the \emph{minimum}
  probability of acceptance to be achieved by the plan.}

  \item{CRP}{The Consumer Risk Point in the form of a two element
  numeric vector of the form \code{c(pd, pa)}. The first element,
  \code{pd}, specifies the quality level at which to evaluate the
  plan. The second element, \code{pa}, indicates the \emph{maximum}
  probability of acceptance to be achieved by the plan.}

  \item{type}{The distribution which the sampling plan is based
    on. Possible values are \code{binomial}, \code{hypergeom},
    \code{poisson} and \code{normal}.}

  \item{N}{The size of the population from which samples are drawn. Only
    applicable for \code{type="hypergeom"}.}

  \item{s.type}{The type of the standard deviation. A value of
    \code{known} results in a sampling plan based on the population
    standard deviation, while a value of \code{unknown} results in the
    use of the sample standard deviation.}  }

\author{Andreas Kiermeier}

\seealso{
  \code{\link{OC2c}}, \code{\link{OCvar}}
}

\keyword{methods}
