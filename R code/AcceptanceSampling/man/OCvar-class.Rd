\name{OCvar-class}
\docType{class}
\alias{OCvar-class}
\alias{OCnormal-class}

\title{Class Family "OCvar".}

\description{The family \code{"OCvar"} ("Operating Characteristic"
  function) of classes provides methods for creating, plotting, printing
  and assessing single acceptance sampling plans for variables,
  based on the Normal (\code{"OCnormal"}) distribution.}

\section{Objects from the Class}{The \code{"OCvar"} class is a virtual
  Class: No objects may be created from it.

  However, objects from the derived classes can be created by calls of
  the form \code{new("OCnormal", ...)}, for example, or preferably
  using the creator function \code{\link{OCvar}}.}

\section{Slots}{
  \describe{
    \item{\code{n}:}{Object of class \code{"numeric"}. A vector of
      length 1 giving the sample size.} 

    \item{\code{k}:}{Object of class \code{"numeric"}.  A vector of
      length 1 giving the absolute distance, in units of the standard
      deviation, between the specification limit (based on the
      distribution of the items) and the acceptance limit (based on the
      distribution of the sample mean). See Schilling (1982) page 226
      for details.}

    \item{\code{type}:}{Object of class \code{"character"}. The possible
      types relate to the distribution on which the plans are based on.
      Currently the only supported distribution is \code{normal}.}

    \item{\code{pd}:}{Object of class \code{"numeric"}. A numeric vector
      indicating the quality for which a probability of acceptance is
      calculated under the specified sampling plan. Meaning differs for
      the different \code{types}.

      For \code{"OCnormal"} this relates to the proportion of
      defectives created by the process.}
    
    \item{\code{s}:}{Object of class \code{"numeric"}. A vector of
    length 1 giving the population/sample standard deviation.}

    \item{\code{s.type}:}{Object of class \code{"character"}. Only for class
      \code{"OCnormal"}, indicates whether the plan is based on the
      population (\code{s.type="known"}) or sample standard deviation
      (\code{s.type="known"}).}
    \item{\code{paccept}:}{Object of class \code{"numeric"}. A numeric
      vector with the probability of acceptance which correspond to the
      quality as given by \code{pd}.}
  }
}

\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x="OCnormal", y="missing")},\cr
      \code{signature(x="numeric", y="OCnormal")}}: Plot the OC curve.
  
    \item{show}{\code{signature("OCvar")}:
      Show the details of the sampling plan.}

    \item{summary}{\code{signature("OCcar")}: Summarise the sampling
      plan.  Optional argument \code{full} (defaults to \code{FALSE})
      will show the details at all quality values (\code{pd}) supplied
      when the object was created.}

    \item{assess}{\code{signature(object="OCvar")}: Assess whether the
      sampling plan can meet the specified \emph{Producer Risk Point
      (PRP)} and/or \emph{Consumer Risk Point (CRP)}. For details see
      \code{\link{assess,OCvar-method}}} } }
  
  
\references{
  Guenther, W. C. (1977) \emph{Sampling Inspection in statistical
    quality control}, Charles Griffin and Company Limited

  Hald, A. (1981), \emph{Statistical theory of sampling inspection by
    attributes}, Academic Press.

  Schilling, E. G. (1982), \emph{Acceptance Sampling in Quality
    Control}, Dekker
}

\author{Andreas Kiermeier}

\seealso{
  \code{\link{OCvar}}
}

\keyword{classes}
