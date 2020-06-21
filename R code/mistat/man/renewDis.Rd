\name{renewDis}
\alias{renewDis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Renewals Disribution
}
\description{
Provide the Empirical Bootstrap Distribution of the number of 
renewals in a specified time interval. 
}
\usage{
renewDis(ttf, ttr, time, n, printSummary = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ttf}{
numeric vector of Time To Failure
}
  \item{ttr}{
numeric vector of Time To Repair
}
  \item{time}{
numeric value representing the time horizon on which number of 
renewals are calculated
}
  \item{n}{
the number of bootstrap replicates
}
  \item{printSummary}{
logical, if \code{TRUE} print the Mean Number of Renewals, and 
a summary of renewals values
}
}
\value{
A numeric vector of lenght \code{n} with simulated number of 
renewals
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
\code{\link{availDis}}
}
\examples{
set.seed(123)

Ttf <- rgamma(50, 
              shape=2, 
              scale=100)

Ttr <- rgamma(50, 
              shape=2, 
              scale=1)

RenewEbd <- renewDis(ttf=Ttf, 
                     ttr=Ttr, 
                     time=1000, 
                     n=1000)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ nonparametric }
\keyword{ distribution }
\keyword{ ts }
