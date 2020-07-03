\name{cubePlot}
\alias{cubePlot}
\alias{cubedraw}
\alias{cubecorners}
\alias{cubelabel}
\alias{myscatterplot3d}
\title{ Cube plot for three-factor-effects }
\description{
  A cube plot for the combined effect of three factors is produced (function cubePlot). 
  Functions cubedraw, cubecorners, cubelabel and myscatterplot3d are not intended for users. 
}
\usage{
cubePlot(obj, eff1, eff2, eff3, main=paste("Cube plot for",respnam),
    cex.title=1.5,cex.lab=par("cex.lab"), cex.ax=par("cex.axis"),  
    cex.clab=1.2, size=0.3, round=NULL,
    abbrev=4,y.margin.add=-0.2, modeled=TRUE)
}

\arguments{
  \item{obj}{ a vector of response values to be analyzed
  
                     OR
  
              a linear model object with 2-level factors or numerical 
              2-level variables (CAUTION: numerical x-variable have to be 
              coded as -1 and +1 only!); 
              the structure must be such that effects are either fully 
              aliased or orthogonal, like in a fractional factorial 2-level 
              design}
  \item{eff1}{ cf. \code{eff3} }
  \item{eff2}{ cf. \code{eff3} }
  \item{eff3}{ effects to be included in the cube plot (x-, y-, z-direction),
               EITHER vectors of equal length (two-level factors or numerical 
               with the two values -1 and 1)
               OR variable names of main effects within the \code{obj} linear
               model object (character strings) }
  \item{main}{ title for the plot, \code{respnam} is the name of the 
               response variable as determined from the call }
  \item{cex.title}{multiplier for size of overall title 
              (\code{cex.main} is multiplied with this factor) } 
  \item{cex.ax}{ size of axis tick marks, defaults to \code{cex.axis}-parameter }
  \item{cex.lab}{ size of axis labels }
  \item{cex.clab}{ size of corner labels }
  \item{size}{ size of cube corners }
  \item{round}{ optional rounding of corner labels (digits argument for function 
               \code{round}, e.g. round=0 for integers, round=-1 for multiples
               of 10, round=1 for 1 decimal place}
  \item{abbrev}{ number of characters shown for factor levels }
  \item{y.margin.add}{ adjustment parameter for placement of y-axis labeling }
  \item{modeled}{ TRUE (default: show modeled means; FALSE: show averages 
  
               NOTE: Even when showing modeled means, there also appears to 
               be a three-factor-interaction, if the model contains an effect
               that is aliased with this interaction!}
}

\details{
  \code{cubePlot} produces a cube plot of the modeled means or averages of 
              all combinations for three factors. The other functions are internal
              and are called by cubePlot.
  \code{myscatterplot3d} is a modified version of scatterplot3d, 
              made more suitable for this situation.
}
\value{
  \code{cubePlot} is used for its side effects only. 
}

\references{ 
    Box G. E. P, Hunter, W. C. and Hunter, J. S. (2005)
    \emph{Statistics for Experimenters, 2nd edition}.
    New York: Wiley.
 }
\author{ Ulrike Groemping }

\seealso{ \code{\link{FrF2-package}} for examples }
\keyword{ design }
