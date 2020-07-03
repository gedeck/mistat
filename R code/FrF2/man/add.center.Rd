\name{add.center}
\Rdversion{1.1}
\alias{add.center}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to add center points to a 2-level fractional factorial
}
\description{
This function adds center points to a 2-level fractional factorial design. 
All factors must be quantitative!
}
\usage{
add.center(design, ncenter, distribute=NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{design}{
  a data frame of class design that contains a 2-level fractional factorial 
  (regular or non-regular); 
  \code{design} must neither be a split-plot nor a long version parameter design.\cr
  For function \code{add.center}, the design must not contain center points yet, 
  while it has to contain center points for function \code{iscube}.
  
  For function \code{add.center}, blocked and replicated (or repeated measurement) designs 
  must be in the original run order (column run.no in run.order attribute 
  in ascending order), as the algorithm relies on the related runs being grouped as 
  expected. An error is thrown, if this condition is violated.
}
  \item{ncenter}{
  the number of center points to be added to each block
   }
  \item{distribute}{
  the number of positions over which to distribute the center points within each block; 
  note that the center points are not randomized but placed evenly throughout the 
  (hopefully randomdomized) design (but see also the details section);\cr
  if distribute is NULL, center points are all added at the end for non-randomized designs 
  and are distributed as evenly as possible to beginning, middle and end of the experiment 
  for randomized designs. 
  
  \code{distribute} must neither be larger than \code{ncenter} nor than 
  the number of runs of the design plus one. 
   }
  \item{\dots}{
   currently not used}
}
\details{
  Function \code{add.center} adds center points to 2-level fractional factorial 
  designs. Instead of using this function directly, center points should usually 
  be added directly with calls to functions \code{\link{FrF2}} or \code{\link{pb}}. 
  These make use of function \code{add.center} for this purpose.

  Center points are added to designs for three main reasons: 
  they provide a repeated benchmark run that can alert the experimenter to unplanned changes in experimental conditions, 
  they provide an independent estimate of experimental error, and finally they provide a possibility for 
  checking whether a first order model is sufficient. Especially for the first purpose, 
  package FrF2 follows the recommendation in Montgomery (2001, p.275). To distinguish them from the center points, 
  the original fractional factorial runs are called \dQuote{cube points}. 
  
  Addition of center points does not affect estimates for main effects and interactions. 
  The difference between the averages of cube points and center points gives an indication whether 
  quadratic terms might be needed in the model.
  
  For blocked designs and properly replicated designs, 
  \code{ncenter} center points are added to \emph{each} (replication) block. 
  In case of repeated measurements, center points are also measured repeatedly.
  
  Center points are distributed as evenly as possible over the \code{distribute} selected 
  positions throughout each block. \code{distribute=1} always adds all center points at the end of 
  each block. If \code{distribute > 1}, (each block of) the design starts and ends 
  with a (group of) center point(s), 
  and the \code{distribute} positions for placing center points are as evenly 
  placed throughout (each block of) the design as possible. \cr
  If \code{ncenter} is not a multiple of \code{distribute}, 
  some center point groups have one more center point than others. If \code{ncenter\%\%distribute} 
  is one or two only, the beginning and (for two) the end of (each block of) the design have one more center point, 
  otherwise the \code{ncenter\%\%distribute} extra center points are randomized over the center point positions.
  
  Function \code{\link[DoE.base]{iscube}} from package \pkg{DoE.base} 
  provides a logical vector that is TRUE for cube points 
  and FALSE for center points, which allows to use of simple functions 
  for \dQuote{clean} 2-level fractional factorials like \code{MEPlot}. 
}
\value{
  A data frame of class design with \code{ncenter} center point runs per block 
  (or per replication block) added to the \code{design} 
  (and its \code{desnum} and \code{run.order} attributes). 
  The run.no.in.std.order column of run.order is \dQuote{0} for the center points.
  
  Existing response values for cube runs are preserved, and response values for the 
  new center point runs are NA. Note, however, that center points should be added 
  BEFORE running the experiment in order to benefit from all their useful properties; 
  this should best be done within functions \code{\link{pb}} or \code{\link{FrF2}}.
  
  The design is identifiable as a design with center points by the 
  suffix \code{.center} to the \code{type} element of attribute \code{design.info},
  and the elements \code{ncube} and \code{ncenter} are added 
  (with the updated \code{nruns} being their sum). The element \code{coding} is 
  also added to the \code{design.info}, in order to support steepest ascent/descent 
  analysis from the center point.

}
\references{

    Montgomery, D.C. (2001). \emph{Design and Analysis of Experiments (5th ed.)}. Wiley, New York.

}
\author{
Ulrike Groemping
}
\note{
    This function is still somewhat experimental.
}

\seealso{
See also as \code{\link{pb}}, \code{\link{FrF2}}
}
\examples{
  ## purely technical example 
  plan <- FrF2(8,5, factor.names=c("one","two","three","four","five"))
  add.center(plan, 6)
  add.center(plan, 6, distribute=1)
  add.center(plan, 6, distribute=6)
  add.center(plan, 6, distribute=4)
  
  ## very artificial analysis example
    plan <- FrF2(8,4, factor.names=list(one=c(0,10),two=c(1,3),three=c(25,32),four=c(3.7,4.8)))
  ## add some response data
    y <- c(2+desnum(plan)\%*\%c(2,3,0,0) +
       1.5*apply(desnum(plan)[,c(1,2)],1,"prod") + rnorm(8))
       ## the "c()" makes y into a vector rather than a 1-column matrix
    plan <- add.response(plan, y)
  ## analysing this design provides an impression
    MEPlot(lm(y~(.)^2, plan))
    IAPlot(lm(y~(.)^2, plan))
    DanielPlot(lm(y~(.)^2,plan), half=TRUE, alpha=0.2)
  ## tentative conclusion: factors one and two do something
  ## wonder whether the model with one and two and their interaction is sufficient
  ## look at center points (!!! SHOULD HAVE BEEN INCLUDED FROM THE START,
  ##      but maybe better now than not at all)
  ## use distribute=1, because all center points are run at the end
    planc <- add.center(plan, 6, distribute=1)
      ## conduct additional runs for the center points
        y <- c(y, c(2+desnum(planc)[!iscube(planc),1:4]\%*\%c(2,3,0,0) +
             1.5*apply(desnum(planc)[!iscube(planc),][,c(1,2)],1,"prod") + rnorm(6)))
  ## add to the design
    planc <- add.response(planc, y, replace=TRUE)
  ## sanity check: repeat previous analyses for comparison, with the help of function iscube()
    MEPlot(lm(y~(.)^2, planc, subset=iscube(planc)))
    IAPlot(lm(y~(.)^2, planc, subset=iscube(planc)))
    DanielPlot(lm(y~(.)^2, planc, subset=iscube(planc)), half=TRUE, alpha=0.2)
  ## quick check whether there a quadratic effect is needed: is the cube indicator significant ?
    summary(lm(y~(.)^2+iscube(planc), planc))
        ## (in this unrealistic example, the quadratic effect is dominating everything else;
        ## with an effect that strong in practice, it is likely that
        ## one would either have expected a strong non-linearity before conducting the experiment, 
        ## OR that the effect is not real but the result of some stupid mistake
  ## alternatively, the check can be calculated per hand (cf. e.g. Montgomery, Chapter 11):
    (mean(planc$y[iscube(planc)])-mean(planc$y[!iscube(planc)]))^2*8*6/(8+6)/var(y[!iscube(planc)])
    ## must be compared to the F-quantile with 1 degree of freedom
    ## is the square of the t-value for the cube indicator in the linear model
   }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ design }
\keyword{ array }% __ONLY ONE__ keyword per line
