\name{availDis}
\alias{availDis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Availability Distribution
}
\description{
Provide the Empirical Bootstrap Distribution of the asymptotic 
availability index \eqn{A_\infty}, based on observed samples of failure times and repair times.  
}
\usage{
availDis(ttf, ttr, n, seed = NA, printSummary = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ttf}{
numeric vector of Time To Failure
}
  \item{ttr}{
numeric vector of Time To Repair
}
  \item{n}{
the number of bootstrap replicates
}
  \item{seed}{
a single value, interpreted as an integer. If specified make 
the simulation replicable.
}
  \item{printSummary}{
logical, if \code{TRUE} print the Mean Time To Failure, Mean 
Time To Repair and the asymptotic availability
}
}
\value{
A numeric vector of lenght \code{n} with simulated availabilities
}
\references{
  Kenett, R., Zacks, S. with contributions by Amberti, D.
  \emph{Modern Industrial Statistics: with applications in R, MINITAB and JMP}.
  Wiley.
}
\author{
Daniele Amberti
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{renewDis}}
}
\examples{
set.seed(123)

Ttf <- rgamma(50, 
              shape=2, 
              scale=100)

Ttr <- rgamma(50, 
              shape=2, 
              scale=1)

AvailEbd <- availDis(ttf=Ttf,  
                     ttr=Ttr, 
                     n=1000)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ nonparametric }
\keyword{ distribution }
\keyword{ ts }
