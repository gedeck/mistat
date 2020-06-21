\name{randomizationTest}
\alias{randomizationTest}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Randomization Test 
}
\description{
A function to perform randomization test
}
\usage{
randomizationTest(list, R = 500, calc, fun = NA, 
                  seed = NA, printSummary = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{list}{
a list with two or more numeric vectors
}
  \item{R}{
%%     ~~Describe \code{R} here~~
}
  \item{calc}{
a function to be applied to every vector in \code{list}
}
  \item{fun}{
a function to be applied to a vector (e.g. \code{x}) of length 
\code{length(list)}, containing result of function \code{calc} 
}
  \item{seed}{
a single value, interpreted as an integer. If specified make 
the simulation replicable.
}
  \item{printSummary}{
logical, if \code{TRUE} print a summary of the randomization 
test
}
}
\value{
The silently returned value is an object of class "boot"
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
\code{\link{boot}}
}
\examples{
data(OELECT)
data(OELECT1)

# test difference in mean:
randomizationTest(list(a=OELECT, b=OELECT1), 
                  R=500, calc=mean, 
                  fun=function(x) x[1]-x[2],
                  seed=123)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ nonparametric }
