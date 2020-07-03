\name{FrF2-package}
\alias{FrF2-package}
\docType{package}
\title{
Fractional Factorial designs with 2-level factors
}
\description{
creates regular and non-regular Fractional Factorial 2-level designs. 
Furthermore, analysis tools for Fractional Factorial designs with 2-level factors 
are offered (main effects and interaction plots for all factors simultaneously, 
cube plot for looking at the simultaneous effects of three factors, full or half normal plot, 
alias structure in a more readable format than with the built-in function alias). 

The package works together with packages DoE.base and DoE.wrapper.
}
\details{
The package is still subject to development; most key functionality is now included. 
Please contact me, if you have suggestions.

This package designs and analyses Fractional Factorial experiments with 2-level factors. 
Regular (function \code{\link{FrF2}}) and non-regular (function \code{\link{pb}}) 2-level fractional factorial 
designs can be generated. For regular fractional factorials, function \code{\link{FrF2}} 
permits the specification of effects of interest, whose estimation is requested clear of aliasing 
with other effects. The function can furthermore generate regular fractional factorials 
as blocked or split-plot designs, and hard-to-change 
factors can be specified in order to keep the number of level changes low.
Regular resolution V designs larger than those obtainable from function \code{FrF2} 
can be created by function \code{\link{FrF2Large}} (these are not guaranteed to be optimal). 
Analysis facilities work for completely aliased designs only, 
i.e. e.g. not for analysing Plackett-Burman designs with interactions. 

Functions \code{fac.design}, \code{fractionate} or \code{oa.design} from 
Chambers and Hastie (1993) have been used as role models e.g. for 
the option \code{factor.names} or for outputting a data frame with attributes. 
However, S compatibility has not been considered in devising this package. The original 
above-mentioned functions are not available in \code{R}; similar 
functions have been implemented in package \pkg{\link[DoE.base:DoE.base-package]{DoE.base}} 
together with other general functionality for experimental designs.

In terms of analysis, package \code{FrF2} works on linear models and enables convenient main effects and 
interaction plots (functions \code{MEPlot} and \code{IAPlot}) similar to those 
offered by Minitab software for all factors simultaneously, even though especially the 
interactions are often aliased, i.e. the model is typically singular. 
For the (less frequent) case of suspected three-factor-interactions, function 
\code{cubePlot} displays a cube with corners labeled with the (modeled) 
means of three factors simultaneously.
Furthermore, the function \code{DanielPlot} from package \pkg{BsMD} has been 
modified to automatically label effects significant according to the 
Lenth-criterion, to automatically distinguish between whole-plot and 
split-plot effects for split-plot designs, and to provide more usage comfort 
to the analyst.\cr
Finally, the function \code{aliases} determines the alias structure of a 
Fractional Factorial 2-level design in a format more suitable for human readers 
than the output from the built-in function \code{alias}. 

}
\author{
Ulrike Groemping

Maintainer: Ulrike Groemping <groemping@bht-berlin.de>
}
\references{
    Box G. E. P, Hunter, W. C. and Hunter, J. S. (2005) 
    \emph{Statistics for Experimenters, 2nd edition}.
    New York: Wiley.
    
    Chambers, J.M. and Hastie, T.J. (1993). \emph{Statistical Models in S}, 
    Chapman and Hall, London.
     
    Chen, J., Sun, D.X. and Wu, C.F.J. (1993) 
    A catalogue of 2-level and 3-level orthogonal arrays. 
    \emph{International Statistical Review} \bold{61}, 131-145.

    Daniel, C. (1959) 
    Use of Half Normal Plots in Interpreting Two Level Experiments.
    \emph{Technometrics}, \bold{1}, 311-340.
    
    Groemping, U. (2014). {R} Package {FrF2} for Creating and Analyzing Fractional 
    Factorial 2-Level Designs. \emph{Journal of Statistical Software}, \bold{56}, 
    Issue 1, 1-56. \url{http://www.jstatsoft.org/v56/i01/}.
    
    Hedayat, A.S., Sloane, N.J.A. and Stufken, J. (1999) 
    \emph{Orthogonal Arrays: Theory and Applications}, Springer, New York. 
    
    Lenth, R.V. (1989) Quick and easy analysis of unreplicated factorials.
    \emph{Technometrics}, \bold{31}, 469-473.
  
    Mee, R. (2009). \emph{A Comprehensive Guide to Factorial Two-Level Experimentation}. 
    New York: Springer.
    
    Montgomery, D.C. (2001). Design and Analysis of Experiments (5th ed.). Wiley, New York.

    Plackett, R.L.; Burman, J.P. (1946) The design of optimum multifactorial 
     experiments. \emph{Biometrika} \bold{33}, 305-325.
     
    Ryan, K.J. and Bulutoglu, D.A. (2010). Minimum Aberration Fractional Factorial Designs With Large N.
      \emph{Technometrics} \bold{52}, 250-255.

    Sanchez, S.M. and Sanchez, P.J. (2005). Very Large Fractional Factorial 
     and Central Composite Designs. 
     \emph{ACM Transactions on Modeling and Computer Simulation} 
     \bold{15}, 362-377.
}
\keyword{ array }
\keyword{ design }
\seealso{
The key design generating functions: \code{\link{FrF2}}, \code{\link{pb}}, \code{\link{FrF2Large}}\cr
S3 class \code{\link[DoE.base:class-design]{design}}\cr 
Related packages: 
\code{\link[DoE.base:DoE.base-package]{DoE.base}}, 
\code{\link[DoE.wrapper:DoE.wrapper-package]{DoE.wrapper}}, 
\code{\link[BsMD:BsMD-package]{BsMD}};\cr 
Graphical analysis functions: \code{\link{MEPlot}}, \code{\link{IAPlot}}, \code{\link{cubePlot}}, 
\code{\link{DanielPlot}}\cr
Analysis of alias structure for linear models of \code{FrF2} designs: \code{\link{aliases}}\cr
}
\examples{
    ### for examples on design generation, cf. functions pb and FrF2
  
    ### Injection Molding Experiment. Box et al. 1978.
    data(BM93.e3.data, package="BsMD")  #from BsMD
    iMdat <- BM93.e3.data[1:16,2:10]  #only original experiment
    # make data more user-friendly
    colnames(iMdat) <- c("MoldTemp","Moisture","HoldPress","CavityThick","BoostPress",
             "CycleTime","GateSize","ScrewSpeed", "y")
    # linear model with all main effects and 2-factor interactions
    iM.lm <- lm(y ~ (.)^2, data = iMdat)
    # determine aliases
    aliases(iM.lm)
    # coded version
    aliases(iM.lm, code=TRUE)
    # normal plot of effects, default is autolabel with alpha=0.05
    DanielPlot(iM.lm)  
    DanielPlot(iM.lm,code=TRUE)
    DanielPlot(iM.lm,code=TRUE,alpha=0.5)
    # half normal plot of effects
    DanielPlot(iM.lm,code=TRUE,alpha=0.5,half=TRUE)
    # main effects plots
    MEPlot(iM.lm)
    # interaction plots
    IAPlot(iM.lm)
    # interaction plots with attention drawn to aliases
    aus <- IAPlot(iM.lm, show.alias=TRUE)
    # alias groups corresponding to interaction plots
    aliases(iM.lm)$aliases[9:15]
    # returned object
    aus
    # cube plot of three factors
    # (not very useful for this model, for demonstration only)
      ## per default, modeled means are shown
      ## this does not make a difference here, since the main effect of 
      ## ScrewSpeed is confounded with the MoldTemp:HoldPress:BoostPress
      ## interaction, so that the three-factor-interaction is indirectly included 
      ## in the modeled means
      cubePlot(iM.lm, "MoldTemp", "HoldPress", "BoostPress")
      ## modeled means without a three-factor interaction
      cubePlot(lm(y ~ (MoldTemp+HoldPress+BoostPress)^2, data = iMdat), 
         "MoldTemp", "HoldPress", "BoostPress")
      ## modeled=FALSE reverts to showing the apparent three-factor interaction
      cubePlot(lm(y ~ (MoldTemp+HoldPress+BoostPress)^2, data = iMdat), 
         "MoldTemp", "HoldPress", "BoostPress", modeled=FALSE)
      ## cubePlot also works on raw data
      cubePlot(iMdat$y, iMdat$MoldTemp, iMdat$HoldPress, iMdat$BoostPress)
    ## plotting functions also work directly on designs, 
    ## if these have been generated from functions FrF2 or pb:
      plan <- FrF2(16, 7)
      plan <- add.response(plan, rnorm(16))
      MEPlot(plan)
      IAPlot(plan)
      DanielPlot(plan)
      
}
