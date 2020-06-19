\name{OC2c-class}
\docType{class}
\alias{OC2c-class}
\alias{OCbinomial-class}
\alias{OChypergeom-class}
\alias{OCpoisson-class}

\title{Class Family "OC2c".}

\description{The family \code{"OC2c"} ("Operating Characteristic"
  function) of classes provides methods for creating, plotting, printing
  and assessing single, double, and multiple acceptance sampling plans
  based on the Binomial (\code{"OCbinomial"}), Hypergeometric
  (\code{"OChypergeom"}), and Poisson (\code{"OCpoisson"}) distributions.}

\section{Objects from the Class}{The \code{"OC2c"} class is a virtual
  Class: No objects may be created from it.

  However, objects from the derived classes can be created by calls of
  the form \code{new("OCbinomial", ...)}, for example, or preferably
  using the creator function \code{\link{OC2c}}.}

\section{Slots}{
  \describe{
    \item{\code{n}:}{Object of class \code{"numeric"}. A vector of
      length k giving the sample size at each of the k stages of
      sampling, e.g. for double sampling k=2.} 
    \item{\code{c}:}{Object of class \code{"numeric"}.  A vector of
      length k giving the \bold{cumulative} acceptance numbers at each
      of the k stages of sampling.}
    \item{\code{r}:}{Object of class \code{"numeric"}.   A vector of
      length k giving the \bold{cumulative} rejection numbers at each
      of the k stages of sampling.}
    \item{\code{type}:}{Object of class \code{"character"}. The possible
      types relate to the distribution on which the plans are based on,
      namely, \code{binomial}, \code{hypergeom}, and \code{poisson} }
    \item{\code{pd}:}{Object of class \code{"numeric"}. A numeric vector
      indicating the quality for which a probability of acceptance is
      calculated under the specified sampling plan. Meaning differs for
      the different \code{types}.

      For \code{"OCbinomial"} this relates to the proportion of
      defectives created by the process.

      For \code{"OChypergeom"} this relates to the proportion of
      population defectives created by the process.

      For \code{"OCpoisson"} this relates to the rate of defects (per
      item) created by the process.  }
    
    \item{\code{N}:}{Object of class \code{"numeric"}. Only for class
      \code{"OChypergeom"}, a number giving the population (lot) size from
      which the sample is drawn.}
    \item{\code{paccept}:}{Object of class \code{"numeric"}. A numeric
      vector with the probability of acceptance which correspond to the
      quality as given by \code{pd}.}
  }
}

\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x="OCbinomial", y="missing")},\cr
      \code{signature(x="numeric", y="OCbinomial")},\cr
      \code{signature(x="OChypergeom", y="missing")},\cr
      \code{signature(x="numeric", y="OChypergeom")},\cr
      \code{signature(x="OCpoisson", y="missing")} or\cr
      \code{signature(x="numeric", y="OCpoisson")}}: Plot the OC curve.
  
    \item{show}{\code{signature("OC2c")} or \code{signature("OChypergeom")}:
      Show the details of the sampling plan.}

    \item{summary}{\code{signature("OC2c")} or
      \code{signature("OChypergeom")}: Summarise the sampling
      plan. Optional argument \code{full} (defaults to \code{FALSE})
      will show the details at all quality values (\code{pd}) supplied
      when the object was created.}

    \item{assess}{\code{signature(objqect="OC2c")}: Assess whether the
      sampling plan can meet the specified \emph{Producer Risk Point
      (PRP)} and/or \emph{Consumer Risk Point (CRP)}. For details see
    \code{\link{assess,OC2c-method}}}
}
}

\references{
  Hald, A. (1981), \emph{Statistical theory of sampling inspection by
  attributes}, Academic Press.
}

\author{Andreas Kiermeier}

\seealso{
  \code{\link{OC2c}}
}

\keyword{classes}
