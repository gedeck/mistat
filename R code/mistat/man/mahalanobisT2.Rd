\name{mahalanobisT2}
\alias{mahalanobisT2}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Mahalanobis \eqn{T^2}
}
\description{
Mahalanobis \eqn{T^2} and Confidence Region
}
\usage{
mahalanobisT2(x, factor.name, response.names = names(x)[!names(x) \%in\% factor.name], 
conf.level=0.95, compare.to = NA, plot = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
a data frame
}
  \item{factor.name}{
single character indicating column name of the experiment factor 
to test, the first level is used as a reference
}
  \item{response.names}{
vector of characters indicating columns names of the responses
}
  \item{conf.level}{
confidence level for the Confidence Region
}
  \item{compare.to}{
a vector of length \code{length(response.names)} to be compared 
to the result in terms of Mahalanobis \eqn{T^2}
}
  \item{plot}{
logical, if \code{TRUE} also a plot is produced
}
}
\value{
a list with components:
  \item{coord }{matrix with transformed coordinates of variables 
  in \code{response.names}}
  \item{mahalanobis }{vector containing Lower Control Region, 
  Center and Upper Control Region of Mahalanobis \eqn{T^2}}
  \item{mahalanobis.compare }{single value, Mahalanobis \eqn{T^2} 
  of \code{compare.to}}
}
\references{
  Kenett, R., Zacks, S. with contributions by Amberti, D.
  \emph{Modern Industrial Statistics: with applications in R, MINITAB and JMP}.
  Wiley.
  
  Tsong et al, (1996).
}
\author{
Daniele Amberti
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{
data(DISS)

mahalanobisT2(DISS[, c("batch", "min15", "min90")], 
              factor.name="batch", 
              conf.level=0.90,
              compare.to=c(15, 15))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ multivariate }


