\name{FLEXPROD}
\alias{FLEXPROD}
\docType{data}
\title{
The Quinlan Experiment at Flex Products
}
\description{
Flex Products is a subcontractor of General Motors, 
manufacturing mechanical speedometer cables. 
The basic cable design has not changed for fifteen years 
and General Motors had experienced many disappointing attempts 
at reducing the speedometer noise level.
}
\usage{data(FLEXPROD)}
\format{
  A data frame with 16 observations on the following 16 variables.
  \describe{
    \item{\code{A}}{Liner O.D., a factor with levels \code{1} \code{2}}
    \item{\code{B}}{Liner Die, a factor with levels \code{1} \code{2}}
    \item{\code{C}}{Liner Material, a factor with levels \code{1} \code{2}}
    \item{\code{D}}{Liner Line Speed, a factor with levels \code{1} \code{2}}
    \item{\code{E}}{Wire Braid Type, a factor with levels \code{1} \code{2}}
    \item{\code{F}}{Braiding Tension, a factor with levels \code{1} \code{2}}
    \item{\code{G}}{Wire Diameter, a factor with levels \code{1} \code{2}}
    \item{\code{H}}{Liner Tension, a factor with levels \code{1} \code{2}}
    \item{\code{I}}{Liner Temperature, a factor with levels \code{1} \code{2}}
    \item{\code{J}}{Coating Material, a factor with levels \code{1} \code{2}}
    \item{\code{K}}{Coating Dye Type, a factor with levels \code{1} \code{2}}
    \item{\code{L}}{Melt Temperature, a factor with levels \code{1} \code{2}}
    \item{\code{M}}{Screen Pack, a factor with levels \code{1} \code{2}}
    \item{\code{N}}{Cooling Method, a factor with levels \code{1} \code{2}}
    \item{\code{O}}{Line Speed, a factor with levels \code{1} \code{2}}
    \item{\code{SN}}{ Signal to noise ratio, a numeric vector}
  }
}
\details{
\emph{Problem Definition:} the product under investigation is 
an extruded thermoplastic speedometer casing used to cover the 
mechanical speedometer cable on automobiles. Excessive 
shrinkage of the casing is causing noise in the mechanical 
speedometer cable assembly.

\emph{Response variable:} the performance characteristic in this
problem is the post extrusion shrinkage of the casing.  The percent
shrinkage is obtained by measuring approximately 600mm of casing that
has been properly conditioned \eqn{(A)}, placing that casing in a two hour
heat soak in an air circulating oven, reconditioning the sample and
measuring the length \eqn{(B)}.  
Shrinkage is computed as:  \eqn{Shrinkage = 100 * (A-B)/A}.

\emph{Factor Levels:} Existing (1) - Changed (2)

\emph{Number of Replications:} four random samples of 600mm from the
3000 feet manufactured at each experimental run.

\emph{Data Analysis:} signal to noise ratios \eqn{(SN)} are 
computed for each experimental run and analyzed using main 
effect plots and an ANOVA. Savings are derived from Loss 
function computations. 

The signal to noise formula used by Quinlan is:
\deqn{\eta = -10 log_{10} (\frac{1}{n} \sum y^2)}{\eta = -10 log_10 (1/n \sum y^2)}
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(FLEXPROD)

aov(SN ~ . , data=FLEXPROD)
}
\keyword{datasets}
