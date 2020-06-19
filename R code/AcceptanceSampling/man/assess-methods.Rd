\name{assess-methods}
\docType{methods}
\alias{assess}
\alias{assess-methods}
\alias{assess,OC2c-method}
\alias{assess,OCvar-method}

\title{Assessment methods for the class family "OC2c" and "OCvar".}

\description{Assess whether the sampling plan can meet the specified
  \emph{Producer Risk Point (PRP)} and/or \emph{Consumer Risk Point (CRP)}.}
  
\section{Methods}{
  \describe{
    \item{object="OC2c"}{Assess whether the sampling plan can meet the
      provided producer and/or consumer risk point(s).}
}}

\section{Usage}{assess(object, PRP, CRP, print)}

\arguments{

  \item{object}{An object of class \code{OC2c} or \code{OCvar}.}

  \item{PRP}{The Producer Risk Point in the form of a two element
  numeric vector of the form \code{c(pd, pa)}. The first element
  specifies, \code{pd}, determines the quality level at which to
  evaluate the plan. The second element, \code{pa}, indicates the
  \emph{minimum} probability of acceptance to be achieved by the plan.}

  \item{CRP}{The Consumer Risk Point in the form of a two element
  numeric vector of the form \code{c(pd, pa)}. The first element
  specifies, \code{pd}, determines the quality level at which to
  evaluate the plan. The second element, \code{pa}, indicates the
  \emph{maximum} probability of acceptance to be achieved by the plan.}

  \item{print}{Logical indicating whether to print a summary of the
    assessment or not. Defaults to \code{TRUE}}
}

\author{Andreas Kiermeier}

\seealso{
  \code{\link{OC2c}}, \code{\link{OCvar}}
}

\keyword{methods}
