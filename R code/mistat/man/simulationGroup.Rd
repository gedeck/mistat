\name{simulationGroup}
\alias{simulationGroup}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Simulation Group
}
\description{
Add a column named \code{group} to an object of class "mistatSimulation".
}
\usage{
simulationGroup(x, n)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
an object of class "mistatSimulation"
}
  \item{n}{
size of the group or sample
}
}
\value{
Add a column named \code{group} to an object of class "mistatSimulation".
}
\author{
Daniele Amberti
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{pistonSimulation}}, 
  \code{\link{powerCircuitSimulation}}
}
\examples{
simulationGroup(pistonSimulation(each=20), 5)
simulationGroup(powerCircuitSimulation(each=20), 5)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
